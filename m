Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46830 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433Ab2EQJHP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 05:07:15 -0400
Message-ID: <4FB4BFA4.2090402@tuxadero.com>
Date: Thu, 17 May 2012 11:06:44 +0200
From: Martin Mailand <martin@tuxadero.com>
Reply-To: martin@tuxadero.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Arnd Hannemann <arnd@arndnet.de>, liubo2009@cn.fujitsu.com, dave@jikos.cz
Subject: Re: 3.4.0-rc6: WARNING: at fs/btrfs/super.c:219 __btrfs_abort_transaction+0xae/0xc0
 [btrfs]()
References: <4FB10636.2010003@arndnet.de> <20120514150509.GJ25501@twin.jikos.cz>
In-Reply-To: <20120514150509.GJ25501@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I got the same Warning but triggered it differently, I created a new 
cephfs on top of btrfs via mkcephfs, the command than hangs.

[  100.643838] Btrfs loaded
[  100.644313] device fsid 49b89a47-76a0-45cf-9e4a-a7e1f4c64bb8 devid 1 
transid 4 /dev/sdc
[  100.645523] btrfs: setting nodatacow
[  100.645527] btrfs: enabling auto defrag
[  100.645529] btrfs: disk space caching is enabled
[  100.645531] btrfs flagging fs with big metadata feature
...

[ 2501.141664] ------------[ cut here ]------------
[ 2501.141700] WARNING: at fs/btrfs/super.c:219 
__btrfs_abort_transaction+0xae/0xc0 [btrfs]()
[ 2501.141714] Hardware name: X9SRi
[ 2501.141721] btrfs: Transaction aborted
[ 2501.141722] Modules linked in: btrfs zlib_deflate libcrc32c ext2 
bonding coretemp ghash_clmulni_intel aesni_intel cryptd aes_x86_64 
microcode sb_edac psmouse serio_raw edac_core joydev mei(C) ioatdma 
mac_hid lp parport ses enclosure usbhid isci hid libsas 
scsi_transport_sas megaraid_sas ixgbe igb mdio dca
[ 2501.141892] Pid: 12129, comm: ceph-osd Tainted: G         C 
3.4.0-rc7+ #10
[ 2501.141910] Call Trace:
[ 2501.141927]  [<ffffffff810504ef>] warn_slowpath_common+0x7f/0xc0
[ 2501.141945]  [<ffffffff810505e6>] warn_slowpath_fmt+0x46/0x50
[ 2501.141972]  [<ffffffffa01ffbde>] __btrfs_abort_transaction+0xae/0xc0 
[btrfs]
[ 2501.142024]  [<ffffffffa026913a>] ? 
btrfs_add_delayed_tree_ref+0x8a/0x1c0 [btrfs]
[ 2501.142090]  [<ffffffffa022b70b>] cow_file_range_inline+0x1bb/0x1c0 
[btrfs]
[ 2501.142137]  [<ffffffffa022b82f>] cow_file_range+0x11f/0x480 [btrfs]
[ 2501.142187]  [<ffffffffa024a31f>] ? free_extent_buffer+0x2f/0x70 [btrfs]
[ 2501.142235]  [<ffffffffa022bf77>] run_delalloc_nocow+0x3e7/0x8c0 [btrfs]
[ 2501.142281]  [<ffffffffa022c749>] run_delalloc_range+0x2f9/0x360 [btrfs]
[ 2501.142331]  [<ffffffffa024919d>] __extent_writepage+0x61d/0x760 [btrfs]
[ 2501.142366]  [<ffffffff81165f9f>] ? kmem_cache_free+0x2f/0x110
[ 2501.142412]  [<ffffffffa02495aa>] 
extent_write_cache_pages.isra.25.constprop.39+0x2ca/0x3f0 [btrfs]
[ 2501.142477]  [<ffffffffa0249915>] extent_writepages+0x45/0x60 [btrfs]
[ 2501.142524]  [<ffffffffa0228980>] ? btrfs_submit_direct+0x640/0x640 
[btrfs]
[ 2501.142570]  [<ffffffffa0226d08>] btrfs_writepages+0x28/0x30 [btrfs]
[ 2501.142604]  [<ffffffff81125b41>] do_writepages+0x21/0x40
[ 2501.142635]  [<ffffffff8111b18b>] __filemap_fdatawrite_range+0x5b/0x60
[ 2501.142669]  [<ffffffff8111c05c>] filemap_flush+0x1c/0x20
[ 2501.142713]  [<ffffffffa02328b9>] 
btrfs_start_delalloc_inodes+0xc9/0x1f0 [btrfs]
[ 2501.142763]  [<ffffffff8107cc13>] ? __wake_up+0x53/0x70
[ 2501.142806]  [<ffffffffa02244bd>] 
btrfs_commit_transaction+0x3bd/0xa60 [btrfs]
[ 2501.142856]  [<ffffffff810737c0>] ? add_wait_queue+0x60/0x60
[ 2501.142896]  [<ffffffffa020982a>] ? block_rsv_migrate_bytes+0x3a/0x50 
[btrfs]
[ 2501.142946]  [<ffffffffa0258106>] btrfs_mksubvol+0x356/0x3a0 [btrfs]
[ 2501.142991]  [<ffffffffa025827a>] 
btrfs_ioctl_snap_create_transid+0x12a/0x190 [btrfs]
[ 2501.143053]  [<ffffffffa0258336>] btrfs_ioctl_snap_create+0x56/0x80 
[btrfs]
[ 2501.143099]  [<ffffffffa025a40d>] btrfs_ioctl+0x44d/0x1320 [btrfs]
[ 2501.143134]  [<ffffffff81140dd8>] ? handle_mm_fault+0x1f8/0x310
[ 2501.143166]  [<ffffffff81189dd2>] ? do_filp_open+0x42/0xa0
[ 2501.143197]  [<ffffffff8118be98>] do_vfs_ioctl+0x98/0x550
[ 2501.143228]  [<ffffffff81165f9f>] ? kmem_cache_free+0x2f/0x110
[ 2501.143259]  [<ffffffff8118c3e1>] sys_ioctl+0x91/0xa0
[ 2501.143291]  [<ffffffff8165fd29>] system_call_fastpath+0x16/0x1b
[ 2501.143321] ---[ end trace 7d4c76238d6eae30 ]---
[ 2501.143350] BTRFS error (device sdc) in cow_file_range_inline:261: 
error 28
[ 2501.143381] btrfs is forced readonly
[ 2501.143407] BTRFS error (device sdc) in cow_file_range:871: error 28
[ 2501.143444] BTRFS error (device sdc) in run_delalloc_nocow:1333: error 28

btrfs filesystem df /data/osd.0/
Data: total=112.01GB, used=1.02MB
System, DUP: total=8.00MB, used=32.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=112.00GB, used=288.00KB
Metadata: total=8.00MB, used=0.00
e5:~$ df -h
Filesystem                  Size  Used Avail Use% Mounted on
/dev/mapper/redundant-root   85G  3,9G   77G   5% /
udev                         32G  4,0K   32G   1% /dev
tmpfs                        13G  292K   13G   1% /run
none                        5,0M     0  5,0M   0% /run/lock
none                         32G     0   32G   0% /run/shm
/dev/sda1                   228M   68M  148M  32% /boot
/dev/sdc                    5,5T  1,7M  5,3T   1% /data/osd.0
/dev/sdd                    5,5T  1,7M  5,3T   1% /data/osd.1
/dev/sde                    5,5T  1,6M  5,3T   1% /data/osd.2
/dev/sdf                    5,5T  1,7M  5,3T   1% /data/osd.3


Ceph command.

mkcephfs -c /etc/ceph/ceph.conf -a
temp dir is /tmp/mkcephfs.2kN76CD9ut
preparing monmap in /tmp/mkcephfs.2kN76CD9ut/monmap
/usr/bin/monmaptool --create --clobber --add a 192.168.125.10:6789 
--print /tmp/mkcephfs.2kN76CD9ut/monmap
/usr/bin/monmaptool: monmap file /tmp/mkcephfs.2kN76CD9ut/monmap
/usr/bin/monmaptool: generated fsid 65095718-4f08-43fe-b4e0-9e59960b630b
epoch 0
fsid 65095718-4f08-43fe-b4e0-9e59960b630b
last_changed 2012-05-17 10:47:32.238434
created 2012-05-17 10:47:32.238434
0: 192.168.125.10:6789/0 mon.a
/usr/bin/monmaptool: writing epoch 0 to /tmp/mkcephfs.2kN76CD9ut/monmap 
(1 monitors)
=== osd.0 ===
2012-05-17 10:47:32.384541 7fb09e0d7780 -1 filestore(/data/osd.0) 
leveldb db created

-martin
