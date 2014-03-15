Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:62963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaCOOF3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 10:05:29 -0400
Message-ID: <53245E22.1060407@friedels.name>
Date: Sat, 15 Mar 2014 15:05:22 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Snapper on Ubuntu
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am not sure, whether this is the right place to ask this question -if 
not, please advise.

Ubuntu installs on btrfs, creating subvolumes for the homes (/home), the 
root home (/root) and the root (/) named @home, @root and @ respectively.

When I install snapper I configure it like this
snapper -c rt create-config /
snapper -c home create-config /home
snapper -c root create-config /root
snapper -c Video create-config /mnt/BTRFS/Video/

After executing snapper create several times, this results in

#btrfs subvolume list /
ID 258 gen 2615 top level 5 path @
ID 259 gen 2611 top level 5 path @root
ID 260 gen 2555 top level 5 path @home
ID 281 gen 2555 top level 5 path @home/.snapshots
ID 282 gen 2606 top level 5 path @root/.snapshots
ID 283 gen 2562 top level 5 path @root/.snapshots/1/snapshot
ID 284 gen 2563 top level 5 path @root/.snapshots/2/snapshot
ID 285 gen 2573 top level 5 path @root/.snapshots/3/snapshot
ID 286 gen 2577 top level 5 path @root/.snapshots/4/snapshot
ID 287 gen 2582 top level 5 path @root/.snapshots/5/snapshot
ID 288 gen 2583 top level 5 path @root/.snapshots/6/snapshot
ID 290 gen 2605 top level 258 path .snapshots
ID 291 gen 2599 top level 5 path @root/.snapshots/7/snapshot
ID 292 gen 2600 top level 5 path @root/.snapshots/8/snapshot
ID 293 gen 2605 top level 5 path @root/.snapshots/9/snapshot


#btrfs subvolume list /mnt/BTRFS/Video/
ID 258 gen 4560 top level 5 path Video
ID 259 gen 4557 top level 258 path VDR
ID 275 gen 672 top level 258 path Filme
ID 284 gen 816 top level 258 path Homevideo
ID 288 gen 1048 top level 258 path VideoSchnitt
ID 1874 gen 1288 top level 5 path rsnapshot
ID 1875 gen 4245 top level 5 path backups
ID 2265 gen 4560 top level 258 path .snapshots

So, this all works for @root only, not for the other subvolumes.

Do you have any suggestions, how to find the cause?

Regards,
Hendrik
