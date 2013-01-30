Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:45855 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3A3O6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 09:58:06 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so692103eaa.25
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 06:58:04 -0800 (PST)
Message-ID: <510934E6.7080302@statystyka.net>
Date: Wed, 30 Jan 2013 15:57:42 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Poor performance of btrfs. Suspected unidentified btrfs housekeeping
 process which writes a lot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Welcome,

I've been using btrfs for over a 3 months to store my personal data on 
my NAS server. Almost all interactions with files on the server are done 
using unison synchronizer. After another use of bedup 
(https://github.com/g2p/bedup) on my btrfs volume I experienced huge 
perfomance loss with synchronization. It now takes over 3 hours what 
have taken only 15 minutes! File browsing is not affected; but it takes 
forever to read contents of the files!

When I use `iotop -o -d 30` (which measures I/O activity for 30-second 
interval) I can see:

Total DISK READ:      98.66 K/s | Total DISK WRITE:     826.55 K/s
   TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO> COMMAND
  4296 be/4 root        3.99 K/s  408.59 K/s  0.00 % 98.64 % 
[btrfs-transacti]
  6407 be/4 adam       94.14 K/s    0.00 B/s  0.00 % 85.24 % unison -server
   311 be/4 root        0.00 B/s    0.00 B/s  0.00 % 58.20 % [md1_raid6]
   354 be/3 root        0.00 B/s    2.26 K/s  0.00 % 24.29 % [jbd2/md0-8]
   306 be/4 root        0.00 B/s    0.00 B/s  0.00 %  4.79 % [md0_raid1]
  1229 be/4 syslog      0.00 B/s  136.15 B/s  0.00 %  0.00 % rsyslogd -c5
  1744 be/4 root        0.00 B/s  136.15 B/s  0.00 %  0.00 % 
console-kit-daemon --no-daemon

I expect no writes at all since the statistics were taken during the 
"Looking for changes" phse. Normally, the `unison -server` process shold 
have at least 5 M/s disk read speed. (The block device the btrfs is 
build on has a measured capability of 50 M/s sequential throughput)

When I pause the `unison -server` process (with htop), the disk activity 
persists of another 5-30 seconds, so I am infer, that the btrfs is doing 
some house-keeping work, and this is the reason I decided to post the 
email on this list. I suspect, that this house-keeping work has a time 
granularity of 5-30 seconds, and during this time access to the 
filesystem is delayed. The problem is not specific to the unison. This 
background process is triggered by just reading the file contents. Once 
the system is through and the file is read, than all subsequent attempts 
to read it are fine, even if I drop the cache (i.e. echo 3 > 
/proc/sys/vm/drop_caches). But after a while (after reboot) the 
performance hit recurs.

The questions are:
1. What sort of work is btrfs doing?
What is it writing (and why is it writing 100x bytes more than reading)?
2. Why does it take it so long?
3. What can I do to speed-up the process?
4. What can I do to prevent it from happening again?

Here are details about my system that might help you with the diagnose. 
If it is not enough,

I suspect it has something to do with snapshots I make for backup. I 
have 35 of them, and I ask bedup to find duplicates across all 
subvolumes. But on the other hand it is supposed to work since kernel 
3.5, and the filesystem has never seen kernel older than 3.6.

My filesystem /dev/vg-adama-docs/lv-adama-docs is 372GB in size, and is 
a quite complex setup:
It is based on logical volume (LVM2), which has a single physical volume 
made by dm-crypt device /dev/dm-1, which subsequently sits on top of 
/dev/md1 linux raid 6, which is built with 4 identical 186GB GPT 
partitions on each of my SATA 3TB hard drives.

There are 272k files on the system (excluding 35 snaphosts), 23k folders 
and 104 GB data.
$ df /mnt/adama-docs -h
Filesystem                                   Size  Used Avail Use% 
Mounted on
/dev/mapper/vg--adama--docs-lv--adama--docs  373G   85G  288G  23% 
/mnt/adama-docs

I was always using the latest kernel (its 3.7.1-030701-generic at the 
moment) on my Ubuntu Quantal server.

-- 

Adam Ryczkowski
Skype:sisteczko <skype:sisteczko>

