Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:33578
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932586AbcKGSxy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 13:53:54 -0500
Subject: Re: Announcing btrfs-dedupe
To: Mark Fasheh <mfasheh@versity.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
Cc: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@pharaoh.uk>
Message-ID: <4bda2fea-1e25-08ef-c898-3c67f58a3e16@pharaoh.uk>
Date: Mon, 7 Nov 2016 19:53:49 +0100
MIME-Version: 1.0
In-Reply-To: <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FWIW I have updated my comments about duperemove and also the "caveat" 
section you mentioned in your other mail in the readme.

http://btrfs-dedupe.com

James

On 07/11/16 19:49, James Pharaoh wrote:
> Annoyingly I can't find this now, but I definitely remember reading
> someone, apparently someone knowledgable, claim that the latest version
> of the kernel which I was using at the time, still suffered from issues
> regarding the dedupe code.
>
> This was a while ago, and I would be very pleased to hear that there is
> high confidence in the current implementation! I'll post a link if I
> manage to find the comments.
>
> James
>
> On 07/11/16 18:59, Mark Fasheh wrote:
>> Hi James,
>>
>> Re the following text on your project page:
>>
>> "IMPORTANT CAVEAT — I have read that there are race and/or error
>> conditions which can cause filesystem corruption in the kernel
>> implementation of the deduplication ioctl."
>>
>> Can you expound on that? I'm not aware of any bugs right now but if
>> there is any it'd absolutely be worth having that info on the btrfs
>> list.
>>
>> Thanks,
>>     --Mark
>>
>>
>> On Sun, Nov 6, 2016 at 7:30 AM, James Pharaoh
>> <james@wellbehavedsoftware.com> wrote:
>>> Hi all,
>>>
>>> I'm pleased to announce my btrfs deduplication utility, written in Rust.
>>> This operates on whole files, is fast, and I believe complements the
>>> existing utilities (duperemove, bedup), which exist currently.
>>>
>>> Please visit the homepage for more information:
>>>
>>> http://btrfs-dedupe.com
>>>
>>> James Pharaoh
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
