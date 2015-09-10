Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33017 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbbIJUAF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 16:00:05 -0400
Received: by qkdw123 with SMTP id w123so23353016qkd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 13:00:04 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Sep 2015 23:00:04 +0300
Message-ID: <CAOE4rSyb-Ly8aQsECTiQC6hpuUJN02Gb5Yzom_M53GTbLPLSoQ@mail.gmail.com>
Subject: kernel WARNING at fs/btrfs/transaction.c:1710 (v4.2.0)
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing scrub got this warning on v4.2.0

kernel: BTRFS: bdev /dev/sdd errs: wr 13360, rd 21021210, flush 1,
corrupt 0, gen 744
kernel: BTRFS: error (device sdc) in write_all_supers:3548: errno=-5
IO failure (errors while submitting device barriers.)
kernel: BTRFS info (device sdc): forced readonly
kernel: BTRFS warning (device sdc): Skipping commit of aborted transaction.
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 5 PID: 1642 at
/mnt/Linux/linux/fs/btrfs/transaction.c:1710
cleanup_transaction+0x92/0x2f0 [btrfs]()
kernel: BTRFS: Transaction aborted (error -5)
kernel: Modules linked in: nf_conntrack_netbios_ns
nf_conntrack_broadcast xt_tcpudp ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat
ebtable_filter ebtable_broute bridge stp llc ebtables nvidia(O)
ip6table_nat nf_conntrack_ipv6
kernel:  glue_helper snd_hda_codec k10temp fam15h_power serio_raw
tveeprom ablk_helper cryptd edac_core pcspkr edac_mce_amd snd_hda_core
rc_core videobuf2_dma_sg snd_hwdep r8169 videobuf2_memops snd_pcm mii
videobuf2_core v4l2_common videodev snd_timer media snd evdev so
kernel: CPU: 5 PID: 1642 Comm: btrfs-transacti Tainted: G           O
  4.2.0-ARCH-dirty #1
kernel: Hardware name: Gigabyte Technology Co., Ltd.
GA-990FXA-UD3/GA-990FXA-UD3, BIOS FFe 11/08/2013
kernel:  0000000000000000 000000004927b20e ffff8801f07ebc68 ffffffff81566f6a
kernel:  0000000000000000 ffff8801f07ebcc0 ffff8801f07ebca8 ffffffff810737a6
kernel:  0000000000000246 ffff8800c886c2f0 ffff88021863f800 ffff88009a8bada8
kernel: Call Trace:
kernel:  [<ffffffff81566f6a>] dump_stack+0x4c/0x6e
kernel:  [<ffffffff810737a6>] warn_slowpath_common+0x86/0xc0
kernel:  [<ffffffff81073835>] warn_slowpath_fmt+0x55/0x70
kernel:  [<ffffffffa054bc02>] cleanup_transaction+0x92/0x2f0 [btrfs]
kernel:  [<ffffffff810b4940>] ? wake_atomic_t_function+0x60/0x60
kernel:  [<ffffffffa054d016>] btrfs_commit_transaction+0x9a6/0xca0 [btrfs]
kernel:  [<ffffffffa0547e13>] transaction_kthread+0x1c3/0x230 [btrfs]
kernel:  [<ffffffffa0547c50>] ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
kernel:  [<ffffffff81091478>] kthread+0xd8/0xf0
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel:  [<ffffffff8156c8df>] ret_from_fork+0x3f/0x70
kernel:  [<ffffffff810913a0>] ? kthread_worker_fn+0x170/0x170
kernel: ---[ end trace c65cc22a6933c2fc ]---
kernel: BTRFS: error (device sdc) in cleanup_transaction:1710:
errno=-5 IO failure
kernel: BTRFS info (device sdc): delayed_refs has NO entry


fs/btrfs/transaction.c

static void cleanup_transaction(struct btrfs_trans_handle *trans,
struct btrfs_root *root, int err)
...
1710:        WARN_ON(trans->use_count > 1);
