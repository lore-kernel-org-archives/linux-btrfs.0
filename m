From: Christian Brunner <chb@muc.de>
Subject: Re: [PATCH] Btrfs: don't be as agressive with delalloc metadata
 reservations V2
Date: Thu, 21 Jul 2011 16:12:06 +0200
Message-ID: <CAO47_-9F11i0X0gm0iupF6byc88Dnu=QaekKjmr3kAD9c4wqOA@mail.gmail.com>
References: <1311012712-24828-1-git-send-email-josef@redhat.com>
	<4E2477EE.4090701@redhat.com>
Reply-To: chb@muc.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2477EE.4090701@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/18 Josef Bacik <josef@redhat.com>:
> On 07/18/2011 02:11 PM, Josef Bacik wrote:
>> Currently we reserve enough space to COW an entirely full btree for =
every extent
>> we have reserved for an inode. =A0This _sucks_, because you only nee=
d to COW once,
>> and then everybody else is ok. =A0Unfortunately we don't know we'll =
all be able to
>> get into the same transaction so that's what we have had to do. =A0B=
ut the global
>> reserve holds a reservation large enough to cover a large percentage=
 of all the
>> metadata currently in the fs. =A0So all we really need to account fo=
r is any new
>> blocks that we may allocate. =A0So fix this by
>>
>> 1) Passing to btrfs_alloc_free_block() wether this is a new block or=
 a COW
>> block. =A0If it is a COW block we use the global reserve, if not we =
use the
>> trans->block_rsv.
>> 2) Reduce the amount of space we reserve. =A0Since we don't need to =
account for
>> cow'ing the tree we can just keep track of new blocks to reserve, wh=
ich greatly
>> reduces the reservation amount.
>>
>> This makes my basic random write test go from 3 mb/s to 75 mb/s. =A0=
I've tested
>> this with my horrible ENOSPC test and it seems to work out fine. =A0=
Thanks,
>>
>> Signed-off-by: Josef Bacik <josef@redhat.com>
>> ---
>> V1->V2:
>> -fix a problem reported by Liubo, we need to make sure that we move =
bytes
>> over for any new extents we may add to the extent tree so we don't g=
et a bunch
>> of warnings.
>> -fix the global reserve to reserve 50% of the metadata space current=
ly used.

When I run this patch I get a lot of messages like these (V1 seemed to
run fine).

Regards,
Christian

Jul 21 15:25:59 os00 kernel: [   35.411360] ------------[ cut here ]---=
---------
Jul 21 15:25:59 os00 kernel: [   35.416589] WARNING: at
fs/btrfs/extent-tree.c:5564
btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]()
Jul 21 15:25:59 os00 kernel: [   35.427311] Hardware name: ProLiant DL1=
80 G6
Jul 21 15:25:59 os00 kernel: [   35.432326] Modules linked in: btrfs
zlib_deflate libcrc32c bonding ipv6 serio_raw pcspkr ghes hed iTCO_wdt
iTCO_vendor_support ixgbe dca mdio i7core_edac edac_core
iomemory_vsl(P) hpsa squashfs usb_storage [last unloaded:
scsi_wait_scan]
Jul 21 15:25:59 os00 kernel: [   35.456799] Pid: 1876, comm:
btrfs-endio-wri Tainted: P            3.0.0-1.fits.4.el6.x86_64 #1
Jul 21 15:25:59 os00 kernel: [   35.466610] Call Trace:
Jul 21 15:25:59 os00 kernel: [   35.469497]  [<ffffffff8106306f>]
warn_slowpath_common+0x7f/0xc0
Jul 21 15:25:59 os00 kernel: [   35.476254]  [<ffffffff810630ca>]
warn_slowpath_null+0x1a/0x20
Jul 21 15:25:59 os00 kernel: [   35.482839]  [<ffffffffa02227f8>]
btrfs_alloc_reserved_file_extent+0xf8/0x100 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.491683]  [<ffffffffa023d871>]
insert_reserved_file_extent.clone.0+0x201/0x270 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.500912]  [<ffffffffa023debb>]
btrfs_finish_ordered_io+0x2eb/0x360 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.508978]  [<ffffffff81073841>] ?
try_to_del_timer_sync+0x81/0xe0
Jul 21 15:25:59 os00 kernel: [   35.516081]  [<ffffffffa023df7c>]
btrfs_writepage_end_io_hook+0x4c/0xa0 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.524340]  [<ffffffffa0277846>]
end_compressed_bio_write+0x86/0xf0 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.532259]  [<ffffffff8118f0cd>]
bio_endio+0x1d/0x40
Jul 21 15:25:59 os00 kernel: [   35.538034]  [<ffffffffa0232654>]
end_workqueue_fn+0xf4/0x130 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.545384]  [<ffffffffa0265e7e>]
worker_loop+0x13e/0x540 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.552307]  [<ffffffffa0265d40>] ?
btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.560039]  [<ffffffffa0265d40>] ?
btrfs_queue_worker+0x2d0/0x2d0 [btrfs]
Jul 21 15:25:59 os00 kernel: [   35.567768]  [<ffffffff81085836>]
kthread+0x96/0xa0
Jul 21 15:25:59 os00 kernel: [   35.573275]  [<ffffffff81562b84>]
kernel_thread_helper+0x4/0x10
Jul 21 15:25:59 os00 kernel: [   35.579931]  [<ffffffff810857a0>] ?
kthread_worker_fn+0x1a0/0x1a0
Jul 21 15:25:59 os00 kernel: [   35.586816]  [<ffffffff81562b80>] ?
gs_change+0x13/0x13
Jul 21 15:25:59 os00 kernel: [   35.592779] ---[ end trace d87e2733f1e9=
78b8 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
