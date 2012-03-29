From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/volumes.c:2733
Date: Thu, 29 Mar 2012 09:16:38 -0400
Message-ID: <20120329131638.GA1942@localhost.localdomain>
References: <20120329105235.GA1198@panda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120329105235.GA1198@panda>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2012 at 12:52:35PM +0200, Sander wrote:
> Hello all,
> 
> I can't seem to balance my btrfs filesystem. It segfaults, and gives a
> kernel bug:
> 
> [ 1355.139099] ------------[ cut here ]------------
> [ 1355.139099] kernel BUG at fs/btrfs/volumes.c:2733!
> [ 1355.149322] Internal error: Oops - BUG: 0 [#1] SMP
> [ 1355.149322] Modules linked in:
> [ 1355.154479] CPU: 0    Not tainted  (3.3.0 #8)
> [ 1355.162109] PC is at btrfs_balance+0x312/0xb04
> [ 1355.166778] LR is at btrfs_run_delayed_iputs+0x2d/0xac
> [ 1355.166931] pc : [<c0138c3a>]    lr : [<c01234d5>]    psr: 60000033
> [ 1355.166931] sp : cb141d98  ip : 00000000  fp : be83fdb4
> [ 1355.166931] r10: 00000000  r9 : 00000000  r8 : 00000000
> [ 1355.184173] r7 : 00000000  r6 : ffffffef  r5 : ede7f000  r4 : ed730e00
> [ 1355.189636] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00000007
> [ 1355.203277] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
> [ 1355.203277] Control: 50c5387d  Table: 8b15c04a  DAC: 00000015
> [ 1355.203277] Process btrfs (pid: 1798, stack limit = 0xcb1402f8)
> [ 1355.203277] Stack: (0xcb141d98 to 0xcb142000)
> [ 1355.203277] 1d80:                                                       c145f944 ffffffff
> [ 1355.227691] 1da0: 00000000 00000000 00000000 00000000 00000003 ee478d40 00000015 00000000
> [ 1355.227691] 1dc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [ 1355.253356] 1de0: 00000000 00000000 00000000 00000000 00000000 00000000 ede7fcd4 ede7fcd8
> [ 1355.253356] 1e00: 00000000 00000000 00000000 00000000 00000000 271aee1c 000200da c0160fd5
> [ 1355.253356] 1e20: ed74ec00 00000000 d6257680 00000000 ed730e00 00000000 ede7f4e8 ede7fcb0
> [ 1355.279022] 1e40: ede7f000 00000000 be83fdb4 c013d489 eec9c118 be83ebf8 ed74ec00 eec8a370
> [ 1355.279022] 1e60: d6257680 00000000 eec8a528 00000000 be83fdb4 c013fc6b 0000001d 000000eb
> [ 1355.279022] 1e80: 00000007 00000001 e6f7e680 c015cecd cb141ea4 00000000 cb141ef0 00000000
> [ 1355.296142] 1ea0: cb15c000 01ffffff 00000000 ffffffff 00000001 00000000 eeabaac0 00000001
> [ 1355.296142] 1ec0: ed5428c0 c1414788 d6257688 000000eb cb141ef0 c016011b cb141ef0 00000000
> [ 1355.321807] 1ee0: 00000001 c016018f 00000000 00000817 00000001 271aee1c ede92250 d6257680
> [ 1355.321807] 1f00: be83ebf8 be83ebf8 eec8a528 00000000 cb140000 00000000 be83fdb4 c0088075
> [ 1355.321807] 1f20: 00004000 c00887ff 00000000 00000000 00000000 00000000 00000000 00000000
> [ 1355.338928] 1f40: 00000000 00000000 00000000 00000000 00000000 271aee1c 00000003 d6257680
> [ 1355.338928] 1f60: be83ebf8 5000940c d6257680 be83ebf8 5000940c 00000003 00000000 cb140000
> [ 1355.364593] 1f80: 00000000 c008885d 00000003 00000000 be83fec7 00000003 0013c478 00000036
> [ 1355.364593] 1fa0: c000c5a4 c000c401 be83fec7 00000003 00000003 5000940c be83ebf8 be83fbf8
> [ 1355.364593] 1fc0: be83fec7 00000003 0013c478 00000036 00000002 0000b7ad 00000001 be83fdb4
> [ 1355.381713] 1fe0: 00024b3d be83ebf0 0000b7f7 b6ea7f9c 80000010 00000003 00052d17 00090224
> [ 1355.381713] [<c0138c3a>] (btrfs_balance+0x312/0xb04) from [<c013d489>] (btrfs_ioctl_balance+0x109/0x174)
> [ 1355.381713] [<c013d489>] (btrfs_ioctl_balance+0x109/0x174) from [<c013fc6b>] (btrfs_ioctl+0xbf5/0xd42)
> [ 1355.418518] [<c013fc6b>] (btrfs_ioctl+0xbf5/0xd42) from [<c0088075>] (vfs_ioctl+0xd/0x28)
> [ 1355.418518] [<c0088075>] (vfs_ioctl+0xd/0x28) from [<c00887ff>] (do_vfs_ioctl+0x35d/0x38e)
> [ 1355.427093] [<c00887ff>] (do_vfs_ioctl+0x35d/0x38e) from [<c008885d>] (sys_ioctl+0x2d/0x44)
> [ 1355.444488] [<c008885d>] (sys_ioctl+0x2d/0x44) from [<c000c401>] (ret_fast_syscall+0x1/0x44)
> [ 1355.444488] Code: d107 f116 0f11 d100 (de02) 4620 
> [ 1355.458343] ---[ end trace f06b6b8fcd08e6d5 ]---
> 
> A new 'btrfs filesystem balance /' seems to just hang, and is
> unkillable.
> 
> After a reboot, I tried again, with the same result:
> 
> [   81.048767] ------------[ cut here ]------------
> [   81.053619] kernel BUG at fs/btrfs/volumes.c:2733!
> [   81.053619] Internal error: Oops - BUG: 0 [#1] SMP
> [   81.059295] Modules linked in:
> [   81.059295] CPU: 1    Not tainted  (3.3.0 #8)
> [   81.071411] PC is at btrfs_balance+0x312/0xb04
> [   81.074890] LR is at btrfs_run_delayed_iputs+0x2d/0xac
> [   81.074890] pc : [<c0138c3a>]    lr : [<c01234d5>]    psr: 60000133
> [   81.074890] sp : edda5d98  ip : 00000000  fp : beb62d64
> [   81.093475] r10: 00000000  r9 : 00000000  r8 : 00000000
> [   81.098327] r7 : 00000000  r6 : ffffffef  r5 : ed73f000  r4 : ee311c00
> [   81.098327] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00000007
> [   81.112609] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
> [   81.112609] Control: 50c5387d  Table: a7fb404a  DAC: 00000015
> [   81.112609] Process btrfs (pid: 752, stack limit = 0xedda42f8)
> [   81.132354] Stack: (0xedda5d98 to 0xedda6000)
> [   81.132354] 5d80:                                                       c145f944 ffffffff
> [   81.145477] 5da0: 00000000 00000000 00000000 00000000 00000003 eeabca40 00000015 00000000
> [   81.145477] 5dc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   81.145477] 5de0: 00000000 00000000 00000000 00000000 00000000 00000000 ed73fcd4 ed73fcd8
> [   81.162597] 5e00: 00000000 00000000 00000000 00000000 00000000 271aee1c 000200da c0160fd5
> [   81.162597] 5e20: ed784c00 00000000 ee117cc0 00000000 ee311c00 00000000 ed73f4e8 ed73fcb0
> [   81.188262] 5e40: ed73f000 00000000 beb62d64 c013d489 eec7ace8 beb61ba8 ed784c00 eecd5370
> [   81.188262] 5e60: ee117cc0 00000000 eecd5528 00000000 beb62d64 c013fc6b 0000001d 000000ec
> [   81.199951] 5e80: 00000007 00000001 ed74f200 c015cecd edda5ea4 00000000 edda5ef0 00000000
> [   81.199951] 5ea0: e7fb4050 01ffffff 00000000 ffffffff 00000001 00000000 eea3c740 00000001
> [   81.199951] 5ec0: eebe59c0 c1414788 ee117cc8 000000ec edda5ef0 c016011b edda5ef0 00000000
> [   81.222503] 5ee0: 00000001 c016018f 00000000 00000817 00000001 271aee1c ede92250 ee117cc0
> [   81.222503] 5f00: beb61ba8 beb61ba8 eecd5528 00000000 edda4000 00000000 beb62d64 c0088075
> [   81.248168] 5f20: 00004000 c00887ff 00000000 00000000 00000000 00000000 00000000 00000000
> [   81.248168] 5f40: 00000000 00000000 00000000 00000000 00000000 271aee1c 00000003 ee117cc0
> [   81.248168] 5f60: beb61ba8 5000940c ee117cc0 beb61ba8 5000940c 00000003 00000000 edda4000
> [   81.273834] 5f80: 00000000 c008885d 00000003 00000000 beb62e8c 00000003 01438478 00000036
> [   81.273834] 5fa0: c000c5a4 c000c401 beb62e8c 00000003 00000003 5000940c beb61ba8 beb62ba8
> [   81.290954] 5fc0: beb62e8c 00000003 01438478 00000036 00000002 0000b7ad 00000001 beb62d64
> [   81.293914] 5fe0: 00024b3d beb61ba0 0000b7f7 b6ee7f9c 80000110 00000003 372a242a 72d76d15
> [   81.293914] [<c0138c3a>] (btrfs_balance+0x312/0xb04) from [<c013d489>] (btrfs_ioctl_balance+0x109/0x174)
> [   81.309387] [<c013d489>] (btrfs_ioctl_balance+0x109/0x174) from [<c013fc6b>] (btrfs_ioctl+0xbf5/0xd42)
> [   81.309387] [<c013fc6b>] (btrfs_ioctl+0xbf5/0xd42) from [<c0088075>] (vfs_ioctl+0xd/0x28)
> [   81.309387] [<c0088075>] (vfs_ioctl+0xd/0x28) from [<c00887ff>] (do_vfs_ioctl+0x35d/0x38e)
> [   81.345001] [<c00887ff>] (do_vfs_ioctl+0x35d/0x38e) from [<c008885d>] (sys_ioctl+0x2d/0x44)
> [   81.345001] [<c008885d>] (sys_ioctl+0x2d/0x44) from [<c000c401>] (ret_fast_syscall+0x1/0x44)
> [   81.345001] Code: d107 f116 0f11 d100 (de02) 4620 
> [   81.367645] ---[ end trace 6b16e1c6e6a2dd9c ]---
> 
> 
> The system is a pandaboard running a plain Linus kernel 3.3.0 with a
> btrfs filesystem, over two Intel 320 600GB ssd's, connected via usb (on
> an usb hub), on top of md_crypt. Mount options:
> "subvol=rootvolume,space_cache,inode_cache,compress=lzo,ssd"
> 
> Before the balance, I deleted about 2500 snapshots and waited for the
> btrfs kernel threads to calm down. Then I initiated a btrfs filesystem
> scrub. Unfortunately during the scrub, the filesystem balance started.
> Might be related.
> 

Well that's kind of cool.  So 2 options

1) If you are in a hurry and need this stuff back right away run btrfs fi
balance resume / and it should work, buuutt

2) If you aren't in a hurry I'd really like to try and reproduce this locally
and if I can't I'd like to be able to send you patches to help me figure out how
to fix this problem.

Thanks,

Josef
