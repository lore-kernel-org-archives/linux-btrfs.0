Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53870 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752128AbcJRXeJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 19:34:09 -0400
Date: Tue, 18 Oct 2016 19:31:48 -0400
From: Chris Mason <clm@fb.com>
To: Jens Axboe <axboe@fb.com>
CC: Dave Jones <davej@codemonkey.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161018233148.GA93792@clm-mbp.masoncoding.com>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 05:12:41PM -0600, Jens Axboe wrote:
>On 10/18/2016 04:42 PM, Dave Jones wrote:
>>So Chris had me do a run on ext4 just for giggles. It took a while, but
>>eventually this fell out...
>>
>>
>>WARNING: CPU: 3 PID: 21324 at lib/list_debug.c:33 __list_add+0x89/0xb0
>>list_add corruption. prev->next should be next (ffffe8ffffc05648), but was ffffc9000028bcd8. (prev=ffff880503a145c0).
>>CPU: 3 PID: 21324 Comm: modprobe Not tainted 4.9.0-rc1-think+ #1
>> ffffc90000a6b7b8 ffffffff81320e3c ffffc90000a6b808 0000000000000000
>> ffffc90000a6b7f8 ffffffff8107a711 0000002100000246 ffff8805039f1740
>> ffff880503a145c0 ffffe8ffffc05648 ffffe8ffffa05600 ffff880502c39548
>>Call Trace:
>> [<ffffffff81320e3c>] dump_stack+0x4f/0x73
>> [<ffffffff8107a711>] __warn+0xc1/0xe0
>> [<ffffffff8107a78a>] warn_slowpath_fmt+0x5a/0x80
>> [<ffffffff8133f499>] __list_add+0x89/0xb0
>> [<ffffffff8130af88>] blk_sq_make_request+0x2f8/0x350
>> [<ffffffff812fe6dc>] ? generic_make_request+0xec/0x240
>> [<ffffffff812fe6e9>] generic_make_request+0xf9/0x240
>> [<ffffffff812fe8a8>] submit_bio+0x78/0x150
>> [<ffffffff8120bde6>] ? __find_get_block+0x126/0x130
>> [<ffffffff8120cbff>] submit_bh_wbc+0x16f/0x1e0
>> [<ffffffff8120a400>] ? __end_buffer_read_notouch+0x20/0x20
>> [<ffffffff8120d958>] ll_rw_block+0xa8/0xb0
>> [<ffffffff8120da0f>] __breadahead+0x3f/0x70
>> [<ffffffff81264ffc>] __ext4_get_inode_loc+0x37c/0x3d0
>> [<ffffffff8126806d>] ext4_iget+0x8d/0xb90
>> [<ffffffff811f0759>] ? d_alloc_parallel+0x329/0x700
>> [<ffffffff81268b9a>] ext4_iget_normal+0x2a/0x30
>> [<ffffffff81273cd6>] ext4_lookup+0x136/0x250
>> [<ffffffff811e118d>] lookup_slow+0x12d/0x220
>> [<ffffffff811e3897>] walk_component+0x1e7/0x310
>> [<ffffffff811e33f8>] ? path_init+0x4d8/0x520
>> [<ffffffff811e4022>] path_lookupat+0x62/0x120
>> [<ffffffff811e4f22>] ? getname_flags+0x32/0x180
>> [<ffffffff811e5278>] filename_lookup+0xa8/0x130
>> [<ffffffff81352526>] ? strncpy_from_user+0x46/0x170
>> [<ffffffff811e4f3e>] ? getname_flags+0x4e/0x180
>> [<ffffffff811e53d1>] user_path_at_empty+0x31/0x40
>> [<ffffffff811d9df1>] vfs_fstatat+0x61/0xc0
>> [<ffffffff810c8b9f>] ? __lock_acquire.isra.32+0x1cf/0x8c0
>> [<ffffffff811da30e>] SYSC_newstat+0x2e/0x60
>> [<ffffffff8133f403>] ? __this_cpu_preempt_check+0x13/0x20
>> [<ffffffff811da499>] SyS_newstat+0x9/0x10
>> [<ffffffff8100259c>] do_syscall_64+0x5c/0x170
>> [<ffffffff817c27cb>] entry_SYSCALL64_slow_path+0x25/0x25
>>
>>So this one isn't a btrfs specific problem as I first thought.
>>
>>This sometimes reproduces within minutes, sometimes hours, which makes
>>it a pain to bisect.  It only started showing up this merge window though.
>
>Chinner reported the same thing on XFS, I'll look into it asap.

Jens, not sure if you saw the whole thread.  This has triggered bad page 
state errors, and also corrupted a btrfs list.  It hurts me to say, but 
it might not actually be your fault.

-chris
