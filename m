Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2726C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75CCE2184B
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 13:51:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfAWNvy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:51:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:52880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbfAWNvy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 08:51:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04D69AF6A;
        Wed, 23 Jan 2019 13:51:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8CC36DA6F5; Wed, 23 Jan 2019 14:51:20 +0100 (CET)
Date:   Wed, 23 Jan 2019 14:51:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190123135120.GT2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 11:00:57AM -0500, Josef Bacik wrote:
> qgroups will do the old roots lookup at delayed ref time, which could be
> while walking down the extent root while running a delayed ref.  This
> should be fine, except we specifically lock eb's in the backref walking
> code irrespective of path->skip_locking, which deadlocks the system.
> Fix up the backref code to honor path->skip_locking, nobody will be
> modifying the commit_root when we're searching so it's completely safe
> to do.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

So this explodes at btrfs/007, I had the patch in a separate branch out of
misc-next and for-next and did not notice that, the functional tests passed but
fstests do not.

[   90.693679] kernel BUG at fs/btrfs/locking.c:286!
[   90.694914] invalid opcode: 0000 [#1] PREEMPT SMP
[   90.696152] CPU: 2 PID: 22976 Comm: btrfs Not tainted 4.20.0-rc7-default+ #419
[   90.698100] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
[   90.700893] RIP: 0010:btrfs_assert_tree_read_locked.part.2+0x5/0x10 [btrfs]
[   90.706111] RSP: 0018:ffffa1b046447840 EFLAGS: 00010246
[   90.707035] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   90.707987] RDX: 0000000069fc7000 RSI: 0000000000000002 RDI: ffff91c73784f480
[   90.709962] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[   90.711894] R10: ffff91c73ffc6000 R11: 0000000001a7f1c0 R12: ffff91c723d8dc60
[   90.713543] R13: ffff91c73784f480 R14: 0000000000000001 R15: ffff91c723d8daa8
[   90.715023] FS:  00007fdedfe778c0(0000) GS:ffff91c73d800000(0000) knlGS:0000000000000000
[   90.717170] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   90.718176] CR2: 00007fdedf58ae38 CR3: 0000000073d09000 CR4: 00000000000006e0
[   90.719112] Call Trace:
[   90.720810]  btrfs_set_lock_blocking_rw+0x9d/0xb0 [btrfs]
[   90.722187]  find_parent_nodes+0xaf5/0xf30 [btrfs]
[   90.723102]  ? __find_iref+0xc0/0xc0 [btrfs]
[   90.723798]  iterate_extent_inodes+0xf6/0x320 [btrfs]
[   90.724574]  ? btrfs_get_token_64+0x103/0x120 [btrfs]
[   90.725700]  ? kvm_sched_clock_read+0x5/0x10
[   90.726688]  ? sched_clock+0x5/0x10
[   90.727695]  ? process_extent+0x503/0x1210 [btrfs]
[   90.728899]  process_extent+0x503/0x1210 [btrfs]
[   90.729910]  ? __record_deleted_ref+0x20/0x20 [btrfs]
[   90.731130]  changed_cb+0xb9e/0x1060 [btrfs]
[   90.732105]  send_subvol+0x4a0/0x580 [btrfs]
[   90.733142]  btrfs_ioctl_send+0x7c4/0xb20 [btrfs]
[   90.734188]  ? sched_clock_cpu+0xc/0xc0
[   90.735076]  ? _copy_from_user+0x63/0x90
[   90.736004]  _btrfs_ioctl_send+0xdd/0x110 [btrfs]
[   90.737077]  ? __lock_is_held+0x5a/0xa0
[   90.737962]  btrfs_ioctl+0xcd3/0x2f10 [btrfs]
[   90.738931]  ? __lock_acquire+0x263/0xf10
[   90.740025]  ? lockdep_hardirqs_on+0xe8/0x180
[   90.741082]  ? do_vfs_ioctl+0xa2/0x6d0
[   90.742077]  do_vfs_ioctl+0xa2/0x6d0
[   90.743151]  ? __fget+0x109/0x1e0
[   90.744117]  ksys_ioctl+0x3a/0x70
[   90.744988]  __x64_sys_ioctl+0x16/0x20
[   90.746035]  do_syscall_64+0x54/0x180
[   90.746997]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   90.748090] RIP: 0033:0x7fdedf67daa7
