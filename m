Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:61479 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3BRKdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 05:33:00 -0500
Received: by mail-bk0-f44.google.com with SMTP id j4so2493514bkw.31
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 02:32:58 -0800 (PST)
Message-ID: <51220452.9070403@statystyka.net>
Date: Mon, 18 Feb 2013 11:37:06 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs send & receive produces "Too many open files in system"
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I believe what I am going to write is a bug report.

When I finaly did
# btrfs send -v /mnt/adama-docs/backups/20130101-192722 | btrfs receive 
/mnt/tmp/backups

to migrate btrfs from one partition layout to another.

After a while system keeps saying that "Too many open files in system" 
and denies access to almost every command line tool. When I had access 
to iostat I confirmed the correct pattern of disk activity (i.e. reads 
from all devices that make /mnt/adama-docs , and writes to all devices 
that make /mnt/tmp). Now, that system is almost unusable, the HDD LEDs 
are still blinking in the same pattern as they did when I confirmed the 
pattern of disk activity. When I canceled the send & receive process, 
everything went back to normal.

I use Ubuntu Quantal with the latest 3.7.8 kernel, latest btrfs tools 
(v0.20 -rc1) downloaded from git.

The btrfs filesystem /mnt/adama-docs sits on top of lvm2 logical volume, 
which sits on top of cryptsetup Luks device which subsequentely sits on 
top of mdadm RAID-6 spanning a partition on each of 4 hard drives (I 
know that it is sub-optimal setup). The backups/20130101-192722 is a 
read-only snaphot which I estimate contain ca. 100GB data.

The /mnt/tmp/backups is btrfs multidevice raid10 filesystem, which is 
based on 4 cryptsetup Luks devices, each live as a separate partition on 
the same 4 physical hard drives that ultimately make the /mnt/adama-docs.

Both btrfs filesystems are mounted with -o compress, and the 
/mnt/adama-docs is also mounted with noatime.

I suspect that it may be some type of race condition, because my setup 
is so highly inefficient (I've got only about 8MB/sek read (and the same 
speed of write) from each of all 4 hard drives).

The problem is perfectly reproducible on my setup.

I'm ready to assist with whatever info you need to troubleshoot this 
problem.

-- 
Adam Ryczkowski
+48505919892
Skype:sisteczko

