Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34796 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdGMSRS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jul 2017 14:17:18 -0400
Received: by mail-wm0-f67.google.com with SMTP id p204so6680577wmg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Jul 2017 11:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170713011056.GW30689@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
 <20170711164812.sj64s3nc2oe3ai3n@merlins.org> <20170713011056.GW30689@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Jul 2017 12:17:16 -0600
Message-ID: <CAJCQCtSojaaS7=7dskDR3k4TwyE-qNGXFytLTyRHNXhzxyqDDg@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 7:10 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, Jul 11, 2017 at 09:48:12AM -0700, Marc MERLIN wrote:
>> On Tue, Jul 11, 2017 at 10:00:40AM -0600, Chris Murphy wrote:
>> > > ---[ end trace feb4b95c83ac065f ]---
>> > > BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
>> > > BTRFS info (device dm-2): forced readonly
>> >
>> > You've already had this same traceback, not sure whether it's the same
>> > file system or not, but it was 4.7.2 kernel.
>>
>> You have better memory than me. I'll admit that I'm kind of overwhelmed
>> by all the time I'm currently spending/wasting on btrfs recovery and
>> that came almost out of nowwhere and hit me in 3 different places :-/
>
> Ok, I'm on 4.9.36 and same problem :(
>
> This is on an otherwise ok working filesystem that comes back clean
> on btrfs check (although I haven't done lowmem but last time I tried lowmem it
> reported problems that apparently weren't really problems)
>
> Dear devs, what does this error mean exactly and what should I do about it besides
> ignoring it and remounting my FS read-write?
> On the plus side thanks for both
> 1) showing which device the error is on
> 2) not crashing the system :)
>
> WARNING: CPU: 6 PID: 3730 at fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0xbd/0x1be
> BTRFS: Transaction aborted (error -17)
> CPU: 0 PID: 3730 Comm: btrfs-cleaner Tainted: G     U  W       4.9.36-amd64-preempt-sysrq-20170
>
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
>  ffffb55c679bfc88 ffffffff8239b00b ffffb55c679bfcd8 0000000000000000
>  ffffb55c679bfcc8 ffffffff82066769 00000b97679bfd48 ffffa07f61a5eaa0
>  ffffa086f217c800 00000000ffffffef ffffa086ad8b5a90 00000000000003a0
> Call Trace:
>  [<ffffffff8239b00b>] dump_stack+0x61/0x7d
>  [<ffffffff82066769>] __warn+0xc2/0xdd
>  [<ffffffff820667de>] warn_slowpath_fmt+0x5a/0x76
>  [<ffffffff8228dd5f>] btrfs_run_delayed_refs+0xbd/0x1be
>  [<ffffffff8228b358>] ? walk_up_tree+0x87/0x10f
>  [<ffffffff8229fd8f>] btrfs_should_end_transaction+0x54/0x5d
>  [<ffffffff8228c8b5>] btrfs_drop_snapshot+0x380/0x65c
>  [<ffffffff822edf7c>] ? btrfs_kill_all_delayed_nodes+0x5f/0xd7
>  [<ffffffff826ecf8a>] ? _raw_spin_lock+0x15/0x17
>  [<ffffffff82292130>] ? btrfs_delete_unused_bgs+0x326/0x369
>  [<ffffffff822a0e29>] btrfs_clean_one_deleted_snapshot+0xce/0xdc
>  [<ffffffff82298c1e>] cleaner_kthread+0xaf/0x17c
>  [<ffffffff82298b6f>] ? btrfs_need_cleaner_sleep.isra.25+0x2c/0x2c
>  [<ffffffff82081e94>] kthread+0xd1/0xd9
>  [<ffffffff82081dc3>] ? init_completion+0x24/0x24
>  [<ffffffff82003add>] ? do_fast_syscall_32+0xb7/0xfe
>  [<ffffffff826ed4b5>] ret_from_fork+0x25/0x30
> ---[ end trace 59fd1c9a379f73bc ]---
> BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2967: errno=-17 Object already exists
> BTRFS info (device dm-2): forced readonly


Well I'd say it's a bug, but that's not a revelation. Is there a
snapshot being deleted in the approximate time frame for this? I see a
snapshot is being cleaned up and chunks being removed. So I wonder if
this can be avoided or intentionally triggered by manipulating
snapshot deletion coinciding with the workload? Maybe it's a race, and
that's why it hits EEXIST, and if so then it's just getting confused
and needs to start from scratch - if true then it's OK to just umount
and mount (rw) again and continue on.

There are some changes in the code between 4.9.36 and 4.12.1 (not sure
when the change was introduced, or if it alters whether you hit this
bug)

btrfs/extent.c
@@ -2962,7 +2966,7 @@ again:
delayed_refs->run_delayed_start = find_middle(&delayed_refs->root);
#endif
trans->can_flush_pending_bgs = false;
- ret = __btrfs_run_delayed_refs(trans, root, count);
+ ret = __btrfs_run_delayed_refs(trans, fs_info, count);
if (ret < 0) {
btrfs_abort_transaction(trans, ret);
return ret;

Another thing I'm not certain of is if the dm-2 reference is just how
it's referring to the file system, or if it's to be taken literally as
an issue with this device. My understanding of the code is really
weak, but I think this whole trace is within Btrfs logical block
handling, in which case it wouldn't know of a problem with a
particular device. It knows that it's in the weeds, but has no idea
what golf course it's on.



-- 
Chris Murphy
