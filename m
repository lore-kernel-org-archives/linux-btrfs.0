From: Sander <sander@humilis.net>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000008
Date: Thu, 21 Jan 2010 08:36:59 +0100
Message-ID: <20100121073658.GA1381@cumulus>
References: <20100121060710.GA5301@cumulus>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100121060710.GA5301@cumulus>
List-ID: <linux-btrfs.vger.kernel.org>

Sander wrote (ao):
> I get the following error if I edit fstab with vi on a fresh btrfs
> filesystem. vi Segfaults at saving the file.
> 
> # mkfs.btrfs /dev/sda2
> # mount /mnt/
> # cd /
> # find . -xdev | cpio -vdump /mnt
> # vi /mnt/etc/fstab
> Segmentation fault
> 
> This also happens with a 'cp -a':
> 
> # cd /mnt/
> # cp etc/fstab tmp/
> # cp etc/fstab tmp/
> # cp -a etc/fstab tmp/
> Segmentation fault
> 
> And 'ls -l'
> 
> # cd /mnt/
> # ls tmp/
> bla  fstab  network.configured
> # ls -l tmp/
> Segmentation fault
> 
> Kernel config:
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> 
> (I'll try without ACL now, but takes about an hour to compile the
> kernel).

Without CONFIG_BTRFS_FS_POSIX_ACL I can't reproduce the segfaults.

	With kind regards, Sander


> This kernel is a patched 2.6.33-rc1 from
> git://repo.or.cz/linux-2.6/linux-2.6-openrd.git
> 
> This error also happens if I remove linux-2.6-openrd/fs/btrfs/ and copy
> btrfs-unstable/fs/btrfs/ (latetst as of yesterday and this morning). I'm
> not sure if that is allowed though.
> 
> # mkfs.btrfs -V
> mkfs.btrfs, part of Btrfs Btrfs v0.19
> 
> The system is Debian Sid on an Openrd-client (ARM). The ssd is an Intel
> X25-E.
> 
> I didn't find a similar bugreport.
> 
> 	With kind regards, Sander
> 
> 
> [26055.036656] device fsid 904e5c0206a9b9d1-f00b47d7270b119a devid 1 transid 7 /dev/sda2
> [26055.045253] btrfs: use ssd allocation scheme
> [26678.340511] Unable to handle kernel NULL pointer dereference at virtual address 00000008
> [26678.348648] pgd = cebb8000
> [26678.351367] [00000008] *pgd=03127031, *pte=00000000, *ppte=00000000
> [26678.357691] Internal error: Oops: 17 [#1]
> [26678.361716] last sysfs file: /sys/kernel/uevent_helper
> [26678.366878] Modules linked in:
> [26678.369950] CPU: 0    Not tainted  (2.6.33-rc1 #1)
> [26678.374768] PC is at btrfs_get_acl+0x60/0x250
> [26678.379142] LR is at btrfs_xattr_get_acl+0x10/0x70
> [26678.383956] pc : [<c026c294>]    lr : [<c026c494>]    psr: 20000093
> [26678.383962] sp : c5199e08  ip : c04fc87c  fp : bec451d4
> [26678.395498] r10: 00186058  r9 : c5198000  r8 : c0496b5a
> [26678.400749] r7 : 00000000  r6 : 00008000  r5 : ce0ef600  r4 : 00000008
> [26678.407307] r3 : 20000013  r2 : 20000093  r1 : 00008000  r0 : 00000008
> [26678.413864] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [26678.421119] Control: 0005397f  Table: 0ebb8000  DAC: 00000015
> [26678.426891] Process vi (pid: 1033, stack limit = 0xc5198270)
> [26678.432576] Stack: (0xc5199e08 to 0xc519a000)
> [26678.436958] 9e00:                   c5199e70 db119840 00000084 00000000 c0496b5a c5198000
> [26678.445182] 9e20: 00186058 c026c494 c5199e70 00000017 c04fc838 c019bb20 00000000 c5199e70
> [26678.453405] 9e40: ce0ef600 c98734c8 db119840 00000084 c5199e70 c019c01c 00000084 db119840
> [26678.461628] 9e60: bec450c0 ce0ef600 00000017 c019c0c4 74737973 702e6d65 7869736f 6c63615f
> [26678.469851] 9e80: 6363615f 00737365 c5199f18 00000000 00000001 c98734c8 00000000 c018e1e4
> [26678.478073] 9ea0: 00000000 00000001 00000371 117ee576 00000005 c3ba3009 dfc4a280 ce0ef600
> [26678.486297] 9ec0: 00000000 c5199f18 c5199ee8 c5198000 c3ba3000 00000000 c5199f18 c5198000
> [26678.494520] 9ee0: c3ba3000 c018e4cc c5199f2c c3ba3000 00000000 00000001 c5199f18 c3ba3000
> [26678.502743] 9f00: 00000000 c018e57c c04f26f0 c3ba3000 c3ba3000 c018eeb0 dfc4a280 ce0ef600
> [26678.510966] 9f20: c5199f30 c5199f48 bec45170 00000000 df412400 00000001 00000001 00000000
> [26678.519189] 9f40: 00179424 c01883a8 0001f9da 00000000 00000010 c51981a4 c04f240c d5b20900
> [26678.527411] 9f60: 00000012 c98734c8 c5199f88 00000002 c5199f88 00000084 bec450c0 4012f994
> [26678.535635] 9f80: 00000000 c019c220 dfc4a280 ce0ef600 00000084 bec450c0 4012c7e8 000000e5
> [26678.543858] 9fa0: c0122fa4 c0122e20 00000084 bec450c0 00186058 4012f994 bec450c0 00000084
> [26678.552081] 9fc0: 00000084 bec450c0 4012c7e8 000000e5 00000001 00179444 00186058 bec451d4
> [26678.560304] 9fe0: bec450b0 bec450a0 40274ecc 401fb5d0 60000010 00186058 d5abcade ace1046d
> [26678.568532] [<c026c294>] (btrfs_get_acl+0x60/0x250) from [<c026c494>] (btrfs_xattr_get_acl+0x10/0x70)
> [26678.577802] [<c026c494>] (btrfs_xattr_get_acl+0x10/0x70) from [<c019bb20>] (generic_getxattr+0x78/0x7c)
> [26678.587243] [<c019bb20>] (generic_getxattr+0x78/0x7c) from [<c019c01c>] (vfs_getxattr+0x58/0x5c)
> [26678.596074] [<c019c01c>] (vfs_getxattr+0x58/0x5c) from [<c019c0c4>] (getxattr+0xa4/0x11c)
> [26678.604298] [<c019c0c4>] (getxattr+0xa4/0x11c) from [<c019c220>] (sys_getxattr+0x44/0x58)
> [26678.612525] [<c019c220>] (sys_getxattr+0x44/0x58) from [<c0122e20>] (ret_fast_syscall+0x0/0x28)
> [26678.621265] Code: 0a000077 e10f3000 e3832080 e121f002 (e5942000)
> [26678.627621] ---[ end trace a16c1078eb68be38 ]---

-- 
Humilis IT Services and Solutions
http://www.humilis.net
