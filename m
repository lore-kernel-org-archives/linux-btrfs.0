Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57396 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaAJOww (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 09:52:52 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140110123143.GB14604@localhost>
References: <20140110123143.GB14604@localhost>
Date: Fri, 10 Jan 2014 14:52:51 +0000
Message-ID: <CAL3q7H6M6XqePxKiymfubM3zx6D4tqCcmttUP6G1P_cYy6OpgQ@mail.gmail.com>
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference at (null)
From: Filipe David Manana <fdmanana@gmail.com>
To: kernel test robot <fengguang.wu@intel.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 10, 2014 at 12:31 PM, kernel test robot
<fengguang.wu@intel.com> wrote:
> Greetings,
>
> I got the below dmesg and the first bad commit is
>
> commit 87e612ae9ed2ea886bec151145f4b09b6ee97a10
> Author:     Filipe David Borba Manana <fdmanana@gmail.com>
> AuthorDate: Tue Jan 7 11:47:46 2014 +0000
> Commit:     Josef Bacik <jbacik@fb.com>
> CommitDate: Wed Jan 8 15:32:30 2014 -0500
>
>     Btrfs: add support for inode properties
>
>     Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>     Signed-off-by: Josef Bacik <jbacik@fb.com>
>
>
> [    1.998830] ROMFS MTD (C) 2007 Red Hat, Inc.
> [    2.008849] fuse init (API version 7.22)
> [    2.011041] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
> [    2.024722] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    2.027814] IP: [<ffffffff81501594>] crc32c+0xc/0x6b

So it turns I didn't caught before because only tested with btrfs
built as a module.
In your .config both btrfs and crc32c are configured as built-in.

The issue is that the init function of btrfs
(fs/btrfs/super.c:init_btrfs_fs) now makes use of the crc32c
(libcrc32c.c) function. But when it attempts to call it, the static
data it needs was not yet initialized. From libcrc32c.c:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/lib/libcrc32c.c?id=refs/tags/v3.13-rc7#n40

Btrfs already used crc32c all over the place, but not from within its
init function.

Are there any kernel APIs to specify module initialization
dependencies? (and that work regardless of either btrfs or crc32c, or
both, being built as a module or built-in).

thanks

> [    2.028684] PGD 0
> [    2.028684] Oops: 0000 [#1] SMP
> [    2.028684] Modules linked in:
> [    2.028684] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc7-04795-ga7b57c2 #1
> [    2.028684] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    2.028684] task: ffff88000edba100 ti: ffff88000edd6000 task.ti: ffff88000edd6000
> [    2.028684] RIP: 0010:[<ffffffff81501594>]  [<ffffffff81501594>] crc32c+0xc/0x6b
> [    2.028684] RSP: 0000:ffff88000edd7e58  EFLAGS: 00010246
> [    2.028684] RAX: 0000000000000000 RBX: ffffffff82295550 RCX: 0000000000000000
> [    2.028684] RDX: 0000000000000011 RSI: ffffffff81efe393 RDI: 00000000fffffffe
> [    2.028684] RBP: ffff88000edd7e60 R08: 0000000000000003 R09: 0000000000015d20
> [    2.028684] R10: ffffffff81ef225e R11: ffffffff811b0222 R12: ffffffffffffffff
> [    2.028684] R13: 0000000000000239 R14: 0000000000000000 R15: 0000000000000000
> [    2.028684] FS:  0000000000000000(0000) GS:ffff88000fa00000(0000) knlGS:0000000000000000
> [    2.028684] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    2.028684] CR2: 0000000000000000 CR3: 000000000220c000 CR4: 00000000000006f0
> [    2.028684] Stack:
> [    2.028684]  ffffffff82295550 ffff88000edd7e80 ffffffff8238af62 ffffffff8238ac05
> [    2.028684]  0000000000000000 ffff88000edd7e98 ffffffff8238ac0f ffffffff8238ac05
> [    2.028684]  ffff88000edd7f08 ffffffff810002ba ffff88000edd7f00 ffffffff810e2404
> [    2.028684] Call Trace:
> [    2.028684]  [<ffffffff8238af62>] btrfs_props_init+0x4f/0x96
> [    2.028684]  [<ffffffff8238ac05>] ? ftrace_define_fields_btrfs_space_reservation+0x145/0x145
> [    2.028684]  [<ffffffff8238ac0f>] init_btrfs_fs+0xa/0xf0
> [    2.028684]  [<ffffffff8238ac05>] ? ftrace_define_fields_btrfs_space_reservation+0x145/0x145
> [    2.028684]  [<ffffffff810002ba>] do_one_initcall+0xa4/0x13a
> [    2.028684]  [<ffffffff810e2404>] ? parse_args+0x25f/0x33d
> [    2.028684]  [<ffffffff8234cf75>] kernel_init_freeable+0x1aa/0x230
> [    2.028684]  [<ffffffff8234c785>] ? do_early_param+0x88/0x88
> [    2.028684]  [<ffffffff819f61b5>] ? rest_init+0x89/0x89
> [    2.028684]  [<ffffffff819f61c3>] kernel_init+0xe/0x109
> [    2.028684]  [<ffffffff81a133fc>] ret_from_fork+0x7c/0xb0
> [    2.028684]  [<ffffffff819f61b5>] ? rest_init+0x89/0x89
> [    2.028684] Code: e5 e8 17 ff ff ff 5d c3 48 85 d2 89 f8 74 0f 55 b9 78 3b f6 82 48 89 e5 e8 00 ff ff ff 5d c3 48 8b 0d 91 2e 13 01 55 48 89 e5 53 <8b> 01 48 83 c0 17 48 83 e0 f8 48 83 c0 0e 48 c1 e8 03 48 c1 e0
> [    2.028684] RIP  [<ffffffff81501594>] crc32c+0xc/0x6b
> [    2.028684]  RSP <ffff88000edd7e58>
> [    2.028684] CR2: 0000000000000000
> [    2.028684] ---[ end trace 708701e01d1d3a3b ]---
> [    2.221062] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
>
> git bisect start a7b57c2737e92e6ba4bedbd4a001aed5d4b62fd5 d6e0a2dd12f4067a5bcefb8bbd8ddbeff800afbc --
> git bisect  bad 5615d9a96f8109556850ee41592f8f9d2279e566  # 19:03      0-     20  Merge 'nmenon/tmp/kristo-clks-v13-jan9-am43xx' into devel-hourly-2014011013
> git bisect  bad f8df98706ae4547924141b8d95c307ef742999a7  # 19:03      0-     20  Merge 'kees/format-security' into devel-hourly-2014011013
> git bisect good 4b251aef823521c4b2cdc8d413975378f3bb7fc1  # 19:08     20+      0  Merge 'sstabellini-xen/lost_ticks_8' into devel-hourly-2014011013
> git bisect good c8a1dd4964097ec13d6a60434e58d9ec19e83918  # 19:12     20+      0  Merge 'mac80211-next/wip' into devel-hourly-2014011013
> git bisect  bad b7f416846110d9aa9ec315e51bc2eadf3cd2934f  # 19:15      0-     17  Merge 'josef-btrfs/master' into devel-hourly-2014011013
> git bisect good 69c2c7d9568a4d4a3c5207f52f459cdac09701dd  # 19:20     20+      0  Merge 'kees/lkdtm' into devel-hourly-2014011013
> git bisect good 35d47d611d6811d25e8032bad9a3cc50735591c9  # 19:26     20+      0  Btrfs: fix wrong super generation mismatch when scrubbing supers
> git bisect good 6d7a126842207c1d6a55b92ea293061f174132dd  # 19:39     20+      0  Btrfs: use flags instead of the bool variants in delayed node
> git bisect good 3d87c99a71684920bf9427c4ecdea24aeacc4192  # 19:47     20+      0  btrfs: Add noautodefrag mount option.
> git bisect good ed462d91b13ea7155b25f6e9066052499dc0f93b  # 19:54     20+      1  btrfs: Add treelog mount option.
> git bisect good e2221577bed80f6c409d86157696e805995a08a5  # 20:01     20+      0  Btrfs: remove unnecessary transaction commit before send
> git bisect good a956b1b9216be628ea59bd682529795683258736  # 20:06     20+      0  Btrfs: faster file extent item replace operations
> git bisect  bad 87e612ae9ed2ea886bec151145f4b09b6ee97a10  # 20:06      0-    100  Btrfs: add support for inode properties
> # first bad commit: [87e612ae9ed2ea886bec151145f4b09b6ee97a10] Btrfs: add support for inode properties
> git bisect good a956b1b9216be628ea59bd682529795683258736  # 20:08     60+      2  Btrfs: faster file extent item replace operations
> git bisect  bad a7b57c2737e92e6ba4bedbd4a001aed5d4b62fd5  # 20:08      0-     29  0day head guard for 'devel-hourly-2014011013'
> git bisect good 846ec8a51f482309801dfbed236638cfe86ef950  # 20:18     60+      1  Revert "Btrfs: add support for inode properties"
> git bisect good 21e20e22d4e9d6ae8504c7275049a57ad4d1b71f  # 20:22     60+      1  Merge tag 'clk-fixes-for-linus' of git://git.linaro.org/people/mike.turquette/linux
> git bisect  bad 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 20:22      0-     52  Add linux-next specific files for 20140110
>
> Thanks,
> Fengguang



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
