// codeunit 50100 CheckRemainingQtyCodeunit
// {
//     // Đăng ký sự kiện OnBeforeSet
//     [EventSubscriber(ObjectType::Page, Page::"Change Status on Prod. Order", 'OnBeforeSet', '', false, false)]
//     local procedure OnBeforeSetCheckRemainingQty(var ProdOrder: Record "Production Order")
//     var
//         ProdOrderLine: Record "Prod. Order Line";
//         RemainingQtyErr: Label 'Cannot change the status of Production Order %1 because there are lines with Remaining Quantity greater than 0.';
//     begin
//         // Kiểm tra các dòng Prod Order Line có Remaining Quantity > 0
//         ProdOrderLine.SetRange(Status, ProdOrder.Status);
//         ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
//         ProdOrderLine.SetFilter("Remaining Quantity", '>0');
//         if not ProdOrderLine.IsEmpty() then
//             Error(RemainingQtyErr, ProdOrder."No.");
//     end;

//     // Đăng ký sự kiện OnBeforeReturnPostingInfo
//     [EventSubscriber(ObjectType::Page, Page::"Change Status on Prod. Order", 'OnBeforeReturnPostingInfo', '', false, false)]
//     local procedure OnBeforeReturnPostingInfoCheckRemainingQty(var Status: Enum "Production Order Status"; var PostingDate2: Date; var UpdUnitCost: Boolean; var IsHandled: Boolean; var NewFinishOrderWithoutOutput: Boolean)
//     var
//         ProdOrder: Record "Production Order";
//         ProdOrderLine: Record "Prod. Order Line";
//         ProdOrderStatus: Record "Production Order";
//         RemainingQtyErr: Label 'Cannot change the status of Production Order %1 because there are lines with Remaining Quantity greater than 0.';
//     begin
//         // Lấy số Production Order từ biến toàn cục ProdOrderStatus của page
//         if ProdOrderStatus.Get(Status, ProdOrderStatus."No.") then begin
//             ProdOrderLine.SetRange(Status, ProdOrder.Status);
//             ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
//             ProdOrderLine.SetFilter("Remaining Quantity", '>0');
//             if not ProdOrderLine.IsEmpty() then
//                 Error(RemainingQtyErr, ProdOrder."No.");
//         end;
//     end;
// }
codeunit 50100 CheckRemainingQtyCodeunit
{
    // Đăng ký sự kiện OnBeforeSet
    [EventSubscriber(ObjectType::Page, Page::"Change Status on Prod. Order", 'OnBeforeSet', '', false, false)]
    local procedure OnBeforeSetCheckRemainingQty(var ProdOrder: Record "Production Order")
    var
        ProdOrderLine: Record "Prod. Order Line";
        ItemA: Code[20];
        RemainingQtyErr: Label 'Cannot change the status of Production Order %1 because Item %2 has Remaining Quantity greater than 0 in Released status.';
    begin
        // Chỉ kiểm tra khi Production Order ở trạng thái Released
        if ProdOrder.Status = ProdOrder.Status::Released then begin
            // Lấy Item A từ Production Order (trường "Source No.")
            ItemA := ProdOrder."Source No.";

            // Kiểm tra các dòng Prod Order Line có Item No. khớp với Item A và Remaining Quantity > 0
            if ItemA <> '' then begin
                ProdOrderLine.SetRange(Status, ProdOrder.Status);
                ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
                ProdOrderLine.SetRange("Item No.", ItemA);
                ProdOrderLine.SetFilter("Remaining Quantity", '>0');
                if not ProdOrderLine.IsEmpty() then
                    Error(RemainingQtyErr, ProdOrder."No.", ItemA);
            end;
        end;
    end;
}