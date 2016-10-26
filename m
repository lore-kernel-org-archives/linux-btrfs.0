Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33880 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932898AbcJZXUY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 19:20:24 -0400
Date: Wed, 26 Oct 2016 19:19:51 -0400
From: Chris Mason <clm@fb.com>
To: Jens Axboe <axboe@fb.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@codemonkey.org.uk>,
        Andy Lutomirski <luto@amacapital.net>,
        "Andy Lutomirski" <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026231950.GB15247@clm-mbp.thefacebook.com>
References: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
 <20161026184201.6ofblkd3j5uxystq@codemonkey.org.uk>
 <CA+55aFwD9McVapb0svQrrvP1k6iSkqz5ENNGXY6b+Yo-k7wOsg@mail.gmail.com>
 <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 05:03:45PM -0600, Jens Axboe wrote:
>On 10/26/2016 04:58 PM, Linus Torvalds wrote:
>>On Wed, Oct 26, 2016 at 3:51 PM, Linus Torvalds
>><torvalds@linux-foundation.org> wrote:
>>>
>>>Dave: it might be a good idea to split that "WARN_ON_ONCE()" in
>>>blk_mq_merge_queue_io() into two
>>
>>I did that myself too, since Dave sees this during boot.
>>
>>But I'm not getting the warning ;(
>>
>>Dave gets it with ext4, and thats' what I have too, so I'm not sure
>>what the required trigger would be.
>
>Actually, I think I see what might trigger it. You are on nvme, iirc,
>and that has a deep queue. Dave, are you testing on a sata drive or
>something similar with a shallower queue depth? If we end up sleeping
>for a request, I think we could trigger data->ctx being different.
>
>Dave, can you hit the warnings with this? Totally untested...

Confirmed, totally untested ;)  Don't try this one at home folks 
(working this out with Jens offlist)

G: unable to handle kernel paging request at 0000000002411200
IP: [<ffffffff819acff2>] _raw_spin_lock+0x22/0x40
PGD 12840a067
PUD 128446067
PMD 0

Oops: 0002 [#1] PREEMPT SMP
Modules linked in: virtio_blk(+)
CPU: 4 PID: 125 Comm: modprobe Not tainted 
4.9.0-rc2-00041-g811d54d-dirty #320
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 
04/01/2014
task: ffff88013849aac0 task.stack: ffff8801293d8000
RIP: 0010:[<ffffffff819acff2>]  [<ffffffff819acff2>] 
_raw_spin_lock+0x22/0x40
RSP: 0018:ffff8801293db278  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000002411200 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff88013a5c1048 RDI: 0000000000000000
RBP: ffff8801293db288 R08: 0000000000000005 R09: ffff880128449380
R10: 0000000000000000 R11: 0000000000000008 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000076 R15: ffff8801293b6a80
FS:  00007f1a2a9cdb40(0000) GS:ffff88013fd00000(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002411200 CR3: 000000013a5d1000 CR4: 00000000000406e0
Stack:
 ffff8801293db2d0 ffff880128488000 ffff8801293db348 ffffffff814debff
 00ff8801293db2c8 ffff8801293db338 ffff8801284888c0 ffff8801284888b8
 000060fec00004f9 0000000002411200 ffff880128f810c0 ffff880128f810c0
Call Trace:
 [<ffffffff814debff>] blk_sq_make_request+0x34f/0x580
 [<ffffffff8116b005>] ? mempool_alloc_slab+0x15/0x20
 [<ffffffff814d5444>] generic_make_request+0x104/0x200
 [<ffffffff814d55a5>] submit_bio+0x65/0x130
 [<ffffffff8122a06e>] submit_bh_wbc+0x16e/0x210
 [<ffffffff8122a123>] submit_bh+0x13/0x20
 [<ffffffff8122b075>] block_read_full_page+0x205/0x3d0
 [<ffffffff8122cf00>] ? I_BDEV+0x20/0x20
 [<ffffffff8117a1fe>] ? lru_cache_add+0xe/0x10
 [<ffffffff81167502>] ? add_to_page_cache_lru+0x92/0xf0
 [<ffffffff81166c41>] ? __page_cache_alloc+0xd1/0xe0
 [<ffffffff8122df38>] blkdev_readpage+0x18/0x20
 [<ffffffff8116ada6>] do_read_cache_page+0x1c6/0x380
 [<ffffffff8122df20>] ? blkdev_writepages+0x10/0x10
 [<ffffffff811c6662>] ? alloc_pages_current+0xb2/0x1c0
 [<ffffffff8116af92>] read_cache_page+0x12/0x20
 [<ffffffff814e6b11>] read_dev_sector+0x31/0xb0
 [<ffffffff814eb31d>] read_lba+0xbd/0x130
 [<ffffffff814eb682>] find_valid_gpt+0xa2/0x580
 [<ffffffff814ebb60>] ? find_valid_gpt+0x580/0x580
 [<ffffffff814ebbc7>] efi_partition+0x67/0x3d0
 [<ffffffff81509cfa>] ? vsnprintf+0x2aa/0x470
 [<ffffffff81509f64>] ? snprintf+0x34/0x40
 [<ffffffff814ebb60>] ? find_valid_gpt+0x580/0x580
 [<ffffffff814e8f46>] check_partition+0x106/0x1e0
 [<ffffffff814e741c>] rescan_partitions+0x8c/0x270
 [<ffffffff8122ef98>] __blkdev_get+0x328/0x3f0
 [<ffffffff8122f0b4>] blkdev_get+0x54/0x320
 [<ffffffff8120be7a>] ? unlock_new_inode+0x5a/0x80
 [<ffffffff8122dc0f>] ? bdget+0xff/0x110
 [<ffffffff814e4d16>] device_add_disk+0x3c6/0x450
 [<ffffffff8151970a>] ? ioread8+0x1a/0x40
 [<ffffffff815bc68e>] ? vp_get+0x4e/0x70
 [<ffffffffa0001540>] virtblk_probe+0x460/0x708 [virtio_blk]
 [<ffffffff815bc556>] ? vp_finalize_features+0x36/0x50
 [<ffffffff815b8c82>] virtio_dev_probe+0x132/0x1e0
 [<ffffffff81619709>] driver_probe_device+0x1a9/0x2d0
 [<ffffffff819aa9e4>] ? mutex_lock+0x24/0x50
 [<ffffffff816198ed>] __driver_attach+0xbd/0xc0
 [<ffffffff81619830>] ? driver_probe_device+0x2d0/0x2d0
 [<ffffffff81619830>] ? driver_probe_device+0x2d0/0x2d0
 [<ffffffff816178aa>] bus_for_each_dev+0x8a/0xb0
 [<ffffffff8161920e>] driver_attach+0x1e/0x20
 [<ffffffff81618bf6>] bus_add_driver+0x1b6/0x230
 [<ffffffff8161a200>] driver_register+0x60/0xe0
 [<ffffffff815b8f50>] register_virtio_driver+0x20/0x40
 [<ffffffffa0004057>] init+0x57/0x81 [virtio_blk]
 [<ffffffffa0004000>] ? 0xffffffffa0004000
 [<ffffffffa0004000>] ? 0xffffffffa0004000
 [<ffffffff810003a6>] do_one_initcall+0x46/0x150
 [<ffffffff810e923a>] do_init_module+0x6a/0x210
 [<ffffffff811b32b7>] ? vfree+0x37/0x90
 [<ffffffff810ebe68>] load_module+0x1638/0x1860
 [<ffffffff810e83f0>] ? do_free_init+0x30/0x30
 [<ffffffff811f6da4>] ? kernel_read_file_from_fd+0x54/0x90
 [<ffffffff810ec152>] SYSC_finit_module+0xc2/0xd0
 [<ffffffff810ec16e>] SyS_finit_module+0xe/0x10
 [<ffffffff819ad1a0>] entry_SYSCALL_64_fastpath+0x13/0x94
Code: 89 df e8 a2 52 70 ff eb e6 55 48 89 e5 53 48 83 ec 08 66 66 66 66 
90 48 89 fb bf 01 00 00 00 e8 95 53 6e ff 31 c0 ba 01 00 00 00 <f0> 0f 
b1 13 85 c0 75 07 48 83 c4 08 5b c9 c3 89 c6 48 89 df e8
RIP  [<ffffffff819acff2>] _raw_spin_lock+0x22/0x40
 RSP <ffff8801293db278>
CR2: 0000000002411200
---[ end trace e8cb117e64947621 ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception

-chris
