Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35865 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbdLGBTD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Dec 2017 20:19:03 -0500
Received: by mail-wr0-f180.google.com with SMTP id v105so5782690wrc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Dec 2017 17:19:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20692bf4-9141-f248-cd4c-00888ccbd2f8@gmx.com>
References: <CAM50xkkrME2aq9kqZALwU5UjWBaKQcJYMbAs12GA-Ytc3aEkUg@mail.gmail.com>
 <20692bf4-9141-f248-cd4c-00888ccbd2f8@gmx.com>
From: Taibai Li <litaibaichina@gmail.com>
Date: Thu, 7 Dec 2017 09:19:01 +0800
Message-ID: <CAM50xkmH-E7AJkSoBm-5RkjvKh24fg+EuSFcQHfdmkkyXh2q9w@mail.gmail.com>
Subject: Re: system OOM when using ghettoVCB script to backup VMs to nfs
 server (sync mode) running btrfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

thanks for the quick response,  I tired to test this on 4.4.100
kernel, disabled quota :
# btrfs qgroup show /data/
ERROR: can't list qgroups: quotas not enabled

But seems it still OOM after about 7 hours copyed  144G files,  any
other ideas?  Maybe I will try to test by disable quota on 4.14 kernel
too.

thanks.

On Wed, Dec 6, 2017 at 2:25 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年12月06日 14:22, taibai li wrote:
>> Hi Guys,
>>
>> I hit the OOM issues with as Box running 4.4.x kernel,   so I tried to
>> build a 4.14.3 kernel to try that.  The testbed is :
>> NAS box with 2G memory, and a single disk raid ,  I setup a nfs server
>> with sync mode,  add the storage on ESXi servers 6.0 and backup all
>> the VMs on it by the ghettoVCB script , after about 14 hours,
>> Inpot/Output error happened,
>> checked the box , found OOM.
>> # cat /etc/exports
>> "/data/Videos" *(insecure,insecure_locks,no_subtree_check,crossmnt,anonuid=99,anongid=99,root_squash,rw,sync)
>> # uname -a
>> Linux lzx-314-desk 4.14.3.x86_64.1 #1 SMP Fri Dec 1 01:31:25 UTC 2017
>> x86_64 GNU/Linux
>> # btrfs fi show /data/
>> Label: '43f611ae:data' uuid: 6fefb319-a21d-476e-9642-565e0600a049
>> Total devices 1 FS bytes used 292.78GiB
>> devid 1 size 1.81TiB used 296.02GiB path /dev/md127
>>
>> The stack is :
>> Dec 04 23:47:43 lzx-314-desk kernel: nfsd: page allocation stalls for
>> 621031ms, order:0, mode:0x14000c0(GFP_KERNEL), nodemask=(null)
>> Dec 04 23:47:43 lzx-314-desk kernel: nfsd cpuset=/ mems_allowed=0
>> Dec 04 23:47:43 lzx-314-desk kernel: CPU: 0 PID: 3376 Comm: nfsd Not
>> tainted 4.14.3.x86_64.1 #1
>> Dec 04 23:47:43 lzx-314-desk kernel: Hardware name: NETGEAR ReadyNAS
>> 314/To be filled by O.E.M., BIOS 4.6.5 11/05/2013
>> Dec 04 23:47:43 lzx-314-desk kernel: Call Trace:
>> Dec 04 23:47:43 lzx-314-desk kernel: dump_stack+0x4d/0x6a
>> Dec 04 23:47:43 lzx-314-desk kernel: warn_alloc+0xe3/0x180
>> Dec 04 23:47:43 lzx-314-desk kernel: __alloc_pages_nodemask+0xb1e/0xed0
>> Dec 04 23:47:43 lzx-314-desk kernel: svc_recv+0x99/0x900
>> Dec 04 23:47:43 lzx-314-desk kernel: ? svc_process+0x241/0x690
>> Dec 04 23:47:43 lzx-314-desk kernel: nfsd+0xd2/0x150
>> Dec 04 23:47:43 lzx-314-desk kernel: kthread+0x11a/0x150
>> Dec 04 23:47:43 lzx-314-desk kernel: ? nfsd_destroy+0x60/0x60
>> Dec 04 23:47:43 lzx-314-desk kernel: ? kthread_create_on_node+0x40/0x40
>> Dec 04 23:47:43 lzx-314-desk kernel: ret_from_fork+0x22/0x30
>> Dec 04 23:47:43 lzx-314-desk kernel: readynasd invoked oom-killer:
>> gfp_mask=0x14200ca(GFP_HIGHUSER_MOVABLE), nodemask=(null), order=0,
>> oom_score_adj=-1000
>> Dec 04 23:47:43 lzx-314-desk kernel: readynasd cpuset=/ mems_allowed=0
>> Dec 04 23:47:43 lzx-314-desk kernel: CPU: 3 PID: 3307 Comm: readynasd
>> Not tainted 4.14.3.x86_64.1 #1
>> Dec 04 23:47:43 lzx-314-desk kernel: Hardware name: NETGEAR ReadyNAS
>> 314/To be filled by O.E.M., BIOS 4.6.5 11/05/2013
>> Dec 04 23:47:43 lzx-314-desk kernel: Call Trace:
>> Dec 04 23:47:43 lzx-314-desk kernel: dump_stack+0x4d/0x6a
>> Dec 04 23:47:43 lzx-314-desk kernel: dump_header+0x9a/0x21b
>> Dec 04 23:47:43 lzx-314-desk kernel: ? pick_next_task_fair+0x1d5/0x4b0
>> Dec 04 23:47:43 lzx-314-desk kernel: ? security_capable_noaudit+0x40/0x60
>> Dec 04 23:47:43 lzx-314-desk kernel: oom_kill_process+0x216/0x430
>> Dec 04 23:47:43 lzx-314-desk kernel: out_of_memory+0xf9/0x2e0
>> Dec 04 23:47:43 lzx-314-desk kernel: __alloc_pages_nodemask+0xd6c/0xed0
>> Dec 04 23:47:43 lzx-314-desk kernel: __read_swap_cache_async+0x11d/0x190
>> Dec 04 23:47:43 lzx-314-desk kernel: read_swap_cache_async+0x17/0x40
>> Dec 04 23:47:43 lzx-314-desk kernel: swapin_readahead+0x1f1/0x230
>> Dec 04 23:47:43 lzx-314-desk kernel: ? find_get_entry+0x19/0xf0
>> Dec 04 23:47:43 lzx-314-desk kernel: ? pagecache_get_page+0x27/0x210
>> Dec 04 23:47:43 lzx-314-desk kernel: do_swap_page+0x432/0x590
>> Dec 04 23:47:43 lzx-314-desk kernel: ? do_swap_page+0x432/0x590
>> Dec 04 23:47:43 lzx-314-desk kernel: ? poll_select_copy_remaining+0x120/0x120
>> Dec 04 23:47:43 lzx-314-desk kernel: __handle_mm_fault+0x33e/0xa20
>> Dec 04 23:47:43 lzx-314-desk kernel: handle_mm_fault+0x14a/0x1d0
>> Dec 04 23:47:43 lzx-314-desk kernel: __do_page_fault+0x212/0x440
>> Dec 04 23:47:43 lzx-314-desk kernel: page_fault+0x22/0x30
>> Dec 04 23:47:43 lzx-314-desk kernel: RIP:
>> 0010:copy_user_generic_unrolled+0x89/0xc0
>> Dec 04 23:47:43 lzx-314-desk kernel: RSP: 0000:ffffc90000cdbd70 EFLAGS: 00010202
>> Dec 04 23:47:43 lzx-314-desk kernel: RAX: 0000000000000000 RBX:
>> 0000000000000008 RCX: 0000000000000001
>> Dec 04 23:47:43 lzx-314-desk kernel: RDX: 0000000000000000 RSI:
>> ffffc90000cdbdd8 RDI: 00007ff45e7fba80
>> Dec 04 23:47:43 lzx-314-desk kernel: RBP: ffffc90000cdbee8 R08:
>> 0000000000000000 R09: 0000000000000104
>> Dec 04 23:47:43 lzx-314-desk kernel: R10: ffffc90000cdbd78 R11:
>> 0000000000000104 R12: 0000000000000000
>> Dec 04 23:47:43 lzx-314-desk kernel: R13: ffffc90000cdbdc0 R14:
>> 00007ff45e7fba80 R15: ffffc90000cdbdc0
>> Dec 04 23:47:43 lzx-314-desk kernel: ? core_sys_select+0x208/0x2a0
>> Dec 04 23:47:43 lzx-314-desk kernel: ? __handle_mm_fault+0x4fc/0xa20
>> Dec 04 23:47:43 lzx-314-desk kernel: ? ktime_get_ts64+0x44/0xe0
>> Dec 04 23:47:43 lzx-314-desk kernel: SyS_select+0xa6/0xe0
>> Dec 04 23:47:43 lzx-314-desk kernel: entry_SYSCALL_64_fastpath+0x13/0x94
>> Dec 04 23:47:43 lzx-314-desk kernel: RIP: 0033:0x7ff488f05893
>> Dec 04 23:47:43 lzx-314-desk kernel: RSP: 002b:00007ff45e7fb9f0
>> EFLAGS: 00000293 ORIG_RAX: 0000000000000017
>> Dec 04 23:47:43 lzx-314-desk kernel: RAX: ffffffffffffffda RBX:
>> 0000000000000018 RCX: 00007ff488f05893
>> Dec 04 23:47:43 lzx-314-desk kernel: RDX: 0000000000000000 RSI:
>> 00007ff45e7fba80 RDI: 0000000000000019
>> Dec 04 23:47:43 lzx-314-desk kernel: RBP: 00007ff48fc4b0f0 R08:
>> 00007ff45e7fba70 R09: 00007ff4480008c0
>> Dec 04 23:47:43 lzx-314-desk kernel: R10: 0000000000000000 R11:
>> 0000000000000293 R12: 0000000000000000
>> Dec 04 23:47:43 lzx-314-desk kernel: R13: 0000000000000000 R14:
>> 0000000001999670 R15: 00007ff4480008c0
>> Dec 04 23:47:43 lzx-314-desk kernel: Mem-Info:
>> Dec 04 23:47:43 lzx-314-desk kernel: active_anon:0 inactive_anon:0
>> isolated_anon:0
>> active_file:322 inactive_file:461978 isolated_file:352
>> unevictable:0 dirty:136 writeback:0 unstable:0
>> slab_reclaimable:15780 slab_unreclaimable:5246
>> mapped:1 shmem:0 pagetables:1165 bounce:0
>> free:13867 free_pcp:60 free_cma:0
>> ......
>>
>> I tried to fomat the md device to ext4,  then it's fine to backup all
>> the VMs,  And if I use async option for nfs, it works too, so seems
>> like  btrfs is more memory consuming sometimes.
>>
>> I attatched the full logs.
>>
>> Any one hit  similar issue or have any ideas ?
>
> Are you using btrfs qgroups (quota)?
>
> It's known qgroup will take extra memory and may cause OOM if there are
> a lot of extents modified in current transaction.
>
> Thanks,
> Qu
>
>>
>> thanks so much.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
