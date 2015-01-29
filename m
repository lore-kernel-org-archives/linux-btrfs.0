Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:61458
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751320AbbA2XYF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 18:24:05 -0500
From: Steven Schlansker <sschlansker@opentable.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        =?iso-8859-1?Q?Holger_Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Indefinite hang in reserve_metadata_bytes on kernel 3.18.3
Date: Thu, 29 Jan 2015 22:50:20 +0000
Message-ID: <3630FFF1-5CE8-4BDD-85BD-A0A1BF671168@opentable.com>
References: <868704D3-B79F-476F-A4CF-33C41274E6D4@opentable.com>
 <54CA06A6.3070108@googlemail.com>
In-Reply-To: <54CA06A6.3070108@googlemail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Holger,

On Jan 29, 2015, at 2:08 AM, Holger Hoffstätte <holger.hoffstaette@googlemail.com> wrote:

> [This mail was also posted to gmane.comp.file-systems.btrfs.]
> 
> On Thu, 29 Jan 2015 01:44:02 +0000, Steven Schlansker wrote:
> 
> [..snip..]
> 
>> The symptoms are an endlessly increasing stream of hung tasks and high
> 
> Please try 3.18.5 (-rc1 is good) which contains the following fix:
> 
> "workqueue: fix subtle pool management issue which can stall whole
> worker_pool"
> 
> see: http://article.gmane.org/gmane.linux.kernel.stable/122074
> 
> No promises but it seems sufficiently causally related..

Thank you for the suggestion.  I did not find a 3.18.5 presented in any form other than as a large number of *.patch files, so I went for 3.19-rc6 instead (which I verified has this commit)

Now I am getting:

[ 1224.728313] ------------[ cut here ]------------
[ 1224.728323] kernel BUG at fs/btrfs/extent-tree.c:7362!
[ 1224.728327] invalid opcode: 0000 [#1] SMP 
[ 1224.728331] Modules linked in: dm_multipath(E) scsi_dh(E) x86_pkg_temp_thermal(E) coretemp(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) aesni_intel(E) aes_x86_64(E) lrw(E) gf128mul(E) glue_helper(E) ablk_helper(E) cryptd(E) btrfs(E)
[ 1224.728347] CPU: 3 PID: 18072 Comm: gunicorn Tainted: G            E  3.19.0-rc6 #2
[ 1224.728351] task: ffff8803eafeb1c0 ti: ffff8803e8380000 task.ti: ffff8803e8380000
[ 1224.728354] RIP: e030:[<ffffffffa00210d3>]  [<ffffffffa00210d3>] btrfs_alloc_tree_block+0x3c3/0x3d0 [btrfs]
[ 1224.728372] RSP: e02b:ffff8803e83838b8  EFLAGS: 00010202
[ 1224.728375] RAX: fffffffffffffff4 RBX: fffffffffffffff4 RCX: 00000000000032ca
[ 1224.728377] RDX: 00000000000032c9 RSI: ffff8802660c6b90 RDI: ffff8807543ace00
[ 1224.728380] RBP: ffff8803e8383958 R08: 000000000001e560 R09: ffff88075a2de560
[ 1224.728383] R10: ffffffffa004fe02 R11: ffffea0009983180 R12: ffff88073dfaf8f0
[ 1224.728386] R13: ffff8807557fe170 R14: 0000000000000000 R15: ffff8800fe05d000
[ 1224.728393] FS:  00007fc8e0fc7740(0000) GS:ffff88075a2c0000(0000) knlGS:0000000000000000
[ 1224.728396] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1224.728399] CR2: 00007fc8e0fcd000 CR3: 00000003e8695000 CR4: 0000000000002660
[ 1224.728402] Stack:
[ 1224.728404]  0000000000000000 0000000000000000 ffff8803e83838d8 ffffffffa002b5be
[ 1224.728409]  ffff8803e83839a7 0000000000000061 ffff8807557fe000 0000000000000000
[ 1224.728413]  00000000000001d3 0000400000000000 ffff8802660c6a68 00ffffffa005782c
[ 1224.728417] Call Trace:
[ 1224.728430]  [<ffffffffa002b5be>] ? btree_set_page_dirty+0xe/0x10 [btrfs]
[ 1224.728442]  [<ffffffffa000b46c>] __btrfs_cow_block+0x11c/0x530 [btrfs]
[ 1224.728454]  [<ffffffffa000ba3c>] btrfs_cow_block+0x12c/0x1d0 [btrfs]
[ 1224.728465]  [<ffffffffa000f673>] btrfs_search_slot+0x1f3/0xa40 [btrfs]
[ 1224.728472]  [<ffffffff81003610>] ? xen_write_msr_safe+0x40/0x70
[ 1224.728477]  [<ffffffff8101260f>] ? __switch_to+0x15f/0x580
[ 1224.728482]  [<ffffffff811fa186>] ? inode_init_always+0x106/0x1e0
[ 1224.728490]  [<ffffffffa0011700>] btrfs_insert_empty_items+0x70/0xc0 [btrfs]
[ 1224.728494]  [<ffffffff811fc5a2>] ? insert_inode_locked4+0xe2/0x190
[ 1224.728506]  [<ffffffffa00413ff>] btrfs_new_inode+0x1bf/0x540 [btrfs]
[ 1224.728517]  [<ffffffffa0042bcf>] btrfs_create+0xdf/0x210 [btrfs]
[ 1224.728521]  [<ffffffff811ebf75>] vfs_create+0xd5/0x140
[ 1224.728524]  [<ffffffff811efaa3>] do_last+0x1013/0x1210
[ 1224.728528]  [<ffffffff811ecff1>] ? path_init+0xc1/0x470
[ 1224.728532]  [<ffffffff811efd24>] path_openat+0x84/0x630
[ 1224.728536]  [<ffffffff811e29f5>] ? __sb_end_write+0x35/0x70
[ 1224.728540]  [<ffffffff811f146a>] do_filp_open+0x3a/0x90
[ 1224.728544]  [<ffffffff811fe007>] ? __alloc_fd+0xa7/0x130
[ 1224.728548]  [<ffffffff811df548>] do_sys_open+0x128/0x220
[ 1224.728552]  [<ffffffff811df65e>] SyS_open+0x1e/0x20
[ 1224.728557]  [<ffffffff819521ed>] system_call_fastpath+0x16/0x1b
[ 1224.728560] Code: 3d 00 f0 ff ff 0f 87 b8 fd ff ff 44 8b 6d ac 4d 01 af d0 03 00 00 48 83 c4 78 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 0f 0b 0f 0b <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 
[ 1224.728597] RIP  [<ffffffffa00210d3>] btrfs_alloc_tree_block+0x3c3/0x3d0 [btrfs]
[ 1224.728610]  RSP <ffff8803e83838b8>


