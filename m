Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:36751 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A2XFs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 18:05:48 -0500
Message-ID: <510855AD.2020602@sandia.gov>
Date: Tue, 29 Jan 2013 16:05:17 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: "Josef Bacik" <jbacik@fusionio.com>
cc: "Liu Bo" <bo.li.liu@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <510817C6.5070007@sandia.gov>
 <20130129200415.GE3660@localhost.localdomain>
In-Reply-To: <20130129200415.GE3660@localhost.localdomain>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/29/2013 01:04 PM, Josef Bacik wrote:
> On Tue, Jan 29, 2013 at 11:41:10AM -0700, Jim Schutt wrote:
>> > On 01/28/2013 02:23 PM, Josef Bacik wrote:
>>> > > On Thu, Jan 03, 2013 at 11:44:46AM -0700, Jim Schutt wrote:
>>>> > >> Hi Josef,
>>>> > >>
>>>> > >> Thanks for the patch - sorry for the long delay in testing...
>>>> > >>
>>> > > 
>>> > > Jim,
>>> > > 
>>> > > I've been trying to reason out how this happens, could you do a btrfs fi df on
>>> > > the filesystem thats giving you trouble so I can see if what I think is
>>> > > happening is what's actually happening.  Thanks,
>> > 
>> > Here's an example, using a slightly different kernel than
>> > my previous report.  It's your btrfs-next master branch
>> > (commit 8f139e59d5 "Btrfs: use bit operation for ->fs_state")
>> > with ceph 3.8 for-linus (commit 0fa6ebc600 from linus' tree).
>> > 
>> > 
>> > Here I'm finding the file system in question:
>> > 
>> > # ls -l /dev/mapper | grep dm-93
>> > lrwxrwxrwx 1 root root       8 Jan 29 11:13 cs53s19p2 -> ../dm-93
>> > 
>> > # df -h | grep -A 1 cs53s19p2
>> > /dev/mapper/cs53s19p2
>> >                       896G  1.1G  896G   1% /ram/mnt/ceph/data.osd.522
>> > 
>> > 
>> > Here's the info you asked for:
>> > 
>> > # btrfs fi df /ram/mnt/ceph/data.osd.522
>> > Data: total=2.01GB, used=1.00GB
>> > System: total=4.00MB, used=64.00KB
>> > Metadata: total=8.00MB, used=7.56MB
>> > 
> How big is the disk you are using, and what mount options?  I have a patch to
> keep the panic from happening and hopefully the abort, could you try this?  I
> still want to keep the underlying error from happening because it shouldn't be,
> but no reason I can't fix the error case while you can easily reproduce it :).
> Thanks,
> 
> Josef
> 
>>From c50b725c74c7d39064e553ef85ac9753efbd8aec Mon Sep 17 00:00:00 2001
> From: Josef Bacik <jbacik@fusionio.com>
> Date: Tue, 29 Jan 2013 15:03:37 -0500
> Subject: [PATCH] Btrfs: fix chunk allocation error handling
> 
> If we error out allocating a dev extent we will have already created the
> block group and such which will cause problems since the allocator may have
> tried to allocate out of the block group that no longer exists.  This will
> cause BUG_ON()'s in the bio submission path.  This also makes a failure to
> allocate a dev extent a non-abort error, we will just clean up the dev
> extents we did allocate and exit.  Now if we fail to delete the dev extents
> we will abort since we can't have half of the dev extents hanging around,
> but this will make us much less likely to abort.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---

Interesting - with your patch applied I triggered the following, just
bringing up a fresh Ceph filesystem - I didn't even get a chance to
mount it on my Ceph clients:

[ 6419.450179] BTRFS error (device dm-73) in btrfs_free_dev_extent:1115: error 28 (Slot search failed)
[ 6419.459223] btrfs is forced readonly
[ 6419.462805] ------------[ cut here ]------------
[ 6419.467440] WARNING: at fs/btrfs/super.c:256 __btrfs_abort_transaction+0x60/0x110 [btrfs]()
[ 6419.475809] Hardware name: X8DTH-i/6/iF/6F
[ 6419.479914] Modules linked in: btrfs zlib_deflate ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ib_addr ipv6 dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath scsi_dh vhost_net macvtap macvlan tun uinput sg joydev sd_mod iTCO_wdt iTCO_vendor_support hid_generic coretemp kvm crc32c_intel ghash_clmulni_intel aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul microcode button ata_piix libata mpt2sas scsi_transport_sas raid_class scsi_mod serio_raw pcspkr mlx4_ib ib_sa ib_mad ib_core mlx4_en mlx4_core cxgb4 i2c_i801 i2c_core lpc_ich mfd_core uhci_hcd ehci_hcd i7core_edac edac_core ioatdma dm_mod nfsv4 auth_rpcgss nfsv3 nfs_acl nfsv2 nfs lockd sunrpc fscache broadcom tg3 hwmon bnx2 igb dca e1000
[ 6419.546095] Pid: 107593, comm: ceph-osd Not tainted 3.7.0-00270-g8353482 #494
[ 6419.553227] Call Trace:
[ 6419.555697]  [<ffffffff8103ff04>] warn_slowpath_common+0x94/0xc0
[ 6419.561708]  [<ffffffff8103ffe6>] warn_slowpath_fmt+0x46/0x50
[ 6419.567491]  [<ffffffffa0542730>] __btrfs_abort_transaction+0x60/0x110 [btrfs]
[ 6419.574746]  [<ffffffffa05980c6>] __btrfs_alloc_chunk+0x6e6/0x770 [btrfs]
[ 6419.581553]  [<ffffffffa05981ae>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 6419.588017]  [<ffffffffa0554db1>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 6419.594824]  [<ffffffffa055515c>] do_chunk_alloc+0x2ec/0x370 [btrfs]
[ 6419.601188]  [<ffffffffa055e06c>] find_free_extent+0xaac/0xbe0 [btrfs]
[ 6419.607733]  [<ffffffffa055e222>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 6419.614545]  [<ffffffffa055e3b5>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 6419.621530]  [<ffffffffa0586e55>] ? check_buffer_tree_ref+0x25/0x50 [btrfs]
[ 6419.628512]  [<ffffffffa0549bca>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 6419.635155]  [<ffffffffa05a261c>] ? btrfs_try_tree_write_lock+0x3c/0xa0 [btrfs]
[ 6419.642475]  [<ffffffffa05a2c43>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
[ 6419.649970]  [<ffffffffa054a5b1>] btrfs_cow_block+0x161/0x200 [btrfs]
[ 6419.656424]  [<ffffffffa054d679>] btrfs_search_slot+0x399/0x760 [btrfs]
[ 6419.663050]  [<ffffffffa0573f79>] btrfs_truncate_inode_items+0x179/0x710 [btrfs]
[ 6419.670458]  [<ffffffffa0584ad5>] ? btrfs_add_ordered_operation+0x55/0xb0 [btrfs]
[ 6419.677961]  [<ffffffffa0575fcd>] btrfs_truncate+0x16d/0x2c0 [btrfs]
[ 6419.684328]  [<ffffffffa057a441>] btrfs_setsize+0x151/0x190 [btrfs]
[ 6419.690601]  [<ffffffff8117eb4a>] ? notify_change+0xaa/0x2e0
[ 6419.696274]  [<ffffffffa057a4e6>] btrfs_setattr+0x66/0xd0 [btrfs]
[ 6419.702373]  [<ffffffff8117eca2>] notify_change+0x202/0x2e0
[ 6419.707949]  [<ffffffff81161f5f>] do_truncate+0x6f/0x90
[ 6419.713174]  [<ffffffff811620dd>] do_sys_truncate+0x15d/0x170
[ 6419.718919]  [<ffffffff811620fe>] sys_truncate+0xe/0x10
[ 6419.724139]  [<ffffffff814b7882>] system_call_fastpath+0x16/0x1b
[ 6419.730132] ---[ end trace e480283f0ee28284 ]---
[ 6419.734754] BTRFS warning (device dm-73): __btrfs_alloc_chunk:3803: Aborting unused transaction(error 28).

Here's some data on the btrfs filesystem in question:

# ls -l /dev/mapper | grep dm-73
lrwxrwxrwx 1 root root       8 Jan 29 14:27 cs33s16p2 -> ../dm-73

# df -h | grep -A 1 cs33s16p2
/dev/mapper/cs33s16p2
                      896G  7.8M  896G   1% /ram/mnt/ceph/data.osd.39

# btrfs fi df /ram/mnt/ceph/data.osd.39/
Data: total=8.00MB, used=3.61MB
System: total=4.00MB, used=64.00KB
Metadata: total=8.00MB, used=4.12MB

# cat /proc/mounts | grep osd.39
/dev/mapper/cs33s16p2 /ram/mnt/ceph/data.osd.39 btrfs ro,noatime,nospace_cache 0 0


FWIW, in these tests I'm building a fresh Ceph filesystem with 576 OSDs,
hence 576 different btrfs filesystems, but typically I only have an
issue with one of them per test.

-- Jim

