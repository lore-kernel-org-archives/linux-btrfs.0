Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33782 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab2FZVCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 17:02:02 -0400
Received: by wgbdr13 with SMTP id dr13so316536wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 14:02:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
From: Chester <somethingsome2000@gmail.com>
Date: Tue, 26 Jun 2012 16:01:40 -0500
Message-ID: <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com>
Subject: Re: btrfs volume suddenly becomes read-only
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I rebooted and I was able to mount read-write again. I started a scrub
just in case, and somewhere along the way, the system became readonly
again, and 'btrfs scrub stat /' says scrub was still running, but my
HDD light was not on. The trace looks similar.

[   17.668586] [drm] Initialized radeon 2.15.0 20080528 for
0000:00:01.0 on minor 0
[ 1184.214750] btrfs: run_one_delayed_ref returned -17
[ 1184.214759] ------------[ cut here ]------------
[ 1184.214775] WARNING: at fs/btrfs/super.c:221
__btrfs_abort_transaction+0x40/0x9d()
[ 1184.214782] Hardware name: HP Pavilion dv6 Notebook PC
[ 1184.214787] btrfs: Transaction aborted
[ 1184.214791] Modules linked in: radeon ttm drm_kms_helper drm
i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect psmouse hp_accel
lis3lv02d ehci_hcd xhci_hcd snd_hda_codec_idt snd_hda_codec_hdmi
snd_hda_intel snd_hda_codec r8169 brcmsmac bcma brcmutil cordic
[ 1184.214839] Pid: 1121, comm: btrfs-transacti Not tainted
3.4.0-00091-gcb77fcd #1
[ 1184.214844] Call Trace:
[ 1184.214858]  [<ffffffff8106382f>] warn_slowpath_common+0x7e/0x96
[ 1184.214868]  [<ffffffff810638db>] warn_slowpath_fmt+0x41/0x43
[ 1184.214878]  [<ffffffff8125e626>] __btrfs_abort_transaction+0x40/0x9d
[ 1184.214888]  [<ffffffff8126dd55>] btrfs_run_delayed_refs+0x267/0x34b
[ 1184.214898]  [<ffffffff812697aa>] ? btrfs_put_block_group+0x16/0x63
[ 1184.214908]  [<ffffffff8126e10e>] btrfs_write_dirty_block_groups+0x2d5/0x4c2
[ 1184.214920]  [<ffffffff816775b4>] commit_cowonly_roots+0x100/0x1cc
[ 1184.214930]  [<ffffffff8127bd0b>] btrfs_commit_transaction+0x445/0x8d9
[ 1184.214938]  [<ffffffff8107d7ad>] ? add_wait_queue+0x44/0x44
[ 1184.214946]  [<ffffffff810838c7>] ? should_resched+0x9/0x28
[ 1184.214954]  [<ffffffff8127650c>] transaction_kthread+0x174/0x230
[ 1184.214964]  [<ffffffff8167e868>] ? _raw_spin_unlock_irqrestore+0x15/0x18
[ 1184.214972]  [<ffffffff81276398>] ? try_to_freeze+0x38/0x38
[ 1184.214979]  [<ffffffff8107d0c0>] kthread+0x86/0x8e
[ 1184.214989]  [<ffffffff81685c64>] kernel_thread_helper+0x4/0x10
[ 1184.214997]  [<ffffffff8107d03a>] ? kthread_freezable_should_stop+0x43/0x43
[ 1184.215006]  [<ffffffff81685c60>] ? gs_change+0x13/0x13
[ 1184.215012] ---[ end trace 8032d7cdb4d8dbd8 ]---
[ 1184.215019] BTRFS error (device sda6) in
btrfs_run_delayed_refs:2454: Object already exists
[ 1184.215025] btrfs is forced readonly
