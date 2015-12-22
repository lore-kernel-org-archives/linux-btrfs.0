Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33228 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbbLVUCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 15:02:19 -0500
Received: by mail-ig0-f181.google.com with SMTP id mv3so55975624igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 12:02:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
Date: Tue, 22 Dec 2015 13:02:18 -0700
Message-ID: <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
From: Chris Murphy <lists@colorremedies.com>
To: Dave S <bigdave.schulz@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 22, 2015 at 12:12 PM, Dave S <bigdave.schulz@gmail.com> wrote:
> To ensure it wasn't picking up a fsid from an old test I dd'd out the
> 3 superblock locations on each disk and re-ran the test.  Same
> results.

The fsid is strewn throughout the fs metadata, not just in
superblocks, so it might be finding a stale fsid. I find dmcrypt
useful for fast formatting a drive, just luksFormat and use the same
passphrase. In your case this is a PITA because of how many drives you
have. A pile of SEDs would make this much easier with crypto erase and
no unlock passphrase.

Of course, stale metadata shouldn't confuse the filesystem so it's
possible you've found a bug. It's hard to say with the kernel you have
just exactly what equivalent upstream btrfs kernel code you have
though, maybe through 3.19? But even 3.19 to 4.4 there's a lot of code
changes.

> One curiosity is that the write that is happening when I pull the SAS
> cable continues uninterrupted -- I have left it for a few minutes and
> it doesn't seem to stop.

Right. As far as I know btrfs has no understanding of failed devices
at all, when they should be ignored and go degraded, and not even when
there are too many failures and the volume needs to go read only.

Also understand with Brfs RAID 10 you can't lose more than 1 drive
reliably. It's not like a strict raid1+0 where you can lose all of the
"copy 1" *OR* "copy 2" mirrors. With a two drive failure, maybe it'll
let you mount -o degraded, but there's no way to know in advance
(either by the user or the fs) whether or not there's missing metadata
copies 1 and 2 possibly on those two particular drives that are now
gone. So really there's more than one kind of degraded in such a case,
1 device loss is degraded all data intact. 2+ device loss is degraded
with increasing chances of data loss for each lost drive, and you have
fully 50% lost drives in this test case so the volume is imploded and
just doesn't know what to do.




-- 
Chris Murphy
