Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:63529 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaGYC1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 22:27:44 -0400
Received: by mail-lb0-f181.google.com with SMTP id 10so2853703lbg.40
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 19:27:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53CE7ACF.7070109@fb.com>
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
	<53C7CD0F.7070603@fb.com>
	<CAPoQQ-1PcyPgJ4eoicP4xM8RShA2qo77fM7kqU5eKKUM2cmuUQ@mail.gmail.com>
	<1745216.hDa4tC2HJJ@merkaba>
	<53CE7ACF.7070109@fb.com>
Date: Thu, 24 Jul 2014 21:27:42 -0500
Message-ID: <CAPoQQ-3ceufwBNUOGsObwX8AMC5LZBDy6imZD3BaX+8B2_=W-w@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Cody P Schafer <dev@codyps.com>
To: Chris Mason <clm@fb.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, Chris Samuel <chris@csamuel.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 22, 2014 at 9:53 AM, Chris Mason <clm@fb.com> wrote:
>
>
> On 07/19/2014 02:23 PM, Martin Steigerwald wrote:
>
>>> Running 3.15.6 with this patch applied on top:
>>>  - still causes a hang with `rsync -hPaHAXx --del /mnt/home/nyx/ /home/nyx/`
>>> - no extra error messages printed (`dmesg | grep racing`) compared to
>>> without the patch
>>
>> I got same results with 3.16-rc5 + this patch (see thread BTRFS hang with
>> 3.16-rc5). 3.16-rc4 still is fine with me. No hang whatsoever so far.
>>
>>> To recap some details (so I can have it all in one place):
>>>  - /home/ is btrfs with compress=lzo
>>
>> BTRFS RAID 1 with lzo.
>>
>>>  - I have _not_ created any nodatacow files.
>>
>> Me neither.
>>
>>>  - Full stack is: sata <-> dmcrypt <-> lvm <-> btrfs (I noticed others
>>> mentioning the use of dmcrypt)
>>
>> Same, except no dmcrypt.
>>
>
> Thanks for the help in tracking this down everyone.  We'll get there!
> Are you all running multi-disk systems (from a btrfs POV, more than one
> device?)  I don't care how many physical drives this maps to, just does
> btrfs think there's more than one drive.

No, both of my btrfs filesystems are single disk.
