Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:35763 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcDGBNF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 21:13:05 -0400
Date: Thu, 7 Apr 2016 10:03:53 +0900
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: btrfs BUGs
Message-ID: <20160407010353.GN11600@logic.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Norbert Preining <preining@logic.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

(please Cc)

since 4.6.0-rc I see regular BUG in btrfs_destroy_inode:

Variant 1:
[47093.775175] ------------[ cut here ]------------
[47093.775187] WARNING: CPU: 3 PID: 19909 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0xad/0x224
[47093.775189] Modules linked in: hmac drbg ansi_cprng ctr ccm uas usbhid acpi_call(O) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc x86_pkg_temp_thermal intel_powerclamp kvm irqbypass crc32c_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iwlmvm mac80211 iwlwifi cfg80211 acpi_als kfifo_buf industrialio sony_laptop ipv6 autofs4
[47093.775226] CPU: 3 PID: 19909 Comm: aptitude Tainted: G        W  O    4.6.0-rc2 #161
[47093.775229] Hardware name: Sony Corporation SVP1322A1J/VAIO, BIOS R2092V7 04/24/2015
[47093.775231]  0000000000000000 ffff8800209afd10 ffffffff8129d414 0000000000000000
[47093.775236]  0000000000000000 ffff8800209afd50 ffffffff8104233d 0000242d209afcc8
[47093.775241]  ffff88003b7605c0 ffff88003b760640 ffff8802153f2000 ffffffff818367a0
[47093.775245] Call Trace:
[47093.775251]  [<ffffffff8129d414>] dump_stack+0x4d/0x63
[47093.775257]  [<ffffffff8104233d>] __warn+0xb8/0xd3
[47093.775261]  [<ffffffff81042405>] warn_slowpath_null+0x18/0x1a
[47093.775265]  [<ffffffff812041d4>] btrfs_destroy_inode+0xad/0x224
[47093.775270]  [<ffffffff81122bb0>] destroy_inode+0x38/0x50
[47093.775273]  [<ffffffff81122d2e>] evict+0x166/0x16d
[47093.775277]  [<ffffffff81123641>] iput+0x160/0x169
[47093.775280]  [<ffffffff8111fb94>] __dentry_kill+0xee/0x157
[47093.775284]  [<ffffffff8111fda7>] dput+0x1aa/0x1cf
[47093.775288]  [<ffffffff8111b435>] SYSC_renameat2+0x304/0x3c9
[47093.775293]  [<ffffffff8111b8d8>] SyS_rename+0x19/0x1b
[47093.775299]  [<ffffffff816729df>] entry_SYSCALL_64_fastpath+0x17/0x93
[47093.775302] ---[ end trace f6f5069f352abf67 ]---


Variant 2:
[47103.281321] ------------[ cut here ]------------
[47103.281329] WARNING: CPU: 2 PID: 19909 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0xad/0x224
[47103.281330] Modules linked in: hmac drbg ansi_cprng ctr ccm uas usbhid acpi_call(O) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc x86_pkg_temp_thermal intel_powerclamp kvm irqbypass crc32c_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iwlmvm mac80211 iwlwifi cfg80211 acpi_als kfifo_buf industrialio sony_laptop ipv6 autofs4
[47103.281349] CPU: 2 PID: 19909 Comm: aptitude Tainted: G        W  O    4.6.0-rc2 #161
[47103.281350] Hardware name: Sony Corporation SVP1322A1J/VAIO, BIOS R2092V7 04/24/2015
[47103.281352]  0000000000000000 ffff8800209afdc8 ffffffff8129d414 0000000000000000
[47103.281354]  0000000000000000 ffff8800209afe08 ffffffff8104233d 0000242d209afd80
[47103.281356]  ffff8800262e0db0 ffff8800262e0e30 ffff8802153f2000 ffffffff818367a0
[47103.281358] Call Trace:
[47103.281362]  [<ffffffff8129d414>] dump_stack+0x4d/0x63
[47103.281365]  [<ffffffff8104233d>] __warn+0xb8/0xd3
[47103.281366]  [<ffffffff81042405>] warn_slowpath_null+0x18/0x1a
[47103.281368]  [<ffffffff812041d4>] btrfs_destroy_inode+0xad/0x224
[47103.281371]  [<ffffffff81122bb0>] destroy_inode+0x38/0x50
[47103.281372]  [<ffffffff81122d2e>] evict+0x166/0x16d
[47103.281374]  [<ffffffff81123641>] iput+0x160/0x169
[47103.281377]  [<ffffffff8111b003>] do_unlinkat+0x116/0x1a6
[47103.281379]  [<ffffffff8111b860>] SyS_unlink+0x11/0x13
[47103.281382]  [<ffffffff816729df>] entry_SYSCALL_64_fastpath+0x17/0x93
[47103.281384] ---[ end trace f6f5069f352abf68 ]---


Variant 3
[47201.848251] ------------[ cut here ]------------
[47201.848258] WARNING: CPU: 1 PID: 19909 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0xad/0x224
[47201.848259] Modules linked in: hmac drbg ansi_cprng ctr ccm uas usbhid acpi_call(O) vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc x86_pkg_temp_thermal intel_powerclamp kvm irqbypass crc32c_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd iwlmvm mac80211 iwlwifi cfg80211 acpi_als kfifo_buf industrialio sony_laptop ipv6 autofs4
[47201.848277] CPU: 1 PID: 19909 Comm: aptitude Tainted: G        W  O    4.6.0-rc2 #161
[47201.848278] Hardware name: Sony Corporation SVP1322A1J/VAIO, BIOS R2092V7 04/24/2015
[47201.848279]  0000000000000000 ffff8800209afd28 ffffffff8129d414 0000000000000000
[47201.848281]  0000000000000000 ffff8800209afd68 ffffffff8104233d 0000242d209afce0
[47201.848283]  ffff880132c631c8 ffff880132c63248 ffff8802153f2000 ffffffff818367a0
[47201.848284] Call Trace:
[47201.848288]  [<ffffffff8129d414>] dump_stack+0x4d/0x63
[47201.848291]  [<ffffffff8104233d>] __warn+0xb8/0xd3
[47201.848292]  [<ffffffff81042405>] warn_slowpath_null+0x18/0x1a
[47201.848294]  [<ffffffff812041d4>] btrfs_destroy_inode+0xad/0x224
[47201.848296]  [<ffffffff81122bb0>] destroy_inode+0x38/0x50
[47201.848298]  [<ffffffff81122d2e>] evict+0x166/0x16d
[47201.848299]  [<ffffffff81123641>] iput+0x160/0x169
[47201.848301]  [<ffffffff8111fb94>] __dentry_kill+0xee/0x157
[47201.848302]  [<ffffffff8111fda7>] dput+0x1aa/0x1cf
[47201.848304]  [<ffffffff8110ffb8>] __fput+0x15f/0x173
[47201.848306]  [<ffffffff8110fff8>] ____fput+0x9/0xb
[47201.848307]  [<ffffffff810573d6>] task_work_run+0x62/0x78
[47201.848309]  [<ffffffff810013ab>] prepare_exit_to_usermode+0x81/0x9f
[47201.848310]  [<ffffffff81001437>] syscall_return_slowpath+0x6e/0x73
[47201.848313]  [<ffffffff81672a59>] entry_SYSCALL_64_fastpath+0x91/0x93
[47201.848315] ---[ end trace f6f5069f352abf69 ]---


This is home-compiled kernel 4.6.0-rc2 on Debian/sid

All the best
(please Cc)

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
