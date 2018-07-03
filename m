Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sn1nam02on0109.outbound.protection.outlook.com ([104.47.36.109]:53854
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750764AbeGCX0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 19:26:36 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: A list of bugs in btrfs found by fuzzing
Date: Tue, 3 Jul 2018 23:26:34 +0000
Message-ID: <C9F5718B-2BAA-497F-897C-35436778738E@gatech.edu>
References: <CANrHXgx5rPHOc9rYBEskwj6dt3r-KXUxhnph8b8gAwDTeCEixw@mail.gmail.com>
 <F54B32A6-F142-4BEF-9279-A85C593C9BE6@gatech.edu>
 <b64c777f-68e2-a373-fafa-7727a0e12bc2@gmx.com>
 <4A4B5ACC-09BA-4C26-B062-5454DA4B60F8@gatech.edu>
 <802fb262-8204-1639-9a8d-0829881a2270@gmx.com>
 <D1C443C6-9EBD-4F4D-B60E-5CC7D22BC3C0@gatech.edu>
 <6408ed6e-12c0-c34c-a940-c559e238a212@gmx.com>
In-Reply-To: <6408ed6e-12c0-c34c-a940-c559e238a212@gmx.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I see, then does BTRFS have a dev branch for merging into mainline?â€¦

Thanks,
Wen

> On Jul 3, 2018, at 6:36 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> 
> 
> 
> On 2018å¹´07æœˆ04æ—¥ 00:27, Xu, Wen wrote:
>> So this is the dev branch of btrfs?â€¦
> 
> Just my branch of all the related fixes.
> 
> Thanks,
> Qu
> 
>> 
>> Thanks,
>> -Wen
>> 
>>> On Jul 3, 2018, at 9:36 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>> 
>>> 
>>> 
>>> On 2018å¹´07æœˆ03æ—¥ 20:37, Xu, Wen wrote:
>>>> Sure, thanks for your efforts! So as I suppose, 199833 and 199835 are implicitly fixed by these patches as well?
>>>> 
>>>> -Wen
>>> 
>>> Yep.
>>> 
>>> Kernel can know detect all related chunk <-> block group mapping problem
>>> in all 6 images and exit gracefully with error message showing what's
>>> going wrong.
>>> 
>>> You could also test using this branch:
>>> https://github.com/adam900710/linux/tree/tree_checker_enhance
>>> 
>>> Thanks,
>>> Qu
>>> 
>>> 
>>>> 
>>>>> On Jul 3, 2018, at 4:32 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>> 
>>>>> 
>>>>> 
>>>>> On 2018å¹´07æœˆ01æ—¥ 08:06, Xu, Wen wrote:
>>>>>> Dear BTRFS developers,
>>>>>> 
>>>>>> I would like to know if these issues are fixed or handled? Thanks.
>>>>>> 
>>>>>> -Wen
>>>>> 
>>>>> All these images should be addressed by the following patches now:
>>>>> https://patchwork.kernel.org/patch/10503415/
>>>>> https://patchwork.kernel.org/patch/10503413/
>>>>> https://patchwork.kernel.org/patch/10503403/
>>>>> https://patchwork.kernel.org/patch/10503147/
>>>>> https://patchwork.kernel.org/patch/10503099/
>>>>> 
>>>>> Some of them may need extra cosmetic updates, but the basic fix should
>>>>> not change much.
>>>>> 
>>>>> If you have any newer fuzzed image which could pass kernel mount and
>>>>> cause unexpected behavior, feel free to submit them to btrfs maillist
>>>>> and kernel bugzilla.
>>>>> 
>>>>> Thanks,
>>>>> Qu
>>>>> 
>>>>>> 
>>>>>>> On Jun 3, 2018, at 6:22 PM, Wen Xu <xuwen.sjtu@gmail.com> wrote:
>>>>>>> 
>>>>>>> Hi btrfs maintainers and developers,
>>>>>>> 
>>>>>>> Here are a list of bugs found in upstream kernel recently. Please check:
>>>>>>> 
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199833
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199835
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199837
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199839
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199847
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=199849
>>>>>>> 
>>>>>>> Thanks,
>>>>>>> Wen
>>>>>> 
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> 
>>>> Nï¿½ï¿½ï¿½ï¿½ï¿½rï¿½ï¿½yï¿½ï¿½ï¿½bï¿½Xï¿½ï¿½Ç§vï¿½^ï¿½)Şº{.nï¿½+ï¿½ï¿½ï¿½ï¿½{ï¿½nï¿½ß²)ï¿½ï¿½ï¿½w*jgï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½İ¢j/ï¿½ï¿½ï¿½zï¿½Ş–ï¿½ï¿½2ï¿½Ş™ï¿½ï¿½ï¿½&ï¿½)ß¡ï¿½aï¿½ï¿½ï¿½ï¿½ï¿½Gï¿½ï¿½ï¿½hï¿½ï¿½j:+vï¿½ï¿½ï¿½wï¿½Ù¥
>> 
>> Nï¿½ï¿½ï¿½ï¿½ï¿½rï¿½ï¿½yï¿½ï¿½ï¿½bï¿½Xï¿½ï¿½Ç§vï¿½^ï¿½)Şº{.nï¿½+ï¿½ï¿½ï¿½ï¿½{ï¿½nï¿½ß²)ï¿½ï¿½ï¿½w*jgï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½İ¢j/ï¿½ï¿½ï¿½zï¿½Ş–ï¿½ï¿½2ï¿½Ş™ï¿½ï¿½ï¿½&ï¿½)ß¡ï¿½aï¿½ï¿½ï¿½ï¿½ï¿½Gï¿½ï¿½ï¿½hï¿½ï¿½j:+vï¿½ï¿½ï¿½wï¿½Ù¥

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
