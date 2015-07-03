Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34074 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbbGCPFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jul 2015 11:05:21 -0400
Received: by obbkm3 with SMTP id km3so70831675obb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 08:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477911.JnaWx19SzT@merkaba>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
 <CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
 <pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net> <1477911.JnaWx19SzT@merkaba>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Fri, 3 Jul 2015 10:05:00 -0500
Message-ID: <CAC=t97D07H1LaE=Qa=jUtwGp16oyh6YWEL7YbOKNTU9jBbaL+Q@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the inputs guys.

Yes I did learn to perform a device scan --all-devices.  It seems that
the chunk tree is vital to a lot of functionality and the recovery
tools are no exception.

I suspect that I ran in to the raid56 caveat "btrfs does not deal well
with a drive that is present but not working" described here
:http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html
There is also mention here of some caveats with raid56 and drives that
are no good and/or out of sync are still picked right up by the pool
leading to data loss.
I should have studied more cloesly earlier, because issuing a btrfs
device delete is exactly what I tried to do and things went down hill
from there.

I did some more digging and found that I had a lot of errors basically
every drive.  I think the incident that caused my backup pool to fail
did more harm that I initially thought.  Last night I disassembled the
box and inspected/re-seated everything and now I'm scanning each
device for read and write errors.

So one particularly bad drive + multiple raid56 caveats + all the
other drives behaving a little funny + a guy who didn't read as well
as he should, and I really can't be surprised at the result.

So I've decided to cash in the pool for some valueable lessons and
move on.  Thanks to everybody for your thoughts and help here and on
IRC (a responsive IRC, that's a refereshing difference) and I'll see
what adventures btrfs round 2 brings.

Regards,
Donald (seijirou)




On Fri, Jul 3, 2015 at 8:29 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> On Friday 03 July 2015 09:31:03 Duncan wrote:
>> Donald Pearson posted on Thu, 02 Jul 2015 13:19:41 -0500 as excerpted:
>> > btrfs restore complains that every device is missing except the one that
>> > you specify on executing the command.  Multiple devices as a parameter
>> > isn't an option.  Specifcy /dev/disk/by-uuid/<uuid> claims that all
>> > devices are missing.
>>
>> That sounds like the kernel lost track of what devices correspond with
>> the filesystem.  Try issuing the btrfs device scan command before
>> restore, and see if that changes things.  (If it doesn't, try btrfs
>> device scan --all-devices, just in case.)
>
> Also does blkid and/or file-sk onto each device show that the BTRFS
> signatures are still there?
>
> --
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
