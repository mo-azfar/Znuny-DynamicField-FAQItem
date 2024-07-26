// --
// Copyright (C) 2024 mo-azfar, https://github.com/mo-azfar
// --
// This software comes with ABSOLUTELY NO WARRANTY. For details, see
// the enclosed file COPYING for license information (AGPL). If you
// did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
// --

"use strict";

var ZZZ = ZZZ || {};
ZZZ.DynamicField = ZZZ.DynamicField || {};

/**
 * @namespace ZZZ.DynamicField.FAQItem
 * @memberof ZZZ.DynamicField
 * @description
 *      This namespace contains the functions for handling DynamicField.FAQItem.
 */
ZZZ.DynamicField.FAQItem = (function (TargetNS) {

    /**
     * @name Init
     * @memberof ZZZ.DynamicField.FAQItem
     * @function
     * @description
     *      Initializes the module functionality.
     */
    TargetNS.Init = function () {
        TargetNS.ExpandDynamicFAQItemRow();
        TargetNS.CreateDynamicFAQItemSpan();
        TargetNS.CreateDynamicFAQItemIframe();
    };

    TargetNS.ExpandDynamicFAQItemRow = function() {
        $('.DynamicFieldFAQItem').each(function() {
            var FAQID = $(this).attr('id');
            var FAQField = $('#' + FAQID);
            var $RowDiv = FAQField.closest('div.Row');
            if ($RowDiv.hasClass('col-wide-33') || $RowDiv.hasClass('col-wide-50')) {
                $RowDiv.removeClass('col-wide-33 col-wide-50').addClass('col-wide-100');
            }
            if ($RowDiv.hasClass('col-desktop-33') || $RowDiv.hasClass('col-desktop-50')) {
                $RowDiv.removeClass('col-desktop col-desktop-50').addClass('col-desktop-100');
            }
            if ($RowDiv.hasClass('col-tablet-33') || $RowDiv.hasClass('col-tablet-50')) {
                $RowDiv.removeClass('col-tablet-33 col-tablet-50').addClass('col-tablet-100');
            }
        });
    }

    TargetNS.CreateDynamicFAQItemSpan = function() {
        
        $('.DynamicFieldFAQItem').each(function() {
            var FAQID = $(this).attr('id');
            var FAQField = $('#' + FAQID);
            var FieldDiv = FAQField.closest('.Field');
            FieldDiv.append('<span class="faq-item-info" id="' + FAQID + '"></span>');
        });
       
    }

    TargetNS.CreateDynamicFAQItemIframe = function() {

        $('.DynamicFieldFAQItem').each(function() {
            var FAQID = $(this).attr('id');
            var FAQField = $('#' + FAQID);
            var FieldDiv = FAQField.closest('.Field');
            
            FAQField.on('change', function() {

                var FAQItem = $(this).val();
                var AppendTo = FieldDiv.find('span.faq-item-info');
                AppendTo.empty();
    
                //turn single selection to array. This is to make it consistent with multiple selection.
                if (typeof(FAQItem) === 'string') {
                    FAQItem = [FAQItem];
                }

                if (FAQItem.length === 1 && FAQItem[0] === '') {
                    return;
                }
    
                //send data
                Core.AJAX.FunctionCall(
                Core.Config.Get("CGIHandle") + "?Action=AJAXDynamicFieldFAQItem",
                {
                    Subaction: "GetFAQItemData",
                    SelectedIDs: FAQItem,
                },
                function (Response) {
                    if (!Response) {
                        return;
                    }
    
                    for (var Key in Response.FAQ) {
                        var FAQ = Response.FAQ[Key];

                        // Update title attribute for the corresponding item in the tree
                    $('#DynamicField_FAQList_Select').find('li[data-id="' + Key + '"][aria-selected="true"]').attr('title', 'HAHAHHA');
                       
                        //append another span to the parent span
                        AppendTo.append('<span class="each-faq-item" data-attr="' + Key + '">FAQ#' + FAQ.Number + ' - ' + FAQ.Title + '</span>');

                        AppendTo.append('<div id="each-faq-item-iframe-' + Key +'" class="Hidden"> ' + FAQ.Solution + '</div>');
    
                        //append div with iframe to the span
                        //AppendTo.append('<div id="each-faq-item-iframe-' + Key +'" class="Hidden"><iframe sandbox="allow-same-origin allow-popups allow-popups-to-escape-sandbox" frameborder="0" id="Iframe_FAQ_' + Key + '" srcdoc="' + FAQ.Solution + '" height="800"></iframe></div>');
                    }
                },
                "json"
                );
            }).trigger('change');

        });

        $(document).on('click', '.each-faq-item', TargetNS.ShowDynamicFAQItemInfo);

    };

    TargetNS.ShowDynamicFAQItemInfo = function() {
        
        var FAQID = $(this).data('attr');
        var FAQTitle = $(this).text();

        var HTML = $('#each-faq-item-iframe-' + FAQID).text();
        
        //show modal
        Core.UI.Dialog.ShowDialog({
            Modal: 'true',
            Title: FAQTitle,
            HTML: HTML,
            PositionTop: '10px',
            PositionLeft: '15%',
            AllowAutoGrow: 'true',
            CloseOnEscape: 'true',
            //call the biggest modal size
            Class: 'modal-lg',
            HideFooter: 'true',
        });

        return false;
    }

    Core.Init.RegisterNamespace(TargetNS, 'APP_MODULE');

    return TargetNS;
}(ZZZ.DynamicField.FAQItem || {}));