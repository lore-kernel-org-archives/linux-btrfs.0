Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41708 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3KJNBG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 08:01:06 -0500
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 3.10.11 scrub OOM crash
Date: Mon, 11 Nov 2013 00:01:00 +1100
Cc: linux-btrfs@vger.kernel.org
References: <201311101048.17277.russell@coker.com.au> <pan$6aed8$65fef48b$2e6cd73c$d2a7aa4d@cox.net>
In-Reply-To: <pan$6aed8$65fef48b$2e6cd73c$d2a7aa4d@cox.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201311110001.00667.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 10 Nov 2013, Duncan <1i5t5.duncan@cox.net> wrote:
> Do you have disk quotas (btrfs qgroups) enabled?  There's a known current

No.  I haven't yet had BTRFS running well enough to need anything else to 
test.

> Meanwhile, the threads getting the OOMs are going to be btrfs-worker
> threads.  Killing them leaves open I/O and the locks for that I/O won't
> get cleaned up, thus effectively stalling I/O for anything on that btrfs

There are no log entries about kernel threads getting killed, I wasn't even 
aware that it was possible for kernel threads to be killed.  But as the logs 
are on a BTRFS filesystem it might just be impossible for such log records to 
be committed to disk.

> volume (AFAIK the entire volume, not just that subvolume), tho I'm not
> sure whether it'll affect all I/O (on other btrfs volumes and non-btrfs
> filesystems) or not.  Existing tasks will continue to operate as long as
> they don't do any I/O to the locked-up volumes, and from my experience

Judging by the times of the log records I believe that the SSD was scrubbed 
successfully and the system hung while scrubbing the 3TB SATA disks.  If 
kernel threads are being killed as you suggest then it would be threads killed 
while scrubbing the 2*3TB RAID-1 that makes the SSD unusable.

> and hope there's not too much damage.  (Tho of course with btrfs being
> experimental, if you're running it without tested backups to restore from
> if worse comes to worse, you're doing it wrong, which means that any
> damage there might be simply means restoring from that backup, at worst.)

My backups are reasonably good.  The best that they have ever been.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
