Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33451 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdGMBK7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 21:10:59 -0400
Date: Wed, 12 Jul 2017 18:10:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
Message-ID: <20170713011056.GW30689@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org> <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com> <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 11, 2017 at 09:48:12AM -0700, Marc MERLIN wrote:
> On Tue, Jul 11, 2017 at 10:00:40AM -0600, Chris Murphy wrote:
> > > ---[ end trace feb4b95c83ac065f ]---
> > > BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists
> > > BTRFS info (device dm-2): forced readonly
> >
> > You've already had this same traceback, not sure whether it's the same
> > file system or not, but it was 4.7.2 kernel.
>
> You have better memory than me. I'll admit that I'm kind of overwhelmed
> by all the time I'm currently spending/wasting on btrfs recovery and
> that came almost out of nowwhere and hit me in 3 different places :-/

Ok, I'm on 4.9.36 and same problem :(

This is on an otherwise ok working filesystem that comes back clean 
on btrfs check (although I haven't done lowmem but last time I tried lowmem it
reported problems that apparently weren't really problems)

Dear devs, what does this error mean exactly and what should I do about it besides
ignoring it and remounting my FS read-write?
On the plus side thanks for both
1) showing which device the error is on
2) not crashing the system :)

WARNING: CPU: 6 PID: 3730 at fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0xbd/0x1be
BTRFS: Transaction aborted (error -17)
CPU: 0 PID: 3730 Comm: btrfs-cleaner Tainted: G     U  W       4.9.36-amd64-preempt-sysrq-20170

Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013
 ffffb55c679bfc88 ffffffff8239b00b ffffb55c679bfcd8 0000000000000000
 ffffb55c679bfcc8 ffffffff82066769 00000b97679bfd48 ffffa07f61a5eaa0
 ffffa086f217c800 00000000ffffffef ffffa086ad8b5a90 00000000000003a0
Call Trace:
 [<ffffffff8239b00b>] dump_stack+0x61/0x7d
 [<ffffffff82066769>] __warn+0xc2/0xdd
 [<ffffffff820667de>] warn_slowpath_fmt+0x5a/0x76
 [<ffffffff8228dd5f>] btrfs_run_delayed_refs+0xbd/0x1be
 [<ffffffff8228b358>] ? walk_up_tree+0x87/0x10f
 [<ffffffff8229fd8f>] btrfs_should_end_transaction+0x54/0x5d
 [<ffffffff8228c8b5>] btrfs_drop_snapshot+0x380/0x65c
 [<ffffffff822edf7c>] ? btrfs_kill_all_delayed_nodes+0x5f/0xd7
 [<ffffffff826ecf8a>] ? _raw_spin_lock+0x15/0x17
 [<ffffffff82292130>] ? btrfs_delete_unused_bgs+0x326/0x369
 [<ffffffff822a0e29>] btrfs_clean_one_deleted_snapshot+0xce/0xdc
 [<ffffffff82298c1e>] cleaner_kthread+0xaf/0x17c
 [<ffffffff82298b6f>] ? btrfs_need_cleaner_sleep.isra.25+0x2c/0x2c
 [<ffffffff82081e94>] kthread+0xd1/0xd9
 [<ffffffff82081dc3>] ? init_completion+0x24/0x24
 [<ffffffff82003add>] ? do_fast_syscall_32+0xb7/0xfe
 [<ffffffff826ed4b5>] ret_from_fork+0x25/0x30
---[ end trace 59fd1c9a379f73bc ]---
BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2967: errno=-17 Object already exists
BTRFS info (device dm-2): forced readonly
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/
