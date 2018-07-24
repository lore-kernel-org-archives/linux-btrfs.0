Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20487 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388136AbeGXKEg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 06:04:36 -0400
Date: Tue, 24 Jul 2018 16:59:00 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, Nikolay Borisov <nborisov@suse.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] fs_info cleanups for volume.c
Message-ID: <20180724085856.GF575@fnst.localdomain>
References: <1532104673-28311-1-git-send-email-nborisov@suse.com>
 <20180723132501.GL26141@twin.jikos.cz>
 <20180724082804.GS26141@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180724082804.GS26141@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 24, 2018 at 10:28:04AM +0200, David Sterba wrote:
>On Mon, Jul 23, 2018 at 03:25:01PM +0200, David Sterba wrote:
>> On Fri, Jul 20, 2018 at 07:37:46PM +0300, Nikolay Borisov wrote:
>> > Here are a bunch of patches which cleanup extraneous fs_info parameters to 
>> > function which already take a structure that holds a reference to the fs_info. 
>> > 
>> > Except for patches 4 and 5, everything else is correct - due to those functions
>> > always taking a transaction. 4 and 5 in turn reference the fs_info from 
>> > struct btrfs_device. Inspecting the callers I managed to convince myself that 
>> > those function are always called with well-formed btrfs_device i.e one which 
>> > has its fs_info member initialised. Reviewers might want to pay extra 
>> > attention to that but otherwise they are trivial. 
>> 
>> 4 and 5 look good to me, a device without a valid fs_info has a short
>> timespan and should not appear anywhere besides the helpers that set up
>> fs_devices etc. Series added to misc-next, thanks.
>
>btrfs/164 crashed in device rm that could be related to the patches, I
>haven't analyzed that but this series looks most suspicious since the
>last round of tests that did not see that crash:
>
>[ 6712.084324] general protection fault: 0000 [#1] PREEMPT SMP
>[ 6712.090096] CPU: 0 PID: 2694 Comm: btrfs Not tainted4.18.0-rc6-1.ge195904-vanilla+ #279
>[ 6712.098398] Hardware name: empty empty/S3993, BIOS PAQEX0-302/24/2008
>[ 6712.105072] RIP: 0010:__list_del_entry_valid+0x25/0xc0
>[ 6712.129603] RSP: 0018:ffffb01281e2bbd0 EFLAGS: 00010a83
>[ 6712.134969] RAX: 6b6b6b6b6b6b6b6b RBX: ffff9972756dafd8 RCX:dead000000000200
>[ 6712.142246] RDX: 6b6b6b6b6b6b6b6b RSI: ffffffffc10252cf RDI:ffff9972756db100
>[ 6712.149507] RBP: ffff9972756db100 R08: 0000000000000000 R09:0000000000000001
>[ 6712.156788] R10: ffffb01281e2bbd8 R11: 0000000000000000 R12:ffff99728a2d7500
>[ 6712.164059] R13: ffff9972756c0910 R14: ffff99728a2d7450 R15:6b6b6b6b6b6b6a43
>[ 6712.171332] FS:  00007f3100bb58c0(0000) GS:ffff9972a6600000(0000)knlGS:0000000000000000
>[ 6712.179615] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[ 6712.185507] CR2: 00007f336c989000 CR3: 00000001f6868000 CR4:00000000000006f0
>[ 6712.192779] Call Trace:
>[ 6712.195423]  btrfs_update_commit_device_size+0x75/0xf0 [btrfs]
>[ 6712.201424]  btrfs_commit_transaction+0x57d/0xa90 [btrfs]
>[ 6712.206999]  btrfs_rm_device+0x627/0x850 [btrfs]
>[ 6712.211800]  btrfs_ioctl+0x2b03/0x3120 [btrfs]
>[ 6712.216404]  ? __might_fault+0x3e/0x90
>[ 6712.220277]  ? lock_acquire+0x9f/0x270
>[ 6712.224156]  ? __audit_syscall_entry+0xd6/0x170
>[ 6712.228835]  ? ktime_get_coarse_real_ts64+0x67/0x100
>[ 6712.233940]  ? do_vfs_ioctl+0xa5/0x6f0
>[ 6712.237836]  do_vfs_ioctl+0xa5/0x6f0
>[ 6712.241554]  ? syscall_trace_enter+0x1e8/0x3e0
>[ 6712.246130]  ksys_ioctl+0x70/0x80
>[ 6712.249593]  __x64_sys_ioctl+0x16/0x20
>[ 6712.253484]  do_syscall_64+0x62/0x1c0
>[ 6712.257291]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
>[ 6712.262482] RIP: 0033:0x7f30ffc52417
>[ 6712.285413] RSP: 002b:00007ffd636f32c8 EFLAGS: 00000202 ORIG_RAX:0000000000000010
>[ 6712.293191] RAX: ffffffffffffffda RBX: 00007ffd636f5460 RCX:00007f30ffc52417
>[ 6712.300462] RDX: 00007ffd636f4300 RSI: 000000005000943a RDI:0000000000000003
>[ 6712.307742] RBP: 00007ffd636f4300 R08: 0000000000000000 R09:0000000000100000
>[ 6712.315005] R10: 000000000fa99fa0 R11: 0000000000000202 R12:0000000000000000
>[ 6712.322286] R13: 0000000000000000 R14: 0000000000000003 R15:00007ffd636f5468
>[ 6712.391596] ---[ end trace f05bf71894e4ee4d ]---
>
>

Hi, David

After I applied this patchset, my test also encountered this crash.
However, the result of git bisect shows the cause may be the
"[PATCH 2/2] btrfs: fix missing superblock update in the device delete commit transaction".
Moreover, I have reported this to Anand Jain. I will send him the updated
log(kasan enabled), and tell him why he can't reproduce before. Please
see the thread I will cc you.

-- 
Thanks,
Lu


