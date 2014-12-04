Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33774 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaLDWZJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 17:25:09 -0500
Received: by mail-yk0-f172.google.com with SMTP id 131so8404778ykp.17
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 14:25:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <002540148940af9d5cad8d2ede3577b0@admin.virtall.com>
References: <002540148940af9d5cad8d2ede3577b0@admin.virtall.com>
Date: Thu, 4 Dec 2014 15:25:08 -0700
Message-ID: <CAJCQCtQH5oqTW2nLcVgkLmUha6RiQyouOsjKg0gSD6RXF+_-mg@mail.gmail.com>
Subject: Re: btrfs device delete missing - Input/output error
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 4, 2014 at 1:55 PM, Tomasz Chmielewski <tch@virtall.com> wrote:
> btrfs RAID-1, one of the drive failed and was replaced.
>
> Unfortunately the second drive is also showing errors and "btrfs device
> delete missing" exits with error:
>
> # btrfs device delete missing /home
> ERROR: error removing the device 'missing' - Input/output error
>
>
> Is there a way for btrfs to ignore these errors? I'd rather loose a few
> files here and there than the whole filesystem.

If this is file system metadata that it can't read due to the UNC
error, and if that metadata isn't already replicated on the mirror,
then it's not ignorable. It might not be fatal if it's file specific
metadata or data, if you can determine which file it is, and then
either do an rsync excluding that file to a new file system, or faster
and a bit more risky is to delete the file and then do a btrfs
send/receive to a new file system.

What I'd probably do is reboot, mount the filesystem read only, and
rsync what I wanted from this troubled volume onto a new volume. This
is the most conservative approach, not trusting either the hardware or
the file system. Only once I've got the data I want safe, would I
entertain trying to fix the existing troubled volume; or if the rsync
persistently fails to do a complete recovery.

The first way to try to recover the current volume would be to
overwrite LBA 2262535088 which you should only do with the filesystem
unmounted. That's the sector causing the read error. If this is a 512
byte drive:

dd if=/dev/zero of=/dev/sdb count=1 seek=2262535088

If it's 4096 bytes then you need to do:
dd if=/dev/zero of=/dev/sdb bs=4096 count=1 seek=282816886

Next do btrfs check without repair and see if it finds problems and
report that. If it doesn't find problems, then chances are it's either
file specific metadata or data in which case a scrub will report the
affected file but otherwise continue on. And now you can just delete
that file.

If you do a weekly or even a monthly scrub, the chances bad sectors
crop up that aren't automatically repairable with raid1 is quite low.

-- 
Chris Murphy
