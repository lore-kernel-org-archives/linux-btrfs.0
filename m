Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34477 "EHLO
        mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753622AbdEHT0W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:26:22 -0400
Received: by mail-yw0-f176.google.com with SMTP id l14so13000898ywk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 12:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee>
References: <92b9b7cd-5b54-775f-95c1-4788b2d3ea67@hale.ee>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 8 May 2017 13:26:16 -0600
Message-ID: <CAJCQCtRmMtm5PW-TsUw+erQdXC9K41F0Nys5R+CRv0=KRh7aHw@mail.gmail.com>
Subject: Re: "Corrected" errors persist after scrubbing
To: Tom Hale <tom@hale.ee>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 6, 2017 at 4:33 AM, Tom Hale <tom@hale.ee> wrote:
> Below (and also attached because of formatting) is an example of `btrfs
> scrub` incorrectly reporting that errors have been corrected.
>
> In this example, /dev/md127 is the device created by running:
> mdadm --build /dev/md0 --level=faulty --raid-devices=1 /dev/loop0
>
> The filesystem is RAID1.
>
> # mdadm --grow /dev/md0 --layout=rp400
> layout for /dev/md0 set to 12803
> # btrfs scrub start -Bd /mnt/tmp
> scrub device /dev/md127 (id 1) done
>         scrub started at Fri May  5 19:23:54 2017 and finished after
> 00:00:01
>         total bytes scrubbed: 200.47MiB with 8 errors
>         error details: read=8
>         corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
> scrub device /dev/loop1 (id 2) done
>         scrub started at Fri May  5 19:23:54 2017 and finished after
> 00:00:01
>         total bytes scrubbed: 200.47MiB with 0 errors
> WARNING: errors detected during scrubbing, corrected
> # ### But the errors haven't really been corrected, they're still there:
> # mdadm --grow /dev/md0 --layout=clear # Stop producing additional errors
> layout for /dev/md0 set to 31
> # btrfs scrub start -Bd /mnt/tmp
> scrub device /dev/md127 (id 1) done
>         scrub started at Fri May  5 19:24:24 2017 and finished after
> 00:00:00
>         total bytes scrubbed: 200.47MiB with 8 errors
>         error details: read=8
>         corrected errors: 8, uncorrectable errors: 0, unverified errors: 248
> scrub device /dev/loop1 (id 2) done
>         scrub started at Fri May  5 19:24:24 2017 and finished after
> 00:00:00
>         total bytes scrubbed: 200.47MiB with 0 errors
> WARNING: errors detected during scrubbing, corrected
> #


What are the complete kernel messages for the scrub event? This should
show what problem Btrfs detects and how it fixes it, and what sectors
it's fixing each time.



>
> Since scrub is checking for read issues, I expect that it would read any
> corrections before asserting that they have indeed been corrected.

Read errors are fixed by overwrites. If the underlying device doesn't
report an error for the write command, it's assumed to succeed. Even
md and LVM raid's do this.

>
> I understand that HDDs have a pool of non-LBA-addressable sectors set
> aside to mask bad physical sectors, but this pool size is fixed by the
> manufacturer (who makes money from sales of new drives).
>
> However, I don't believe it is sufficient to blindly trust that the
> underlying  HDD still has spare reallocatable sectors or that the
> hardware will always correctly write data, given the verification and
> fixing intention of scrub.

If the is no spare, the drive by spec is supposed to report a write
error. The original sector fails write, and there are no more spares,
that means the write can only fail.

In Btrfs land, it keeps trying to write, I don't think it has a limit.
In md land, this used to be fatal, the block device would be ejected
from the array and not used anymore; but I think there's somewhat
recent patches that optionally allow a badblock map to exist for
tracking sectors that fail writes, and md simply won't use them and
will do it's own remapping.


>
> At a minimum, shouldn't these 8 "corrected errors" be listed as
> "uncorrectable errors" to inform the sysadmin that data integrity has
> degraded (e.g. in this RAID1 example the data is no longer duplicated)?
>
> Ideally, I would hope that the blocks with uncorrectable errors are
> marked as bad and fresh blocks are used to maintain integrity.

The only way they are corrected is if the Btrfs overwrite to fix bad
reads (either a csum error, or a device read error) does not result in
a device write error, then it is corrected. I haven't tried simulating
persistent write failure to see how Btrfs behaves but my recollection
is it just keeps trying and does not eject that device. Nor does it
track bad sectors.


-- 
Chris Murphy
