Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030404AbcJ0OIn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 10:08:43 -0400
Subject: Re: bio linked list corruption.
To: Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <488f9edc-6a1c-2c68-0d33-d3aa32ece9a4@fb.com>
 <ac6cd46c-d609-ef1f-019f-204248c26c12@fb.com>
 <CA+55aFwY5jNcUAJzDWERP2r9iZHEKzHSwMi5AJCJiaVd3Z0E-g@mail.gmail.com>
 <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <b18208b6-f2f4-ddbb-a5b9-1c90ac7321f5@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <6b7b958d-7017-a0f6-efe7-43aedba08a17@fb.com>
Date: Thu, 27 Oct 2016 09:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <b18208b6-f2f4-ddbb-a5b9-1c90ac7321f5@fb.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/26/2016 08:00 PM, Jens Axboe wrote:
> On 10/26/2016 05:47 PM, Dave Jones wrote:
>> On Wed, Oct 26, 2016 at 07:38:08PM -0400, Chris Mason wrote:
>>
>>  > >-    hctx->queued++;
>>  > >-    data->hctx = hctx;
>>  > >-    data->ctx = ctx;
>>  > >+    data->hctx = alloc_data.hctx;
>>  > >+    data->ctx = alloc_data.ctx;
>>  > >+    data->hctx->queued++;
>>  > >     return rq;
>>  > > }
>>  >
>>  > This made it through an entire dbench 2048 run on btrfs.  My script
>> has
>>  > it running in a loop, but this is farther than I've gotten before.
>>  > Looking great so far.
>>
>> Fixed the splat during boot for me too.
>> Now the fun part, let's see if it fixed the 'weird shit' that Trinity
>> was stumbling on.
> 
> Let's let the testing simmer overnight, then I'll turn this into a real
> patch tomorrow and get it submitted.
> 

I ran all night on both btrfs and xfs.  XFS came out clean, but btrfs hit
the WARN_ON below.  I hit it a few times with Jens' patch, always the
same warning.  It's pretty obviously a btrfs bug, we're not cleaning up
this list properly during fsync.  I tried a v1 of a btrfs fix overnight,
but I see where it was incomplete now and will re-run.

For the blk-mq bug, I think we got it!

Tested-by: always-blaming-jens-from-now-on <clm@fb.com>

WARNING: CPU: 5 PID: 16163 at lib/list_debug.c:62 __list_del_entry+0x86/0xd0
list_del corruption. next->prev should be ffff8801196d3be0, but was ffff88010fc63308
Modules linked in: crc32c_intel aesni_intel aes_x86_64 glue_helper i2c_piix4 lrw i2c_core gf128mul ablk_helper virtio_net serio_raw button pcspkr floppy cryptd sch_fq_codel autofs4 virtio_blk
CPU: 5 PID: 16163 Comm: dbench Not tainted 4.9.0-rc2-00041-g811d54d-dirty #322
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.0-1.fc24 04/01/2014
 ffff8801196d3a68 ffffffff814fde3f ffffffff8151c356 ffff8801196d3ac8
 ffff8801196d3ac8 0000000000000000 ffff8801196d3ab8 ffffffff810648cf
 dead000000000100 0000003e813bfc4a ffff8801196d3b98 ffff880122b5c800
Call Trace:
 [<ffffffff814fde3f>] dump_stack+0x53/0x74
 [<ffffffff8151c356>] ? __list_del_entry+0x86/0xd0
 [<ffffffff810648cf>] __warn+0xff/0x120
 [<ffffffff810649a9>] warn_slowpath_fmt+0x49/0x50
 [<ffffffff8151c356>] __list_del_entry+0x86/0xd0
 [<ffffffff8143618d>] btrfs_sync_log+0x75d/0xbd0
 [<ffffffff8143cfa7>] ? btrfs_log_inode_parent+0x547/0xbb0
 [<ffffffff819ad01b>] ? _raw_spin_lock+0x1b/0x40
 [<ffffffff8108d1a3>] ? __might_sleep+0x53/0xa0
 [<ffffffff812095c5>] ? dput+0x65/0x280
 [<ffffffff8143d717>] ? btrfs_log_dentry_safe+0x77/0x90
 [<ffffffff81405b04>] btrfs_sync_file+0x424/0x490
 [<ffffffff8107535a>] ? SYSC_kill+0xba/0x1d0
 [<ffffffff811f2348>] ? __sb_end_write+0x58/0x80
 [<ffffffff812258ac>] vfs_fsync_range+0x4c/0xb0
 [<ffffffff81002501>] ? syscall_trace_enter+0x201/0x2e0
 [<ffffffff8122592c>] vfs_fsync+0x1c/0x20
 [<ffffffff8122596d>] do_fsync+0x3d/0x70
 [<ffffffff810029cb>] ? syscall_slow_exit_work+0xfb/0x100
 [<ffffffff812259d0>] SyS_fsync+0x10/0x20
 [<ffffffff81002b65>] do_syscall_64+0x55/0xd0
 [<ffffffff810026d7>] ? prepare_exit_to_usermode+0x37/0x40
 [<ffffffff819ad286>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace c93288442a6424aa ]---

