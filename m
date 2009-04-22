From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: LVM vs btrfs as a "volume manager" for SANs
Date: Wed, 22 Apr 2009 21:20:23 +0200
Message-ID: <49EF6DF7.9020406@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Right now, the majority of Linux users probably have LVM on their SAN 
devices (i.e those being iSCSI targets).

Using LVM on a SAN device is easy: just create a new logical volume or 
its snapshot, make it a target to iSCSI initiators, done.

I was wondering how btrfs would fit here and if it could replace LVM.


I see the following benefits of using btrfs instead of LVM:

- you can create sparse files which would grow as iSCSI initators use 
more space (you can do it with ext3 now as well)

- you can use btrfs compression, to further reduce used space and 
perhaps increase speed (SANs are mostly IO bound, not CPU bound)

- LVM has a big performance hit when using snapshots; btrfs doesn't



However, with btrfs, I'm not sure about:

- what happens if SAN machine crashes while the iSCSI file images were 
being written to; with LVM and its block devices, I'm somehow more 
confident it wouldn't make more data loss than necessary

- taking snapshots of individual files (file images on SAN) is not 
possible with btrfs? Probably they would have to be placed in separate 
directories first to make snapshots - some minor manageability issue


-- 
Tomasz Chmielewski
http://wpkg.org
