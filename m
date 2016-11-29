Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.ewheeler.net ([66.155.3.69]:33268 "EHLO mail.ewheeler.net"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753048AbcK2R2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 12:28:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.ewheeler.net (Postfix) with ESMTP id 4A399A0414
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 09:28:10 -0800 (PST)
Received: from mail.ewheeler.net ([127.0.0.1])
        by localhost (mail.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id GfvZsBwC1w7P for <linux-btrfs@vger.kernel.org>;
        Tue, 29 Nov 2016 09:28:09 -0800 (PST)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.ewheeler.net (Postfix) with ESMTPSA id CF062A03B0
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Nov 2016 09:28:09 -0800 (PST)
Date: Tue, 29 Nov 2016 09:28:07 -0800 (PST)
From: Eric Wheeler <btrfs@lists.ewheeler.net>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/ctree.c:3179!: btrfs_set_item_key_safe
Message-ID: <alpine.LRH.2.11.1611290926490.26060@mail.ewheeler.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello All,

This was running on an older 4.6.5 machine. Does anyone know if this has 
been fixed in newer kernels?

[340653.975882] ------------[ cut here ]------------
[340653.978481] kernel BUG at fs/btrfs/ctree.c:3179!
[340653.979757] invalid opcode: 0000 [#1] 
[340653.989870] CPU: 0 PID: 12861 Comm: kworker/u97:24 Tainted: G            E   4.6.5 #1
[340653.991390] Hardware name: Dell Inc. PowerEdge T420/03015M, BIOS 2.4.2 01/29/2015
[340653.992952] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
 
[340653.994495] task: ffff88003798c140 ti: ffff880526c74000 task.ti: ffff880526c74000
[340653.996087] RIP: 0010:[<ffffffffa039f1c2>] 
 [<ffffffffa039f1c2>] btrfs_set_item_key_safe+0x172/0x180 [btrfs]
[340653.997762] RSP: 0018:ffff880526c77ad0  EFLAGS: 00010246
[340653.999393] RAX: 0000000000000000 RBX: 0000000000000016 RCX: 0000015906340000
[340654.001038] RDX: 0000000000000000 RSI: ffff880526c77bee RDI: ffff880526c77aef
[340654.002699] RBP: ffff880526c77b30 R08: 0000000000001000 R09: ffff880526c77af0
[340654.004388] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880526c77ade
[340654.006072] R13: ffff880100b53150 R14: ffff880526c77bee R15: ffff8803e7e87298
[340654.007800] FS:  0000000000000000(0000) GS:ffff88041f800000(0000) knlGS:0000000000000000
[340654.009528] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[340654.011272] CR2: ffffffffff600400 CR3: 0000000191b24000 CR4: 00000000000406f0
[340654.012884] Stack:
[340654.014506]  ffff88041c67e000
 0101ffffa03e1d58
 006c000000000000
 0100000159063400
 
[340654.016322]  6c00000000000001
 0000015906340000
 00000000b33ec473
 ffff880100b53150
 
[340654.018173]  0000000000000b3d
 0000000000000000
 0000015906350000
 ffff8803e7e87298
 
[340654.020008] Call Trace:
[340654.021916]  [<ffffffffa03dca36>] __btrfs_drop_extents+0x536/0xdb0 [btrfs]
[340654.023836]  [<ffffffffa03e50f3>] ? set_state_bits+0x43/0xc0 [btrfs]
[340654.025780]  [<ffffffffa03ca250>] insert_reserved_file_extent.constprop.64+0xb0/0x320 [btrfs]
[340654.027725]  [<ffffffffa03d1d1c>] btrfs_finish_ordered_io+0x47c/0x690 [btrfs]
[340654.029707]  [<ffffffffa03d2225>] finish_ordered_fn+0x15/0x20 [btrfs]
[340654.031689]  [<ffffffffa03faaa0>] normal_work_helper+0xc0/0x2c0 [btrfs]
[340654.033669]  [<ffffffffa03fae32>] btrfs_endio_write_helper+0x12/0x20 [btrfs]
[340654.035655]  [<ffffffff810bc812>] process_one_work+0x152/0x400
[340654.037687]  [<ffffffff810bd105>] worker_thread+0x125/0x4b0
[340654.039703]  [<ffffffff810bcfe0>] ? rescuer_thread+0x380/0x380
[340654.041758]  [<ffffffff810c2c78>] kthread+0xd8/0xf0
[340654.043830]  [<ffffffff816ebcc2>] ret_from_fork+0x22/0x40
[340654.045892]  [<ffffffff810c2ba0>] ? kthread_park+0x60/0x60



--
Eric Wheeler
