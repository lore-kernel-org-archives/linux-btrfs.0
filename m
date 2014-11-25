Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65362 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaKYP5g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:36 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so1931607wib.11
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 07:57:35 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/4] New 'btrfs chunk list' command
Date: Tue, 25 Nov 2014 16:57:21 +0100
Message-Id: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a revamp of a my previous patches set[1]. After more than
year of attempts these patches were never merged, so I tried to
simplify them and to change a bit the focus. The previous patches set
had the focus to the disk usage.
The aim of these patches now is to show the chunks distribution
among the disks. So a new command 'btrfs chunk list' is added:

$ sudo ./btrfs chunk list /mnt/btrfs1/
Data,RAID6: Size:3.00GiB, Used:1.02MiB
   /dev/vdb	   1.00GiB
   /dev/vdd	   1.00GiB
   /dev/vde	   1.00GiB
   /dev/vdf	   1.00GiB
   /dev/vdg	   1.00GiB

Metadata,RAID5: Size:1.00GiB, Used:112.00KiB
   /dev/vdb	 256.00MiB
   /dev/vdd	 256.00MiB
   /dev/vde	 256.00MiB
   /dev/vdf	 256.00MiB
   /dev/vdg	 256.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/vde	  32.00MiB
   /dev/vdg	  32.00MiB

Unallocated:
   /dev/vdb	  48.75GiB
   /dev/vdd	  48.75GiB
   /dev/vde	  48.72GiB
   /dev/vdf	  48.75GiB
   /dev/vdg	  48.72GiB


This command is smart enough to highlight that a disk is not preset
(this happens when a mount -o degraded is used). In case 
/dev/vdb disappears:

$ sudo ./btrfs chunk list /mnt/btrfs1/
Data,RAID6: Size:3.00GiB, Used:1.02MiB
   /dev/vdb	   1.00GiB
   /dev/vde	   1.00GiB
   /dev/vdf	   1.00GiB
   /dev/vdg	   1.00GiB
   [Missing: /dev/vdd]	   1.00GiB

Metadata,RAID5: Size:1.00GiB, Used:112.00KiB
   /dev/vdb	 256.00MiB
   /dev/vde	 256.00MiB
   /dev/vdf	 256.00MiB
   /dev/vdg	 256.00MiB
   [Missing: /dev/vdd]	 256.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/vde	  32.00MiB
   /dev/vdg	  32.00MiB

Unallocated:
   /dev/vdb	  48.75GiB
   /dev/vde	  48.72GiB
   /dev/vdf	  48.75GiB
   /dev/vdg	  48.72GiB
   [Missing: /dev/vdd]	  48.75GiB


It is interesting to see what happens after a 
'btrfs balance':

$ sudo ./btrfs chunk list /mnt/btrfs1/
Data,RAID6: Size:2.00GiB, Used:792.00KiB
   /dev/vdb	   1.00GiB
   /dev/vde	   1.00GiB
   /dev/vdf	   1.00GiB
   /dev/vdg	   1.00GiB

Metadata,RAID5: Size:1.03GiB, Used:112.00KiB
   /dev/vdb	 352.00MiB
   /dev/vde	 352.00MiB
   /dev/vdf	 352.00MiB
   /dev/vdg	 352.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/vdb	  32.00MiB
   /dev/vdf	  32.00MiB

Unallocated:
   /dev/vdb	  48.63GiB
   /dev/vde	  48.66GiB
   /dev/vdf	  48.63GiB
   /dev/vdg	  48.66GiB
   [Missing: /dev/vdd]	  50.00GiB

And what happens after a 'btrfs device delete missing':

$ sudo ./btrfs chunk list /mnt/btrfs1/
Data,RAID6: Size:2.00GiB, Used:792.00KiB
   /dev/vdb	   1.00GiB
   /dev/vde	   1.00GiB
   /dev/vdf	   1.00GiB
   /dev/vdg	   1.00GiB

Metadata,RAID5: Size:1.03GiB, Used:112.00KiB
   /dev/vdb	 352.00MiB
   /dev/vde	 352.00MiB
   /dev/vdf	 352.00MiB
   /dev/vdg	 352.00MiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/vdb	  32.00MiB
   /dev/vdf	  32.00MiB

Unallocated:
   /dev/vdb	  48.63GiB
   /dev/vde	  48.66GiB
   /dev/vdf	  48.63GiB
   /dev/vdg	  48.66GiB

Comments are welcome.
BR
G.Baroncelli



[1] My last attempt was done in 
http://comments.gmane.org/gmane.comp.file-systems.btrfs/32647,
then David resent the patches in 
http://www.spinics.net/lists/linux-btrfs/msg33630.html


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D 17B2 0EDA 9B37 8B82 E0B5

