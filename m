Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linux-ag.de ([62.245.157.206]:37243 "EHLO mail.linux-ag.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753042AbdBCK0A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 05:26:00 -0500
Received: from localhost (mail.linux-ag.de [62.245.157.206])
        by mail.linux-ag.de (Postfix) with ESMTP id 6AE60121A
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Feb 2017 11:16:52 +0100 (CET)
Date: Fri, 3 Feb 2017 11:16:51 +0100
From: "Juergen 'Louis' Fluk" <jfluk@linux-ag.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs_drop_snapshot "IO failure" after RAID controller reset
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <20170203101652.6AE60121A@mail.linux-ag.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

the RAID controller underneath our 32T BTRFS container had a sudden reset,
and after rebooting BTRFS drops to readonly after some list of messages.

I did recovery + btrfs-zero-log + recovery (using a LVM snapshot), yet
the error persists. From "transid verify failed" I understand that journal
and data are not in sync (data is newer). BTRFS tries to drop a snapshot
and fails there - is there a way to ignore it or force it?

RAID controller does not signal new errors so I assume it's not a problem
of accessing some single disk block, but possibly some information was not
written to disk at the time of controller reset.


  mount -o recovery /dev/vg/snap /mnt/backup

Feb 3 08:05:57 zeus kernel: [336619.494618] BTRFS info (device dm-2): enabling auto recovery
Feb 3 08:05:57 zeus kernel: [336619.494625] BTRFS info (device dm-2): disk space caching is enabled
Feb 3 08:09:32 zeus kernel: [336834.568348] BTRFS: checking UUID tree
Feb 3 08:10:44 zeus kernel: [336905.752787] BTRFS info (device dm-2): The free space cache file (814462533632) is invalid. skip it
Feb 3 08:10:44 zeus kernel: [336905.752787]
Feb 3 08:11:26 zeus kernel: [336948.358199] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:11:26 zeus kernel: [336948.397901] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:11:46 zeus kernel: [336968.341996] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:11:46 zeus kernel: [336968.362567] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:11:46 zeus kernel: [336968.406344] BTRFS: error (device dm-2) in btrfs_drop_snapshot:8367: errno=-5 IO failure
Feb 3 08:11:46 zeus kernel: [336968.418816] BTRFS info (device dm-2): forced readonly

  umount /mnt/backup

Feb 3 08:14:13 zeus kernel: [337114.733143] BTRFS warning (device dm-2): page private not zero on page 4049746657280
Feb 3 08:14:13 zeus kernel: [337114.733148] BTRFS warning (device dm-2): page private not zero on page 4049746661376
Feb 3 08:14:13 zeus kernel: [337114.733151] BTRFS warning (device dm-2): page private not zero on page 4049746665472
Feb 3 08:14:13 zeus kernel: [337114.733154] BTRFS warning (device dm-2): page private not zero on page 4049746669568

  btrfs-zero-log /dev/vg/snap # takes about 180s, no messages

  mount -o recovery /dev/vg/snap /mnt/backup

Feb 3 08:17:01 zeus kernel: [337282.701412] BTRFS info (device dm-2): enabling auto recovery
Feb 3 08:17:01 zeus kernel: [337282.701418] BTRFS info (device dm-2): disk space caching is enabled
Feb 3 08:20:30 zeus kernel: [337492.359931] BTRFS: checking UUID tree
Feb 3 08:21:01 zeus kernel: [337523.269214] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:21:01 zeus kernel: [337523.382927] BTRFS (device dm-2): parent transid verify failed on 4052030455808 wanted 451805 found 451973
Feb 3 08:26:06 zeus kernel: [337828.194444] BTRFS (device dm-2): parent transid verify failed on 4052043694080 wanted 451805 found 451973
Feb 3 08:26:06 zeus kernel: [337828.291338] BTRFS (device dm-2): parent transid verify failed on 4052043694080 wanted 451805 found 451973
Feb 3 08:26:11 zeus kernel: [337833.611569] BTRFS (device dm-2): parent transid verify failed on 4050351652864 wanted 451804 found 451973
Feb 3 08:26:12 zeus kernel: [337833.662051] BTRFS (device dm-2): parent transid verify failed on 4050351652864 wanted 451804 found 451973
Feb 3 08:26:15 zeus kernel: [337837.077964] BTRFS (device dm-2): parent transid verify failed on 4052066533376 wanted 451806 found 451974
Feb 3 08:26:15 zeus kernel: [337837.106540] BTRFS (device dm-2): parent transid verify failed on 4052066533376 wanted 451806 found 451974
Feb 3 08:26:20 zeus kernel: [337842.595882] BTRFS (device dm-2): parent transid verify failed on 4050367676416 wanted 451804 found 451973
Feb 3 08:26:21 zeus kernel: [337842.686296] BTRFS (device dm-2): parent transid verify failed on 4050367676416 wanted 451804 found 451973
Feb 3 08:26:24 zeus kernel: [337845.666495] BTRFS (device dm-2): parent transid verify failed on 4051971883008 wanted 451804 found 451973
Feb 3 08:26:24 zeus kernel: [337845.728624] BTRFS (device dm-2): parent transid verify failed on 4051971883008 wanted 451804 found 451973
Feb 3 08:26:27 zeus kernel: [337848.780978] BTRFS (device dm-2): parent transid verify failed on 4051397328896 wanted 451804 found 451973
Feb 3 08:26:27 zeus kernel: [337848.827572] BTRFS (device dm-2): parent transid verify failed on 4051397328896 wanted 451804 found 451973
Feb 3 08:26:27 zeus kernel: [337849.116946] BTRFS (device dm-2): parent transid verify failed on 4052072022016 wanted 451806 found 451974
Feb 3 08:26:27 zeus kernel: [337849.164664] BTRFS (device dm-2): parent transid verify failed on 4052072022016 wanted 451806 found 451974
Feb 3 08:26:29 zeus kernel: [337850.848836] BTRFS (device dm-2): parent transid verify failed on 4052133838848 wanted 451807 found 451974
Feb 3 08:26:29 zeus kernel: [337850.904191] BTRFS (device dm-2): parent transid verify failed on 4052133838848 wanted 451807 found 451974
Feb 3 08:56:43 zeus kernel: [339665.075509] BTRFS (device dm-2): parent transid verify failed on 4052075757568 wanted 451806 found 451974
Feb 3 08:56:43 zeus kernel: [339665.169955] BTRFS (device dm-2): parent transid verify failed on 4052075757568 wanted 451806 found 451974
Feb 3 08:56:43 zeus kernel: [339665.169960] ------------[ cut here ]------------
Feb 3 08:56:43 zeus kernel: [339665.170003] WARNING: CPU: 2 PID: 22338 at /build/linux-lts-vivid-YU4K27/linux-lts-vivid-3.19.0/fs/btrfs/super.c:260 __btrfs_abort_transaction+0x54/0x130 [btrfs]()
Feb 3 08:56:43 zeus kernel: [339665.170005] BTRFS: Transaction aborted (error -5)
Feb 3 08:56:43 zeus kernel: [339665.170006] Modules linked in: rpcsec_gss_krb5 nfsv4 dm_snapshot dm_bufio p4_clockmod speedstep_lib dm_crypt nfsd auth_rpcgss nfs_acl nfs lockd grace sunrpc fscache coretemp gpio_ich kvm ppdev i5000_edac edac_core dm_multipath serio_raw scsi_dh lpc_ich i5k_amb ioatdma 8250_fintek shpchp parport_pc parport dca mac_hid e100 via_rhine 3c59x 8139too mii btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid0 multipath linear raid1 hid_generic e1000e i2c_algo_bit ttm ptp drm_kms_helper usbhid drm pata_acpi hid arcmsr pps_core e1000 floppy [last unloaded: sata_promise]
Feb 3 08:56:43 zeus kernel: [339665.170055] CPU: 2 PID: 22338 Comm: btrfs-transacti Tainted: G W 3.19.0-79-generic #87~14.04.1-Ubuntu
Feb 3 08:56:43 zeus kernel: [339665.170057] Hardware name: Supermicro X7DB8/X7DB8, BIOS 6.00 08/13/2007
Feb 3 08:56:43 zeus kernel: [339665.170059] 0000000000000000 ffff880055d27958 ffffffff817b63c3 ffff880055d279a8
Feb 3 08:56:43 zeus kernel: [339665.170063] ffffffffc0380f40 ffff880055d27998 ffffffff81075d6a 0000000000000000
Feb 3 08:56:43 zeus kernel: [339665.170066] ffff88020d45ad10 ffff88020a1bc000 00000000fffffffb ffffffffc037d070
Feb 3 08:56:43 zeus kernel: [339665.170069] Call Trace:
Feb 3 08:56:43 zeus kernel: [339665.170077] [<ffffffff817b63c3>] dump_stack+0x63/0x81
Feb 3 08:56:43 zeus kernel: [339665.170083] [<ffffffff81075d6a>] warn_slowpath_common+0x8a/0xc0
Feb 3 08:56:43 zeus kernel: [339665.170086] [<ffffffff81075de6>] warn_slowpath_fmt+0x46/0x50
Feb 3 08:56:43 zeus kernel: [339665.170101] [<ffffffffc02e2537>] ? update_block_group.isra.61+0xd7/0x310 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170115] [<ffffffffc02cfec4>] __btrfs_abort_transaction+0x54/0x130 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170130] [<ffffffffc02e2a63>] __btrfs_free_extent+0x2f3/0xbf0 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170149] [<ffffffffc0348e15>] ? find_ref_head+0x65/0x90 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170165] [<ffffffffc02e85e3>] __btrfs_run_delayed_refs+0x9b3/0x1270 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170183] [<ffffffffc03165a0>] ? btrfs_set_token_32+0x60/0xf0 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170200] [<ffffffffc02ed013>] btrfs_run_delayed_refs.part.66+0x73/0x270 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170216] [<ffffffffc02ed75d>] btrfs_write_dirty_block_groups+0x48d/0x6e0 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170234] [<ffffffffc0375bf6>] commit_cowonly_roots+0x17b/0x230 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170251] [<ffffffffc02fe48c>] btrfs_commit_transaction+0x4dc/0xa50 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170255] [<ffffffff810b63f0>] ? prepare_to_wait_event+0x110/0x110
Feb 3 08:56:43 zeus kernel: [339665.170272] [<ffffffffc02f9cf5>] transaction_kthread+0x1b5/0x240 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170289] [<ffffffffc02f9b40>] ? btrfs_cleanup_transaction+0x580/0x580 [btrfs]
Feb 3 08:56:43 zeus kernel: [339665.170294] [<ffffffff81094bc9>] kthread+0xc9/0xe0
Feb 3 08:56:43 zeus kernel: [339665.170297] [<ffffffff81094b00>] ? kthread_create_on_node+0x1c0/0x1c0
Feb 3 08:56:43 zeus kernel: [339665.170301] [<ffffffff817bde18>] ret_from_fork+0x58/0x90
Feb 3 08:56:43 zeus kernel: [339665.170304] [<ffffffff81094b00>] ? kthread_create_on_node+0x1c0/0x1c0
Feb 3 08:56:43 zeus kernel: [339665.170306] ---[ end trace 8850f26850fef130 ]---
Feb 3 08:56:43 zeus kernel: [339665.170315] BTRFS: error (device dm-2) in __btrfs_free_extent:5990: errno=-5 IO failure
Feb 3 08:56:43 zeus kernel: [339665.170330] BTRFS warning (device dm-2): btrfs_uuid_scan_kthread failed -5
Feb 3 08:56:43 zeus kernel: [339665.170333] BTRFS: error (device dm-2) in btrfs_drop_snapshot:8367: errno=-5 IO failure
Feb 3 08:56:43 zeus kernel: [339665.170335] BTRFS info (device dm-2): forced readonly
Feb 3 08:56:43 zeus kernel: [339665.194784] BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2792: errno=-5 IO failure
Feb 3 08:56:46 zeus kernel: [339668.601034] BTRFS warning (device dm-2): Skipping commit of aborted transaction.
Feb 3 08:56:46 zeus kernel: [339668.601043] BTRFS: error (device dm-2) in cleanup_transaction:1670: errno=-5 IO failure


The server is running kernel 3.19.0-79-generic (ubuntu 14.04), btrfs-tools 3.12-1ubuntu0.1.
Does it make sense to use newer kernel and/or tools to recover?

Thanx for any hint or advise :)

louis
-- 
Jürgen 'Louis' Fluk
Linux Information Systems AG
Thomas-Dehler-Str. 9, 81737 München

jfluk@linux-ag.com, http://www.linux-ag.com
----------------------------------------------------------
Sitz der Gesellschaft: Thomas-Dehler-Str. 9, 81737 München
Amtsgericht München: HRB 128 019
Vorstand: Rudolf Strobl
Aufsichtsrat: Michael Tarabochia (Vorsitzender)

*** Die bestere IT für den Mittelstand ***
