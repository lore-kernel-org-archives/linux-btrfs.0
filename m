Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53399 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaICWCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 18:02:06 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: INFO: task btrfs-transacti:2408 blocked for more than 120 seconds.
Date: Thu, 04 Sep 2014 00:02:03 +0200
Message-ID: <1484398.jrmhBVWBue@merkaba>
In-Reply-To: <54074D1D.1070509@gmx.de>
References: <54074D1D.1070509@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 3. September 2014, 19:17:17 schrieben Sie:
> At a 32 bit stable Gentoo Linux I do have 2 BTRFS file systems :
> 
> $ mount | grep btrfs
> /var/lib/portage.fs on /usr/portage type btrfs (rw,noatime,compress=lzo)
> /var/lib/pkg.fs on /var/db/pkg type btrfs (rw,noatime,compress=lzo)
> 
> holding a lot of small Gentoo-package-Manager-related files. The first is
> exported via NMFS so that my KVM can access that tree too.
> 
> Today I got a hang while upgrading a package at the host and one within the
> KVM at the same time, syslog tells me:

Which kernel is this?

If this is anything less than 3.17-rc3, I suggest you try with that one, or 
wait till the hang fix patches got into stable trees. Chris´s recent pull 
request may have been about these.

Thanks,
Martin

> Sep  3 19:10:57 n22 kernel: INFO: task btrfs-transacti:2408 blocked for more
> than 120 seconds. Sep  3 19:10:57 n22 kernel: Not tainted 3.16.1 #5
> Sep  3 19:10:57 n22 kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message. Sep  3
> 19:10:57 n22 kernel: btrfs-transacti D 00000000     0  2408      2
> 0x00000000 Sep  3 19:10:57 n22 kernel: edb15a34 00000086 c10c7efc 00000000
> 00000001 5197f8f9 00001fa0 c17bf880 Sep  3 19:10:57 n22 kernel: c17bf880
> f3630880 f10167c0 c1099ed3 00000002 00000001 00000000 c10c7efc Sep  3
> 19:10:57 n22 kernel: 118a2543 00000857 ffffffff 00000018 c24d94d3 002180b0
> 0062c84a abf93cc6 Sep  3 19:10:57 n22 kernel: Call Trace:
> Sep  3 19:10:57 n22 kernel: [<c10c7efc>] ? __delayacct_blkio_start+0x1c/0x20
> Sep  3 19:10:57 n22 kernel: [<c1099ed3>] ? ktime_get_ts+0x83/0x180 Sep  3
> 19:10:57 n22 kernel: [<c10c7efc>] ? __delayacct_blkio_start+0x1c/0x20 Sep 
> 3 19:10:57 n22 kernel: [<c10f6ba0>] ? wait_on_page_read+0x50/0x50 Sep  3
> 19:10:57 n22 kernel: [<c14c4bc6>] io_schedule+0x86/0x100
> Sep  3 19:10:57 n22 kernel: [<c10f6bad>] sleep_on_page+0xd/0x20
> Sep  3 19:10:57 n22 kernel: [<c14c4ee1>] __wait_on_bit+0x51/0x80
> Sep  3 19:10:57 n22 kernel: [<c10f6ba0>] ? wait_on_page_read+0x50/0x50
> Sep  3 19:10:57 n22 kernel: [<c10f69f3>] wait_on_page_bit+0x83/0x90
> Sep  3 19:10:57 n22 kernel: [<c107ce10>] ?
> autoremove_wake_function+0x40/0x40 Sep  3 19:10:57 n22 kernel: [<c125869c>]
> read_extent_buffer_pages+0x2dc/0x2f0 Sep  3 19:10:57 n22 kernel:
> [<c1229718>] btree_read_extent_buffer_pages.constprop.50+0xc8/0x140 Sep  3
> 19:10:57 n22 kernel: [<c1228860>] ? free_root_pointers+0x50/0x50 Sep  3
> 19:10:57 n22 kernel: [<c122a6dc>] read_tree_block+0x3c/0x60 Sep  3 19:10:57
> n22 kernel: [<c120ae31>] read_block_for_search.isra.30+0x141/0x390 Sep  3
> 19:10:57 n22 kernel: [<c120cb67>] btrfs_search_slot+0x3a7/0x870 Sep  3
> 19:10:57 n22 kernel: [<c1213a92>] lookup_inline_extent_backref+0x132/0x6e0
> Sep  3 19:10:57 n22 kernel: [<c107222b>] ? update_curr+0xeb/0x1a0
> Sep  3 19:10:57 n22 kernel: [<c107e7be>] ? cpuacct_charge+0x6e/0x90
> Sep  3 19:10:57 n22 kernel: [<c12160cd>] __btrfs_free_extent+0x13d/0xd10
> Sep  3 19:10:57 n22 kernel: [<c14c8652>] ? _raw_spin_unlock+0x22/0x30
> Sep  3 19:10:57 n22 kernel: [<c121b9c7>] ?
> __btrfs_run_delayed_refs+0x117/0x1260 Sep  3 19:10:57 n22 kernel:
> [<c121c187>] __btrfs_run_delayed_refs+0x8d7/0x1260 Sep  3 19:10:57 n22
> kernel: [<c1065849>] ? finish_task_switch+0x79/0x100 Sep  3 19:10:57 n22
> kernel: [<c14c73ad>] ? mutex_unlock+0xd/0x10
> Sep  3 19:10:57 n22 kernel: [<c12209c8>]
> btrfs_run_delayed_refs.part.60+0x58/0x220 Sep  3 19:10:57 n22 kernel:
> [<c124e477>] ? btrfs_run_ordered_operations+0x1b7/0x240 Sep  3 19:10:57 n22
> kernel: [<c1220ba4>] btrfs_run_delayed_refs+0x14/0x30 Sep  3 19:10:57 n22
> kernel: [<c1230f75>] btrfs_commit_transaction+0x45/0xc70 Sep  3 19:10:57
> n22 kernel: [<c1231c1e>] ? start_transaction+0x7e/0x5b0 Sep  3 19:10:57 n22
> kernel: [<c122d3f5>] transaction_kthread+0x195/0x220 Sep  3 19:10:57 n22
> kernel: [<c122d260>] ? btrfs_cleanup_transaction+0x490/0x490 Sep  3
> 19:10:57 n22 kernel: [<c105d896>] kthread+0xa6/0xc0
> Sep  3 19:10:57 n22 kernel: [<c14c8f01>] ret_from_kernel_thread+0x21/0x30
> Sep  3 19:10:57 n22 kernel: [<c105d7f0>] ?
> kthread_create_on_node+0x180/0x180 Sep  3 19:10:57 n22 kernel: 2 locks held
> by btrfs-transacti/2408:
> Sep  3 19:10:57 n22 kernel: #0: 
> (&fs_info->transaction_kthread_mutex){......}, at: [<c122d367>]
> transaction_kthread+0x107/0x220 Sep  3 19:10:57 n22 kernel: #1: 
> (&head_ref->mutex){......}, at: [<c128149f>]
> btrfs_delayed_ref_lock+0x2f/0x1f0
> 
> 
> Just FWIW

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
