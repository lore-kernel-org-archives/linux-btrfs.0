Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35405 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbcDBRSC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Apr 2016 13:18:02 -0400
Received: by mail-lf0-f41.google.com with SMTP id k79so113203307lfb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Apr 2016 10:18:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160402110001.0ec354b5@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
Date: Sat, 2 Apr 2016 19:17:55 +0200
Message-ID: <CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 2, 2016 at 11:00 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Fri, 1 Apr 2016 01:27:21 +0200
> schrieb Henk Slager <eye1tm@gmail.com>:
>
>> It is not clear to me what 'Gentoo patch-set r1' is and does. So just
>> boot a vanilla v4.5 kernel from kernel.org and see if you get csum
>> errors in dmesg.
>
> It is the gentoo patchset, I don't think anything there relates to
> btrfs:
> https://dev.gentoo.org/~mpagano/genpatches/trunk/4.5/
>
>> Also, where does 'duplicate object' come from? dmesg ? then please
>> post its surroundings, straight from dmesg.
>
> It was in dmesg. I already posted it in the other thread and Qu took
> note of it. Apparently, I didn't manage to capture anything else than:
>
> btrfs_run_delayed_refs:2927: errno=-17 Object already exists
>
> It hit me unexpected. This was the first time btrfs went RO for me. It
> was with kernel 4.4.5 I think.
>
> I suspect this is the outcome of unnoticed corruptions that sneaked in
> earlier over some period of time. The system had no problems until this
> incident, and only then I discovered the huge pile of corruptions when I
> ran btrfsck.
>
> I'm also pretty convinced now that VirtualBox itself is not the problem
> but only victim of these corruptions, that's why it primarily shows up
> in the VDI file.
>
> However, I now found csum errors in unrelated files (see other post in
> this thread), even for files not touched in a long time.

Ok, this is some good further status and background. That there are
more csum errors elsewhere is quite worrying I would say. You said HW
is tested, are you sure there no rare undetected failures, like due to
overclocking or just aging or whatever. It might just be that spurious
HW errors just now start to happen and are unrelated to kernel upgrade
from 4.4.x to 4.5.
I had once a RAM module going bad; Windows7 ran fine (at least no
crashes), but when I booted with Linux/btrfs, all kinds of strange
btrfs errors started to appear including csum errors.

The other thing you could think about is the SSD cache partition. I
don't remember if blocks from RAM to SSD get an extra CRC attached
(independent of BTRFS). But if data gets corrupted while in the SSD,
you could get very nasty errors, how nasty depends a bit on the
various bcache settings. It is not unthinkable that dirty changed data
gets written to the harddisks. But at least btrfs (scub) can detect
that (the situation you are in now).

Maybe to further isolate just btrfs, you could temporary rule out
bcache by making sure the cache is clean and then increase the
startsectors of second partitions on the harddisks by 16 (8KiB) and
then reboot. Of course after any write to the partitions, you'll have
to recreate all bcache.

But maybe it is just due to bugs in older kernels that the fs has been
silently corrupted and now kernel 4.5 cannot handle it anymore and any
use of the fs increases corruption.
