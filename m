Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59567 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753963Ab2JHUxX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 16:53:23 -0400
Message-ID: <50733D66.5020600@gmx.net>
Date: Mon, 08 Oct 2012 22:53:58 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Rory Campbell-Lange <rory@campbell-lange.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive to subdirectory
References: <20121008163010.GA22763@campbell-lange.net>
In-Reply-To: <20121008163010.GA22763@campbell-lange.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/08/12 18:30, Rory Campbell-Lange wrote:
> I can send snapshots to <volume>, but not <volume>/<dir>. Please advise
> if what I am doing is incorrect.
> 
> Rory
> 
> Format usb3 disk and mount
> 	root@orchard:/bkp# mkfs.btrfs /dev/sdb1
> 	> WARNING! - Btrfs v0.20-rc1-37-g91d9eec IS EXPERIMENTAL
> 	> WARNING! - see http://btrfs.wiki.kernel.org before using
> 	> fs created label (null) on /dev/sdb1
> 	> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 698.64GB
> 	> Btrfs v0.20-rc1-37-g91d9eec
> 	mount /dev/sdb1 /mnt
> 
> 
> Create snapshots on /bkp share
> 	root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/snap_081012_1715
> 	> Create a readonly snapshot of 'subvol' in 'snaps/snap_081012_1715'
> 	root@orchard:/bkp# mutt -f subvol/INBOX/
>     > 1561 kept, 18 deleted.
> 	root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/snap_081012_1716
>     > Create a readonly snapshot of 'subvol' in 'snaps/snap_081012_1716'
> 
> Send base backup to /mnt
> 	root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt
> 	> At subvol snaps/snap_081012_1715
> 	> At subvol snap_081012_1715
> 
> Send incremental backup to /mnt
> 	root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
>                        snaps/snap_081012_1716 | btrfs receive /mnt
> 	> At subvol snaps/snap_081012_1716
> 	> At snapshot snap_081012_1716
> 
> 	root@orchard:/bkp# ls /mnt
> 	snap_081012_1715  snap_081012_1716
> 
> Results:
> 	root@orchard:/bkp# btrfs subvolume list /bkp 
> 	> ID 259 gen 62 top level 5 path subvol
> 	> ID 278 gen 60 top level 5 path snaps/snap_081012_1715
> 	> ID 279 gen 62 top level 5 path snaps/snap_081012_1716
> 	root@orchard:/bkp# btrfs subvolume list /mnt 
> 	> ID 256 gen 8 top level 5 path snap_081012_1715
> 	> ID 259 gen 9 top level 5 path snap_081012_1716
> 
> Restart:
> 	root@orchard:/bkp# btrfs subvolume del /mnt/snap_081012_171*
> 	> Delete subvolume '/mnt/snap_081012_1715'
> 	> Delete subvolume '/mnt/snap_081012_1716'
> 
> Try and snap to /mnt/<subdir>
> 	root@orchard:/bkp# mkdir /mnt/snaps
> 	root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/snaps
> 	> At subvol snaps/snap_081012_1715
> 	> At subvol snap_081012_1715
> 	root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
> 	                   snaps/snap_081012_1716 | btrfs receive /mnt/snaps
> 	> At subvol snaps/snap_081012_1716
> 	> At snapshot snap_081012_1716
> 	> ERROR: open snaps/snap_081012_1715 failed. No such file or directory
>     root@orchard:/bkp# ls /mnt/snaps
>     > snap_081012_1715

The target has to be a subvol also. But interestingly enough, it also
fails for a subvol. The base send works, the incremental fails, because
btrfs receive can't find snaps/snap_081012_1715. If you give /mnt/snaps
as the target for the base and just /mnt for the incremental, it works.
There's clearly something broken there...

-arne

> 
> 
> 

