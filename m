Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab3IICj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 Sep 2013 22:39:59 -0400
Message-ID: <522D3475.3010104@cn.fujitsu.com>
Date: Mon, 09 Sep 2013 10:37:41 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Dusty Mabe <dustymabe@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BUG: qgroup scan started
References: <CAFfJ-R6iw4ubyvcwtom9nZXjVpWfpzF+K+sJXKwQTWXiYcBBOA@mail.gmail.com>
In-Reply-To: <CAFfJ-R6iw4ubyvcwtom9nZXjVpWfpzF+K+sJXKwQTWXiYcBBOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This should have been fixed, the following patch should have fixed it.

Btrfs: fix memory patcher through fs_info->qgroup_ulist

https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?id=4373519db4dbca05341a60b28f6e159b106e4c4b

You can try btrfs-next:
git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

Thanks,
Wang

On 09/09/2013 10:17 AM, Dusty Mabe wrote:
> Hi,
>
> I have a filesystem that I have enabled quota on (in hopes of viewing
> qgroup information). I did a 'quota enable', 'quota rescan', etc.. and
> can actually view information output from qgroup show:
>
> dustymabe@laptop: Desktop>sudo btrfs qgroup show /
> 0/5 26262700032 2084864
> 0/257 4101042176 990027776
> 0/258 6579482624 977936384
> 0/259 8280444928 992739328
> 0/260 29985890304 1444683776
> 0/261 30732304384 393986048
> 0/262 27710410752 732024832
> 0/263 26291232768 15314944
>
> This all seems well, but I do notice after a reboot that I get a Null
> pointer dereference during bootup. I have posted the backtrace
> information at the bottom of the email. I originally created the
> filesystem in Fedora 17 but have since upgraded and am now using the
> following:
>
> dustymabe@laptop: Desktop>uname -r
> 3.10.10-200.fc19.x86_64
> dustymabe@laptop: Desktop>rpm -q btrfs-progs
> btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64
>
>
> Full Disclaimer: I don't really know what I am doing. I just saw the
> bt and thought I would try to help if I can. Let me know if you want
> me to help investigate or if you want me to file a bug report.
> Unfortunately I was not able to recreate on a VM so it may have
> something to do with creating the fs in F17 and moving forward.
>
> Thanks,
> Dusty
>
>
> ------ Pasted Trace -------
> device fsid 0bf76cb1-1a9f-4ae4-a83f-f7726e2c3ea9 devid 1 transid 33155 /dev/sda3
> btrfs: qgroup scan started
> BUG: unable to handle kernel NULL pointer dereference at 00000000000001e8
> IP: [<ffffffffa029446b>] start_transaction+0x1b/0x510 [btrfs]
> PGD 0
> Oops: 0000 [#1] SMP
> Modules linked in: btrfs libcrc32c xor zlib_deflate raid6_pq radeon
> i915 i2c_algo_bit drm_kms_helper ttm drm video i2c_core
> CPU: 1 PID: 178 Comm: btrfs-qgroup-re Not tainted 3.10.10-200.fc19.x86_64 #1
> Hardware name: LENOVO 09932MU/Emerald Lake, BIOS 57CN30WW 12/05/2011
> task: ffff8801a430e320 ti: ffff8801a3aea000 task.ti: ffff8801a3aea000
> RIP: 0010:[<ffffffffa029446b>]  [<ffffffffa029446b>]
> start_transaction+0x1b/0x510 [btrfs]
> RSP: 0018:ffff8801a3aebd00  EFLAGS: 00010286
> RAX: ffff8801a418fc00 RBX: 0000000000000000 RCX: 0000000000000002
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8801a3aebd40 R08: 0000000000016f00 R09: ffff8801a9003600
> R10: ffffffffa02ed013 R11: ffffffffffffffdc R12: 0000000000000000
> R13: ffff8801a3defd80 R14: ffff8801a5248000 R15: ffff8801a3def960
> FS:  0000000000000000(0000) GS:ffff8801afa40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000000001e8 CR3: 0000000001c0c000 CR4: 00000000000407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Stack:
>   ffffffff8117f172 ffffffff8117f1fc ffffffffa02ec452 ffff8801a3def9b0
>   ffff8801a3def978 ffff8801a3defd80 ffff8801a5248000 ffff8801a3def960
>   ffff8801a3aebd50 ffffffffa0294978 ffff8801a3aebe28 ffffffffa02ed02b
> Call Trace:
>   [<ffffffff8117f172>] ? kmem_cache_alloc+0x1d2/0x220
>   [<ffffffff8117f1fc>] ? kmem_cache_alloc_trace+0x3c/0x240
>   [<ffffffffa02ec452>] ? ulist_alloc+0x22/0x60 [btrfs]
>   [<ffffffffa0294978>] btrfs_start_transaction+0x18/0x20 [btrfs]
>   [<ffffffffa02ed02b>] btrfs_qgroup_rescan_worker+0x7b/0x720 [btrfs]
>   [<ffffffff8106c002>] ? del_timer_sync+0x52/0x60
>   [<ffffffff8163c2f9>] ? schedule_timeout+0x179/0x2c0
>   [<ffffffff8106b1d0>] ? __internal_add_timer+0x130/0x130
>   [<ffffffffa02c015b>] worker_loop+0x12b/0x500 [btrfs]
>   [<ffffffffa02c0030>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
>   [<ffffffff81080b60>] kthread+0xc0/0xd0
>   [<ffffffff81080aa0>] ? insert_kthread_work+0x40/0x40
>   [<ffffffff81647bac>] ret_from_fork+0x7c/0xb0
>   [<ffffffff81080aa0>] ? insert_kthread_work+0x40/0x40
> Code: 83 e8 02 66 89 57 fe e9 5c fc ff ff 0f 1f 40 00 66 66 66 66 90
> 55 48 89 e5 41 57 41 56 41 55 41 54 49 89 fc 53 89 d3 48 83 ec 18 <48>
> 8b 87 e8 01 00 00 48 8b 90 b8 14 00 00 83 e2 01 0f 85 8e 00
> RIP  [<ffffffffa029446b>] start_transaction+0x1b/0x510 [btrfs]
>   RSP <ffff8801a3aebd00>
> CR2: 00000000000001e8
> ---[ end trace b55740efb8d48acc ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

