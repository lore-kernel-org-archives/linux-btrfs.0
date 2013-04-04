Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759627Ab3DDMa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 08:30:58 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 1C2A0A5077
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 14:30:57 +0200 (CEST)
Date: Thu, 4 Apr 2013 14:30:56 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: [bug] xfstests/091 failure on 3.8-btrfs-next
Message-ID: <20130404123056.GE18365@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

default mkfs, mount with noatime, top commit 5710a6f8bb040fd034217c
(current next master).

091 crashes reproducibly after a few seconds with:

[  104.492115] ------------[ cut here ]------------
[  104.496025] kernel BUG at fs/btrfs/extent_io.c:1798!
[  104.496025] invalid opcode: 0000 [#1] SMP
[  104.496025] Modules linked in: aoe dm_crypt loop btrfs
[  104.496025] CPU 1
[  104.496025] Pid: 3675, comm: fsx Not tainted 3.8.0-default+ #286 Intel Corporation Santa Rosa platform/Matanzas
[  104.496025] RIP: 0010:[<ffffffffa0052987>]  [<ffffffffa0052987>] cache_csums+0x117/0x150 [btrfs]
[  104.496025] RSP: 0000:ffff8800764057e8  EFLAGS: 00010206
[  104.496025] RAX: ffff880079b2f3e8 RBX: 0000000000032000 RCX: 0000000000035000
[  104.496025] RDX: 000000000003b000 RSI: ffff880079b73410 RDI: ffff880079b25330
[  104.496025] RBP: ffff880076405828 R08: 0000000000000000 R09: 0000000000000001
[  104.496025] R10: ffff88007647c5c0 R11: ffffff51f03b83fc R12: ffff880079b25320
[  104.496025] R13: ffff8800764058b4 R14: 0000000000000003 R15: 0000000000001000
[  104.496025] FS:  00007fd0f5a21700(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
[  104.496025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  104.496025] CR2: 00007fd0f5915000 CR3: 00000000778ad000 CR4: 00000000000007e0
[  104.496025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  104.496025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  104.496025] Process fsx (pid: 3675, threadinfo ffff880076404000, task ffff88007647c5c0)
[  104.496025] Stack:
[  104.496025]  0000100077ad0000 ffff880079b733f8 0000000000000000 0000000000000000
[  104.496025]  ffff8800764058a8 0000000000000006 0000000000000006 ffff880079ad19c8
[  104.496025]  ffff880076405938 ffffffffa002814f ffff880079b733c8 ffff880079b73300
[  104.496025] Call Trace:
[  104.496025]  [<ffffffffa002814f>] __btrfs_lookup_bio_sums+0x40f/0x550 [btrfs]
[  104.496025]  [<ffffffff811531b3>] ? kmem_cache_alloc_trace+0x223/0x270
[  104.496025]  [<ffffffffa0028376>] btrfs_lookup_bio_sums+0x16/0x20 [btrfs]
[  104.496025]  [<ffffffffa0039435>] btrfs_submit_bio_hook+0x145/0x1d0 [btrfs]
[  104.496025]  [<ffffffffa003a8b0>] ? can_nocow_odirect+0x2a0/0x2a0 [btrfs]
[  104.496025]  [<ffffffffa004f850>] submit_one_bio+0x70/0xa0 [btrfs]
[  104.496025]  [<ffffffffa00557d9>] extent_readpages+0x1a9/0x1d0 [btrfs]
[  104.496025]  [<ffffffffa00381bf>] btrfs_readpages+0x1f/0x30 [btrfs]
[  104.496025]  [<ffffffff8111b18d>] __do_page_cache_readahead+0x24d/0x310
[  104.496025]  [<ffffffff8111b017>] ? __do_page_cache_readahead+0xd7/0x310
[  104.496025]  [<ffffffff8111b381>] ra_submit+0x21/0x30
[  104.496025]  [<ffffffff81111665>] filemap_fault+0x255/0x440
[  104.496025]  [<ffffffff81087d1f>] ? local_clock+0x6f/0x80
[  104.496025]  [<ffffffff811347cd>] __do_fault+0x6d/0x4b0
[  104.496025]  [<ffffffff810aa535>] ? __lock_acquire+0x355/0x1f20
[  104.496025]  [<ffffffff811375b0>] handle_pte_fault+0x90/0x8d0
[  104.496025]  [<ffffffff810ad3cd>] ? trace_hardirqs_on+0xd/0x10
[  104.496025]  [<ffffffff8195e18c>] ? __do_page_fault+0x15c/0x590
[  104.496025]  [<ffffffff811392d3>] handle_mm_fault+0x233/0x330
[  104.496025]  [<ffffffff81087d1f>] ? local_clock+0x6f/0x80
[  104.496025]  [<ffffffff8195e20f>] __do_page_fault+0x1df/0x590
[  104.496025]  [<ffffffff8112b4f8>] ? vm_mmap_pgoff+0x78/0xa0
[  104.496025]  [<ffffffff8195a906>] ? error_sti+0x5/0x6
[  104.496025]  [<ffffffff8139ae0d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  104.496025]  [<ffffffff8195e5ce>] do_page_fault+0xe/0x10
[  104.496025]  [<ffffffff8195a6b8>] page_fault+0x28/0x30
[  104.496025] Code: 75 2b 48 8b 7d c8 e8 39 71 90 e1 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f c9 c3 66 2e 0f 1f 84 00 00 00 00 00 48 85 c0 75 94 eb 84 <0f> 0b 48 85 c0 0f 1f 40 00 74 28 49 8b 54 24 08 48 8b 08 48 83
[  104.496025] RIP  [<ffffffffa0052987>] cache_csums+0x117/0x150 [btrfs]
[  104.496025]  RSP <ffff8800764057e8>
[  104.890744] ---[ end trace b748241bafc18c69 ]---

xfstests output:

091 84s ...     [14:23:42] [14:24:13] [failed, exit status 1] - output mismatch (see 091.out.bad)
    --- 091.out 2013-03-28 19:10:35.000000000 +0100
    +++ 091.out.bad     2013-04-04 14:24:14.000000000 +0200
    @@ -5,3 +5,41 @@
     fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
     fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    +./091: line 46:  3675 Segmentation fault      $here/ltp/fsx $args $TEST_DIR/junk >> $seq.full 2>&1
    +fsx -N 10000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x7a120
    +All operations completed A-OK!
    +fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x79cbf
    +fallocating to largest ever: 0x7a120
    +All operations completed A-OK!
    +fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x7a120
    +All operations completed A-OK!
    +fsx -N 10000 -o 8192 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x79cbf
    +fallocating to largest ever: 0x7a120
    +All operations completed A-OK!
    +fsx -N 10000 -o 32768 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -R -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x7a120
    +All operations completed A-OK!
    +fsx -N 10000 -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z -W
    +mapped writes DISABLED
    +truncating to largest ever: 0x12a00
    +truncating to largest ever: 0x75400
    +fallocating to largest ever: 0x7a120

david
