Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ebox.rath.org ([23.92.25.96]:58718 "EHLO ebox.rath.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833AbaHKP32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 11:29:28 -0400
Received: from vostro ([192.168.12.4] helo=vostro.rath.org)
	by ebox.rath.org with esmtp (Exim 4.80)
	(envelope-from <Nikolaus@rath.org>)
	id 1XGrHC-0003F1-UN
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 15:12:47 +0000
From: Nikolaus Rath <Nikolaus@rath.org>
To: linux-btrfs@vger.kernel.org
Subject: File system stuck in scrub
Date: Mon, 11 Aug 2014 08:12:46 -0700
Message-ID: <87mwbbnjpt.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I started a scrub of one of my btrfs filesystem and then had to restart
the system. `systemctl restart` seemed to terminate all processes, but
then got stuck at the end. The disk activity led was still flashing
rapidly at that point, so I assume that the active scrub was preventing
the reboot (is that a bug or a feature?).

In any case, I could not wait for that so I power cycled. But now my
file system seems to be stuck in a scrub that can neither be completed
nor cancelled:

$ sudo btrfs scrub status /home/nikratio/
scrub status for 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
        scrub started at Sun Aug 10 18:36:43 2014, running for 1562 seconds
        total bytes scrubbed: 209.97GiB with 0 errors

$ date
Sun Aug 10 22:00:44 PDT 2014

$ sudo btrfs scrub cancel /home/nikratio/
ERROR: scrub cancel failed on /home/nikratio/: not running

$ sudo btrfs scrub start /home/nikratio/
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /home/nikratio/'.
To see the status use 'btrfs scrub status [-d] /home/nikratio/'.

Note that the scrub was started more than 3 hours ago, but claims to
have been running for only 1562 seconds.

I then figured that maybe I need to run btrfsck. This gave the following
output:

checking extents
checking free space cache
checking fs roots
root 5 inode 3149791 errors 400, nbytes wrong
root 5 inode 3150233 errors 400, nbytes wrong
root 5 inode 3150238 errors 400, nbytes wrong
[102 similar lines]
Checking filesystem on /dev/mapper/vg0-nikratio_crypt
UUID: 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
free space inode generation (0) did not match free space cache generation (161262)
free space inode generation (0) did not match free space cache generation (75485)
free space inode generation (0) did not match free space cache generation (79599)
free space inode generation (0) did not match free space cache generation (72280)
free space inode generation (0) did not match free space cache generation (79599)
free space inode generation (0) did not match free space cache generation (25866)
free space inode generation (0) did not match free space cache generation (12255)
free space inode generation (0) did not match free space cache generation (72521)
free space inode generation (0) did not match free space cache generation (161286)
free space inode generation (0) did not match free space cache generation (28716)
free space inode generation (0) did not match free space cache generation (161481)
found 216444746042 bytes used err is 1
total csum bytes: 383160676
total tree bytes: 875753472
total fs tree bytes: 284246016
total extent tree bytes: 69320704
btree space waste bytes: 205021777
file data blocks allocated: 3701556121600
 referenced 388107321344
Btrfs v3.14.1

So nothing about the scrub, but apparently some other errors.

Can someone tell me:

 * Should I be able to restart while a scrub is in progress, or is that
   deliberately prevented by btrfs?

 * How can I resume or cancel the scrub?

 * Is it more risky to leave the above errors uncorrected, or to run
   btrfsck with --repair?


I'm using kernel 3.14.

Thanks!
-Nikolaus

-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
