Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750881AbdGMQqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 12:46:15 -0400
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com [209.85.214.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A62DA22C9F
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 16:46:14 +0000 (UTC)
Received: by mail-it0-f45.google.com with SMTP id k192so51594707ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 09:46:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713163619.GB12913@lim.localdomain>
References: <20170713140954.2243-1-fdmanana@kernel.org> <20170713163619.GB12913@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 13 Jul 2017 17:46:13 +0100
Message-ID: <CAL3q7H53ZzmHdb8_Rr=yzc1tNYTjf2dCMcs=exOsem0_axkX4g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix write corruption due to bio cloning on raid5/6
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 5:36 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Jul 13, 2017 at 03:09:54PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> The recent changes to make bio cloning faster (added in the 4.13 merge
>> window) by using the bio_clone_fast() API introduced a regression on
>> raid5/6 modes, because cloned bios have an invalid bi_vcnt field
>> (therefore it can not be used) and the raid5/6 code uses the
>> bio_for_each_segment_all() API to iterate the segments of a bio, and this
>> API uses a bio's bi_vcnt field.
>>
>> The issue is very simple to trigger by doing for example a direct IO write
>> against a raid5 or raid6 filesystem and then attempting to read what we
>> wrote before:
>>
>>   $ mkfs.btrfs -m raid5 -d raid5 -f /dev/sdc /dev/sdd /dev/sde /dev/sdf
>>   $ mount /dev/sdc /mnt
>>   $ xfs_io -f -d -c "pwrite -S 0xab 0 1M" /mnt/foobar
>>   $ od -t x1 /mnt/foobar
>>   od: /mnt/foobar: read error: Input/output error
>>
>> For that example, the following is also reported in dmesg/syslog:
>>
>>   [18274.985557] btrfs_print_data_csum_error: 18 callbacks suppressed
>>   [18274.995277] BTRFS warning (device sdf): csum failed root 5 ino 257 off 0 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18274.997205] BTRFS warning (device sdf): csum failed root 5 ino 257 off 4096 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.025221] BTRFS warning (device sdf): csum failed root 5 ino 257 off 8192 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.047422] BTRFS warning (device sdf): csum failed root 5 ino 257 off 12288 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.054818] BTRFS warning (device sdf): csum failed root 5 ino 257 off 4096 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.054834] BTRFS warning (device sdf): csum failed root 5 ino 257 off 8192 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.054943] BTRFS warning (device sdf): csum failed root 5 ino 257 off 8192 csum 0x98f94189 expected csum 0x94374193 mirror 2
>>   [18275.055207] BTRFS warning (device sdf): csum failed root 5 ino 257 off 8192 csum 0x98f94189 expected csum 0x94374193 mirror 3
>>   [18275.055571] BTRFS warning (device sdf): csum failed root 5 ino 257 off 0 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>   [18275.062171] BTRFS warning (device sdf): csum failed root 5 ino 257 off 12288 csum 0x98f94189 expected csum 0x94374193 mirror 1
>>
>> A scrub will also fail correcting bad copies, mentioning the following in
>> dmesg/syslog:
>>
>>   [18276.128696] scrub_handle_errored_block: 498 callbacks suppressed
>>   [18276.129617] BTRFS warning (device sdf): checksum error at logical 2186346496 on dev /dev/sde, sector 2116608, root 5, inode 257, offset 65536, length 4096, links $
>>   [18276.149235] btrfs_dev_stat_print_on_error: 498 callbacks suppressed
>>   [18276.157897] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>   [18276.206059] BTRFS warning (device sdf): checksum error at logical 2186477568 on dev /dev/sdd, sector 2116736, root 5, inode 257, offset 196608, length 4096, links$
>>   [18276.206059] BTRFS error (device sdf): bdev /dev/sdd errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>   [18276.306552] BTRFS warning (device sdf): checksum error at logical 2186543104 on dev /dev/sdd, sector 2116864, root 5, inode 257, offset 262144, length 4096, links$
>>   [18276.319152] BTRFS error (device sdf): bdev /dev/sdd errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>>   [18276.394316] BTRFS warning (device sdf): checksum error at logical 2186739712 on dev /dev/sdf, sector 2116992, root 5, inode 257, offset 458752, length 4096, links$
>>   [18276.396348] BTRFS error (device sdf): bdev /dev/sdf errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>>   [18276.434127] BTRFS warning (device sdf): checksum error at logical 2186870784 on dev /dev/sde, sector 2117120, root 5, inode 257, offset 589824, length 4096, links$
>>   [18276.434127] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
>>   [18276.500504] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186477568 on dev /dev/sdd
>>   [18276.538400] BTRFS warning (device sdf): checksum error at logical 2186481664 on dev /dev/sdd, sector 2116744, root 5, inode 257, offset 200704, length 4096, links$
>>   [18276.540452] BTRFS error (device sdf): bdev /dev/sdd errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
>>   [18276.542012] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186481664 on dev /dev/sdd
>>   [18276.585030] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186346496 on dev /dev/sde
>>   [18276.598306] BTRFS warning (device sdf): checksum error at logical 2186412032 on dev /dev/sde, sector 2116736, root 5, inode 257, offset 131072, length 4096, links$
>>   [18276.598310] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
>>   [18276.598582] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186350592 on dev /dev/sde
>>   [18276.603455] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
>>   [18276.638362] BTRFS warning (device sdf): checksum error at logical 2186354688 on dev /dev/sde, sector 2116624, root 5, inode 257, offset 73728, length 4096, links $
>>   [18276.640445] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
>>   [18276.645942] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186354688 on dev /dev/sde
>>   [18276.657204] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186412032 on dev /dev/sde
>>   [18276.660563] BTRFS warning (device sdf): checksum error at logical 2186416128 on dev /dev/sde, sector 2116744, root 5, inode 257, offset 135168, length 4096, links$
>>   [18276.664609] BTRFS error (device sdf): bdev /dev/sde errs: wr 0, rd 0, flush 0, corrupt 6, gen 0
>>   [18276.664609] BTRFS error (device sdf): unable to fixup (regular) error at logical 2186358784 on dev /dev/sde
>>
>> So fix this by using the bio_for_each_segment() API and setting before
>> the bio's bi_iter field to the value of the corresponding btrfs bio
>> container's saved iterator if we are processing a cloned bio in the
>> raid5/6 code (the same code processes both cloned and non-cloned bios).
>>
>> This incorrect iteration of cloned bios was also causing some occasional
>> BUG_ONs when running fstest btrfs/064, which have a trace like the
>> following:
>>
>>   [ 6674.416156] ------------[ cut here ]------------
>>   [ 6674.416157] kernel BUG at fs/btrfs/raid56.c:1897!
>>   [ 6674.416159] invalid opcode: 0000 [#1] PREEMPT SMP
>>   [ 6674.416160] Modules linked in: dm_flakey dm_mod dax ppdev tpm_tis parport_pc tpm_tis_core evdev tpm psmouse sg i2c_piix4 pcspkr parport i2c_core serio_raw button s
>>   [ 6674.416184] CPU: 3 PID: 19236 Comm: kworker/u32:10 Not tainted 4.12.0-rc6-btrfs-next-44+ #1
>>   [ 6674.416185] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>>   [ 6674.416210] Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
>>   [ 6674.416211] task: ffff880147f6c740 task.stack: ffffc90001fb8000
>>   [ 6674.416229] RIP: 0010:__raid_recover_end_io+0x1ac/0x370 [btrfs]
>>   [ 6674.416230] RSP: 0018:ffffc90001fbbb90 EFLAGS: 00010217
>>   [ 6674.416231] RAX: ffff8801ff4b4f00 RBX: 0000000000000002 RCX: 0000000000000001
>>   [ 6674.416232] RDX: ffff880099b045d8 RSI: ffffffff81a5f6e0 RDI: 0000000000000004
>>   [ 6674.416232] RBP: ffffc90001fbbbc8 R08: 0000000000000001 R09: 0000000000000001
>>   [ 6674.416233] R10: ffffc90001fbbac8 R11: 0000000000001000 R12: 0000000000000002
>>   [ 6674.416234] R13: ffff880099b045c0 R14: 0000000000000004 R15: ffff88012bff2000
>>   [ 6674.416235] FS:  0000000000000000(0000) GS:ffff88023f2c0000(0000) knlGS:0000000000000000
>>   [ 6674.416235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   [ 6674.416236] CR2: 00007f28cf282000 CR3: 00000001000c6000 CR4: 00000000000006e0
>>   [ 6674.416239] Call Trace:
>>   [ 6674.416259]  __raid56_parity_recover+0xfc/0x16e [btrfs]
>>   [ 6674.416276]  raid56_parity_recover+0x157/0x16b [btrfs]
>>   [ 6674.416293]  btrfs_map_bio+0xe0/0x259 [btrfs]
>>   [ 6674.416310]  btrfs_submit_bio_hook+0xbf/0x147 [btrfs]
>>   [ 6674.416327]  end_bio_extent_readpage+0x27b/0x4a0 [btrfs]
>>   [ 6674.416331]  bio_endio+0x17d/0x1b3
>>   [ 6674.416346]  end_workqueue_fn+0x3c/0x3f [btrfs]
>>   [ 6674.416362]  btrfs_scrubparity_helper+0x1aa/0x3b8 [btrfs]
>>   [ 6674.416379]  btrfs_endio_helper+0xe/0x10 [btrfs]
>>   [ 6674.416381]  process_one_work+0x276/0x4b6
>>   [ 6674.416384]  worker_thread+0x1ac/0x266
>>   [ 6674.416386]  ? rescuer_thread+0x278/0x278
>>   [ 6674.416387]  kthread+0x106/0x10e
>>   [ 6674.416389]  ? __list_del_entry+0x22/0x22
>>   [ 6674.416391]  ret_from_fork+0x27/0x40
>>   [ 6674.416395] Code: 44 89 e2 be 00 10 00 00 ff 15 b0 ab ef ff eb 72 4d 89 e8 89 d9 44 89 e2 be 00 10 00 00 ff 15 a3 ab ef ff eb 5d 41 83 fc ff 74 02 <0f> 0b 49 63 97
>>   [ 6674.416432] RIP: __raid_recover_end_io+0x1ac/0x370 [btrfs] RSP: ffffc90001fbbb90
>>   [ 6674.416434] ---[ end trace 74d56ebe7489dd6a ]---
>>
>
> Thank you so much for the fix!
>
>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/raid56.c | 26 ++++++++++++++++++--------
>>  1 file changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index b9abb0b01021..b89d07003697 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -1136,20 +1136,27 @@ static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
>>  static void index_rbio_pages(struct btrfs_raid_bio *rbio)
>>  {
>>       struct bio *bio;
>> -     struct bio_vec *bvec;
>>       u64 start;
>>       unsigned long stripe_offset;
>>       unsigned long page_index;
>> -     int i;
>>
>>       spin_lock_irq(&rbio->bio_list_lock);
>>       bio_list_for_each(bio, &rbio->bio_list) {
>> +             struct bio_vec bvec;
>> +             struct bvec_iter iter;
>> +             int i = 0;
>> +
>>               start = (u64)bio->bi_iter.bi_sector << 9;
>>               stripe_offset = start - rbio->bbio->raid_map[0];
>>               page_index = stripe_offset >> PAGE_SHIFT;
>>
>> -             bio_for_each_segment_all(bvec, bio, i)
>> -                     rbio->bio_pages[page_index + i] = bvec->bv_page;
>> +             if (bio_flagged(bio, BIO_CLONED))
>> +                     bio->bi_iter = btrfs_io_bio(bio)->iter;
>> +
>
> I think we can use use bio->bi_iter directly as the bio is not
> submitted yet, i.e. bi_iter is not advanced yet.

I've seen it cause problems by not setting it. I.e. the bio was
iterated before somewhere else.
Which lead to the following trace:

[ 3955.729020] general protection fault: 0000 [#1] PREEMPT SMP
[ 3955.729845] Modules linked in: btrfs ppdev tpm_tis evdev psmouse
parport_pc sg tpm_tis_core i2c_piix4 parport tpm pcspkr serio_raw
i2c_core button sunrpc loop auto
fs4 ext4 crc16 jbd2 mbcache raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c
crc32c_generic raid1 raid0 multipath line
ar md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata
virtio_pci virtio_ring scsi_mod virtio e1000 floppy [last unloaded:
btrfs]
[ 3955.731730] CPU: 15 PID: 26361 Comm: mount Not tainted
4.12.0-rc6-btrfs-next-47+ #1
[ 3955.731730] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
[ 3955.731730] task: ffff880235b5d680 task.stack: ffffc90002498000
[ 3955.731730] RIP: 0010:finish_rmw+0x1d6/0x3c4 [btrfs]
[ 3955.731730] RSP: 0018:ffffc9000249b3d8 EFLAGS: 00010246
[ 3955.731730] RAX: ffff880235e86000 RBX: ffff880210e23800 RCX: 0000000000000400
[ 3955.731730] RDX: ffff880000000000 RSI: db73880000000000 RDI: ffff880235e86000
[ 3955.731730] RBP: ffffc9000249b470 R08: 0000000000000001 R09: 0000000000000001
[ 3955.731730] R10: ffffc9000249b310 R11: 0000000000000003 R12: ffffc9000249b3d8
[ 3955.731730] R13: 0000000000000000 R14: 0000000000000003 R15: ffffc9000249b3f0
[ 3955.731730] FS:  00007f68fda61480(0000) GS:ffff88023f5c0000(0000)
knlGS:0000000000000000
[ 3955.731730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3955.731730] CR2: 000056403c233680 CR3: 000000021049e000 CR4: 00000000000006e0
[ 3955.731730] Call Trace:
[ 3955.731730]  full_stripe_write+0x69/0x93 [btrfs]
[ 3955.731730]  raid56_parity_write+0xa4/0x110 [btrfs]
[ 3955.731730]  btrfs_map_bio+0xca/0x259 [btrfs]
[ 3955.731730]  btrfs_submit_bio_hook+0xbf/0x147 [btrfs]
[ 3955.731730]  submit_one_bio+0x5d/0x7b [btrfs]
[ 3955.731730]  submit_extent_page.constprop.30+0x99/0x165 [btrfs]
[ 3955.731730]  ? __test_set_page_writeback+0x1aa/0x1bc
[ 3955.731730]  __extent_writepage_io+0x328/0x3a2 [btrfs]
[ 3955.731730]  ? end_extent_writepage+0xc4/0xc4 [btrfs]
[ 3955.731730]  __extent_writepage+0x236/0x2bd [btrfs]
[ 3955.731730]  extent_write_cache_pages.constprop.27+0x1ed/0x35e [btrfs]
[ 3955.731730]  extent_writepages+0x4c/0x5d [btrfs]
[ 3955.731730]  ? rcu_read_lock_sched_held+0x57/0x6c
[ 3955.731730]  ? btrfs_set_bit_hook+0x233/0x233 [btrfs]
[ 3955.731730]  ? __clear_extent_bit+0x2ab/0x2ca [btrfs]
[ 3955.731730]  btrfs_writepages+0x28/0x2a [btrfs]
[ 3955.731730]  do_writepages+0x3c/0x72
[ 3955.731730]  __filemap_fdatawrite_range+0x5a/0x63
[ 3955.731730]  filemap_fdatawrite_range+0x13/0x15
[ 3955.731730]  btrfs_fdatawrite_range+0x20/0x46 [btrfs]
[ 3955.731730]  __btrfs_write_out_cache+0x2db/0x3aa [btrfs]
[ 3955.731730]  btrfs_write_out_cache+0x8a/0xcd [btrfs]
[ 3955.731730]  btrfs_start_dirty_block_groups+0x190/0x394 [btrfs]
[ 3955.731730]  btrfs_commit_transaction+0xdd/0x7d6 [btrfs]
[ 3955.731730]  btrfs_create_uuid_tree+0xa3/0x10e [btrfs]
[ 3955.731730]  open_ctree+0x1ed5/0x21b5 [btrfs]
[ 3955.731730]  btrfs_mount+0x9b6/0xb14 [btrfs]
[ 3955.731730]  ? trace_hardirqs_on_caller+0x150/0x1ac
[ 3955.731730]  mount_fs+0x67/0x114
[ 3955.731730]  vfs_kern_mount+0x6b/0xdb
[ 3955.731730]  btrfs_mount+0x1a1/0xb14 [btrfs]
[ 3955.731730]  ? trace_hardirqs_on_caller+0x150/0x1ac
[ 3955.731730]  ? lockdep_init_map+0x17f/0x1d1
[ 3955.731730]  mount_fs+0x67/0x114
[ 3955.731730]  vfs_kern_mount+0x6b/0xdb
[ 3955.731730]  do_mount+0x6e3/0x96d
[ 3955.731730]  ? strndup_user+0x3f/0x73
[ 3955.731730]  SyS_mount+0x77/0x9f
[ 3955.731730]  entry_SYSCALL_64_fastpath+0x18/0xad
[ 3955.731730] RIP: 0033:0x7f68fd12a0ba
[ 3955.731730] RSP: 002b:00007fffa95cc358 EFLAGS: 00000202 ORIG_RAX:
00000000000000a5
[ 3955.731730] RAX: ffffffffffffffda RBX: ffffffff81092dd9 RCX: 00007f68fd12a0ba
[ 3955.731730] RDX: 000055abf6a10240 RSI: 000055abf6a10280 RDI: 000055abf6a10260
[ 3955.731730] RBP: ffffc9000249bf98 R08: 0000000000000000 R09: 0000000000000020
[ 3955.731730] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000000000000046
[ 3955.731730] R13: ffffc9000249bf78 R14: 0000000000000000 R15: 00000000ffffffff
[ 3955.731730]  ? trace_hardirqs_off_caller+0x3f/0xa3
[ 3955.731730] Code: 01 00 00 49 89 47 08 4c 89 e2 be 00 10 00 00 ff
15 b9 a5 ef ff eb 37 48 8b 45 a0 49 8b 34 24 b9 00 04 00 00 49 8b 04
c4 48 89 c7 <f3> a5 8b 75 9c 48 8b 7d 90 e8 16 f4 ff ff eb 13 8b 75 bc
31 c9
[ 3955.731730] RIP: finish_rmw+0x1d6/0x3c4 [btrfs] RSP: ffffc9000249b3d8
[ 3955.823152] ---[ end trace 5bf4b7e7b83f4313 ]---


>
>> +             bio_for_each_segment(bvec, bio, iter) {
>> +                     rbio->bio_pages[page_index + i] = bvec.bv_page;
>> +                     i++;
>> +             }
>>       }
>>       spin_unlock_irq(&rbio->bio_list_lock);
>>  }
>> @@ -1423,11 +1430,14 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
>>   */
>>  static void set_bio_pages_uptodate(struct bio *bio)
>>  {
>> -     struct bio_vec *bvec;
>> -     int i;
>> +     struct bio_vec bvec;
>> +     struct bvec_iter iter;
>> +
>> +     if (bio_flagged(bio, BIO_CLONED))
>> +             bio->bi_iter = btrfs_io_bio(bio)->iter;
>>
>
> Ditto.
>
> Others look good.
>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
>
> -liubo
>
>> -     bio_for_each_segment_all(bvec, bio, i)
>> -             SetPageUptodate(bvec->bv_page);
>> +     bio_for_each_segment(bvec, bio, iter)
>> +             SetPageUptodate(bvec.bv_page);
>>  }
>>
>>  /*
>> --
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
