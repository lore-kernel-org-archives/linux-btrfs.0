Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:41490 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbeHJKOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 06:14:16 -0400
Received: by mail-oi0-f68.google.com with SMTP id k12-v6so14318408oiw.8
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 00:45:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
References: <CAPL5yKfaoujn4gOcejJKwvXHhnuRgFLACKHxxy=bXQz0tE0YMA@mail.gmail.com>
From: Dan Merillat <dan.merillat@gmail.com>
Date: Fri, 10 Aug 2018 03:45:34 -0400
Message-ID: <CAPL5yKcRp=Kw4pdUWa3j5A7YB2ygHQCrtCJv9xnkmd==Dhb04Q@mail.gmail.com>
Subject: Re: Mount stalls indefinitely after enabling quota groups.
To: BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[23084.426006] sysrq: SysRq : Show Blocked State
[23084.426085]   task                        PC stack   pid father
[23084.426332] mount           D    0  4857   4618 0x00000080
[23084.426403] Call Trace:
[23084.426531]  ? __schedule+0x2c3/0x830
[23084.426628]  ? __wake_up_common+0x6f/0x120
[23084.426751]  schedule+0x2d/0x90
[23084.426871]  wait_current_trans+0x98/0xc0
[23084.426953]  ? wait_woken+0x80/0x80
[23084.427058]  start_transaction+0x2e9/0x3e0
[23084.427128]  btrfs_drop_snapshot+0x48c/0x860
[23084.427220]  merge_reloc_roots+0xca/0x210
[23084.427277]  btrfs_recover_relocation+0x290/0x420
[23084.427399]  ? btrfs_cleanup_fs_roots+0x174/0x190
[23084.427533]  open_ctree+0x2158/0x2549
[23084.427592]  ? bdi_register_va.part.2+0x10a/0x1a0
[23084.427652]  btrfs_mount_root+0x678/0x730
[23084.427709]  ? pcpu_next_unpop+0x32/0x40
[23084.427797]  ? pcpu_alloc+0x2f6/0x680
[23084.427884]  ? mount_fs+0x30/0x150
[23084.427939]  ? btrfs_decode_error+0x20/0x20
[23084.427996]  mount_fs+0x30/0x150
[23084.428054]  vfs_kern_mount.part.7+0x4f/0xf0
[23084.428111]  btrfs_mount+0x156/0x8ad
[23084.428167]  ? pcpu_block_update_hint_alloc+0x15e/0x1d0
[23084.428226]  ? pcpu_next_unpop+0x32/0x40
[23084.428282]  ? pcpu_alloc+0x2f6/0x680
[23084.428338]  ? mount_fs+0x30/0x150
[23084.428393]  mount_fs+0x30/0x150
[23084.428450]  vfs_kern_mount.part.7+0x4f/0xf0
[23084.428507]  do_mount+0x5b0/0xc60
[23084.428563]  ksys_mount+0x7b/0xd0
[23084.428618]  __x64_sys_mount+0x1c/0x20
[23084.428676]  do_syscall_64+0x55/0x110
[23084.428734]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[23084.428794] RIP: 0033:0x7efeb90daa1a
[23084.428849] RSP: 002b:00007ffcc8b8fee8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[23084.428925] RAX: ffffffffffffffda RBX: 000055d5bef05420 RCX: 00007efeb90daa1a
[23084.428987] RDX: 000055d5bef05600 RSI: 000055d5bef05ab0 RDI: 000055d5bef05b70
[23084.429048] RBP: 0000000000000000 R08: 000055d5bef08e40 R09: 000000000000003f
[23084.429109] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000055d5bef05b70
[23084.429170] R13: 000055d5bef05600 R14: 0000000000000000 R15: 00000000ffffffff


On Fri, Aug 10, 2018 at 3:40 AM, Dan Merillat <dan.merillat@gmail.com> wrote:
> Kernel 4.17.9, 11tb BTRFS device (md-backed, not btrfs raid)
>
> I was testing something out and enabled quota groups and started getting
> 2-5 minute long pauses where a btrfs-transaction thread spun at 100%.
>
> Post-reboot the mount process spinds at 100% CPU, occasinally yielding
> to a btrfs-transaction thread at 100% CPU.  The switchover is marked
> by a burst of disk activity in btrace.
>
> Btrace shows all disk activity is returning promptly - no hanging submits.
>
> Currently the mount is at 6+ hours.
>
> Suggestions on how to go about debugging this?
