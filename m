Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61815 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2GCQ32 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 12:29:28 -0400
Received: by obbuo13 with SMTP id uo13so10022011obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 09:29:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF31D40.6080103@giantdisaster.de>
References: <CAHf9xva5sdgwoTMJE5_Pmh_OBba2Jr6Ox4ov+rZUT6-aynb7CQ@mail.gmail.com>
	<4FF2FB5B.70909@giantdisaster.de>
	<4FF31D40.6080103@giantdisaster.de>
Date: Tue, 3 Jul 2012 19:29:27 +0300
Message-ID: <CAHf9xvb=7dguyYGDTVmfQ6WtM-RzKq=+tM8Xpak_GGprqAUP5g@mail.gmail.com>
Subject: Re: Testing permanent IO errors with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stephan,
Thank you for the analysis. Yes, I fully switched the dmsetup to
"error". Below are my kernel logs, in case you still need them.

Thanks,
Alex.

Jul  2 15:33:29 dev kernel: [  267.979062] Btrfs loaded
Jul  2 15:34:18 dev kernel: [  317.331859] device fsid
3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa devid 1 transid 7 /dev/sda
Jul  2 15:34:18 dev kernel: [  317.333169] btrfs: setting nodatacow
Jul  2 15:34:18 dev kernel: [  317.338340] btrfs: no dev_stats entry
found for device /dev/sda (devid 1) (OK on first mount after mkfs)
Jul  2 15:34:53 dev kernel: [  352.257768] device fsid
3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa devid 1 transid 10
/dev/mapper/sda
Jul  2 15:34:53 dev kernel: [  352.258999] btrfs: setting nodatacow
Jul  2 15:34:53 dev kernel: [  352.263037] btrfs: bdev /dev/mapper/sda
errs: wr 0, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.495430] btrfs: bdev /dev/mapper/sda
errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.496697] btrfs: bdev /dev/mapper/sda
errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.497892] btrfs: bdev /dev/mapper/sda
errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.499031] btrfs: bdev /dev/mapper/sda
errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.499040] quiet_error: 15 callbacks suppressed
Jul  2 15:38:29 dev kernel: [  568.499043] Buffer I/O error on device
dm-0, logical block 5242864
Jul  2 15:38:29 dev kernel: [  568.499047] Buffer I/O error on device
dm-0, logical block 5242864
Jul  2 15:38:29 dev kernel: [  568.499076] Buffer I/O error on device
dm-0, logical block 5242878
Jul  2 15:38:29 dev kernel: [  568.499080] Buffer I/O error on device
dm-0, logical block 5242878
Jul  2 15:38:29 dev kernel: [  568.499089] Buffer I/O error on device
dm-0, logical block 0
Jul  2 15:38:29 dev kernel: [  568.499092] Buffer I/O error on device
dm-0, logical block 0
Jul  2 15:38:29 dev kernel: [  568.499097] Buffer I/O error on device
dm-0, logical block 1
Jul  2 15:38:29 dev kernel: [  568.499105] Buffer I/O error on device
dm-0, logical block 5242879
Jul  2 15:38:29 dev kernel: [  568.499180] Buffer I/O error on device
dm-0, logical block 5242879
Jul  2 15:38:29 dev kernel: [  568.499184] Buffer I/O error on device
dm-0, logical block 5242879
Jul  2 15:38:29 dev kernel: [  568.507477] btrfs: bdev /dev/mapper/sda
errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.508875] btrfs: bdev /dev/mapper/sda
errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.510031] btrfs: bdev /dev/mapper/sda
errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.511167] btrfs: bdev /dev/mapper/sda
errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.512361] btrfs: bdev /dev/mapper/sda
errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.513641] btrfs: bdev /dev/mapper/sda
errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
Jul  2 15:38:29 dev kernel: [  568.588406] BTRFS error (device dm-0)
in btrfs_commit_transaction:1488: IO failure (Error while writing out
transaction.)
Jul  2 15:38:29 dev kernel: [  568.589387] btrfs is forced readonly
Jul  2 15:38:29 dev kernel: [  568.589392] BTRFS warning (device
dm-0): Skipping commit of aborted transaction.
Jul  2 15:38:29 dev kernel: [  568.589400] ------------[ cut here ]------------
Jul  2 15:38:29 dev kernel: [  568.589428] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/super.c:221
__btrfs_abort_transaction+0xae/0xc0 [btrfs]()
Jul  2 15:38:29 dev kernel: [  568.589437] Hardware name: Bochs
Jul  2 15:38:29 dev kernel: [  568.589438] btrfs: Transaction aborted
Jul  2 15:38:29 dev kernel: [  568.589439] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:38:29 dev kernel: [  568.589483] Pid: 4242, comm:
DataTransfer.li Tainted: G           O 3.4.0-999-generic #1340525350
Jul  2 15:38:29 dev kernel: [  568.589486] Call Trace:
Jul  2 15:38:29 dev kernel: [  568.589524]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:38:29 dev kernel: [  568.589529]  [<ffffffff81050366>]
warn_slowpath_fmt+0x46/0x50
Jul  2 15:38:29 dev kernel: [  568.589540]  [<ffffffffa02dbdde>]
__btrfs_abort_transaction+0xae/0xc0 [btrfs]
Jul  2 15:38:29 dev kernel: [  568.589557]  [<ffffffffa030206b>]
btrfs_commit_transaction+0x10b/0xab0 [btrfs]
Jul  2 15:38:29 dev kernel: [  568.589569]  [<ffffffff81073a80>] ?
add_wait_queue+0x60/0x60
Jul  2 15:38:29 dev kernel: [  568.589582]  [<ffffffffa0311381>]
btrfs_sync_file+0x151/0x230 [btrfs]
Jul  2 15:38:29 dev kernel: [  568.589595]  [<ffffffff811aac86>]
do_fsync+0x56/0x80
Jul  2 15:38:29 dev kernel: [  568.589598]  [<ffffffff811aafb0>]
sys_fsync+0x10/0x20
Jul  2 15:38:29 dev kernel: [  568.589614]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:38:29 dev kernel: [  568.589616] ---[ end trace 9aab25b38802f2b6 ]---
Jul  2 15:38:29 dev kernel: [  568.589619] BTRFS error (device dm-0)
in cleanup_transaction:1226: IO failure
Jul  2 15:38:29 dev kernel: [  568.590197] delayed_refs has NO entry
===>Here I call umount:
Jul  2 15:40:36 dev kernel: [  695.452264] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.452301] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7020
btrfs_destroy_inode+0x2eb/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.452305] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.452307] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.452355] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.452359] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.452371]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.452376]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.452394]  [<ffffffffa031064b>]
btrfs_destroy_inode+0x2eb/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.452423]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.452427]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.452432]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.452439]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.452444]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.452448]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.452458]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.452463]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.452466]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.452472]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.452476]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.452483]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.452487] ---[ end trace 9aab25b38802f2b7 ]---
Jul  2 15:40:36 dev kernel: [  695.452489] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.452507] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7021
btrfs_destroy_inode+0x2d5/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.452510] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.452512] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.452545] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.452548] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.452552]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.452556]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.452575]  [<ffffffffa0310635>]
btrfs_destroy_inode+0x2d5/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.452580]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.452584]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.452588]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.452592]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.452596]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.452599]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.452609]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.452613]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.452617]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.452621]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.452625]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.452629]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.452631] ---[ end trace 9aab25b38802f2b8 ]---
Jul  2 15:40:36 dev kernel: [  695.490269] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.490295] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7020
btrfs_destroy_inode+0x2eb/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.490299] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.490301] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.490339] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.490342] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.490350]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.490355]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.490373]  [<ffffffffa031064b>]
btrfs_destroy_inode+0x2eb/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.490379]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.490383]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.490387]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.490391]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.490395]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.490399]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.490409]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.490422]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.490426]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.490430]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.490434]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.490439]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.490442] ---[ end trace 9aab25b38802f2b9 ]---
Jul  2 15:40:36 dev kernel: [  695.490444] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.490462] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7021
btrfs_destroy_inode+0x2d5/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.490465] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.490467] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.490500] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.490503] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.490507]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.490512]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.490530]  [<ffffffffa0310635>]
btrfs_destroy_inode+0x2d5/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.490535]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.490539]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.490543]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.490547]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.490551]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.490554]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.490565]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.490569]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.490572]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.490576]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.490580]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.490584]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.490587] ---[ end trace 9aab25b38802f2ba ]---
Jul  2 15:40:36 dev kernel: [  695.538293] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.538323] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7020
btrfs_destroy_inode+0x2eb/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.538327] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.538329] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.538369] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.538372] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.538382]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.538387]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.538406]  [<ffffffffa031064b>]
btrfs_destroy_inode+0x2eb/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.538412]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.538416]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.538420]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.538424]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.538429]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.538432]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.538443]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.538447]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.538450]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.538454]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.538458]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.538474]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.538478] ---[ end trace 9aab25b38802f2bb ]---
Jul  2 15:40:36 dev kernel: [  695.538480] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.538498] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7021
btrfs_destroy_inode+0x2d5/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.538501] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.538503] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.538536] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.538539] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.538543]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.538548]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.538566]  [<ffffffffa0310635>]
btrfs_destroy_inode+0x2d5/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.538571]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.538575]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.538579]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.538583]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.538587]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.538591]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.538601]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.538605]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.538609]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.538612]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.538616]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.538620]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.538623] ---[ end trace 9aab25b38802f2bc ]---
Jul  2 15:40:36 dev kernel: [  695.581074] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.581102] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7020
btrfs_destroy_inode+0x2eb/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.581106] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.581108] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.581149] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.581152] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.581161]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.581166]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.581185]  [<ffffffffa031064b>]
btrfs_destroy_inode+0x2eb/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.581191]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.581195]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.581199]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.581203]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.581207]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.581211]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.581221]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.581225]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.581229]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.581233]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.581237]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.581242]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.581245] ---[ end trace 9aab25b38802f2bd ]---
Jul  2 15:40:36 dev kernel: [  695.581247] ------------[ cut here ]------------
Jul  2 15:40:36 dev kernel: [  695.581265] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/inode.c:7021
btrfs_destroy_inode+0x2d5/0x330 [btrfs]()
Jul  2 15:40:36 dev kernel: [  695.581276] Hardware name: Bochs
Jul  2 15:40:36 dev kernel: [  695.581278] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:36 dev kernel: [  695.581312] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:36 dev kernel: [  695.581314] Call Trace:
Jul  2 15:40:36 dev kernel: [  695.581319]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:36 dev kernel: [  695.581323]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:36 dev kernel: [  695.581342]  [<ffffffffa0310635>]
btrfs_destroy_inode+0x2d5/0x330 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.581347]  [<ffffffff81196fdc>]
destroy_inode+0x3c/0x70
Jul  2 15:40:36 dev kernel: [  695.581351]  [<ffffffff8119713a>]
evict+0x12a/0x1c0
Jul  2 15:40:36 dev kernel: [  695.581355]  [<ffffffff811977b1>]
dispose_list+0x41/0x50
Jul  2 15:40:36 dev kernel: [  695.581359]  [<ffffffff81197ece>]
evict_inodes+0xce/0x130
Jul  2 15:40:36 dev kernel: [  695.581363]  [<ffffffff8117ef23>]
generic_shutdown_super+0x53/0xf0
Jul  2 15:40:36 dev kernel: [  695.581366]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:36 dev kernel: [  695.581377]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:36 dev kernel: [  695.581381]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:36 dev kernel: [  695.581384]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:36 dev kernel: [  695.581388]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:36 dev kernel: [  695.581392]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:36 dev kernel: [  695.581396]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:36 dev kernel: [  695.581399] ---[ end trace 9aab25b38802f2be ]---
Jul  2 15:40:37 dev kernel: [  695.709460] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.709488] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:125
btrfs_put_block_group+0x6c/0x70 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.709492] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.709494] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.709539] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.709542] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.709554]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.709558]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.709571]  [<ffffffffa02eaeac>]
btrfs_put_block_group+0x6c/0x70 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709586]  [<ffffffffa02f3910>]
btrfs_free_block_groups+0xb0/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709603]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709612]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.709622]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709627]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.709631]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.709641]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709645]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.709648]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.709652]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.709656]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.709662]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.709665] ---[ end trace 9aab25b38802f2bf ]---
Jul  2 15:40:37 dev kernel: [  695.709669] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.709681] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:125
btrfs_put_block_group+0x6c/0x70 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.709684] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.709686] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.709729] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.709731] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.709736]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.709740]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.709753]  [<ffffffffa02eaeac>]
btrfs_put_block_group+0x6c/0x70 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709767]  [<ffffffffa02f3910>]
btrfs_free_block_groups+0xb0/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709784]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709789]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.709799]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709803]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.709807]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.709817]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709821]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.709824]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.709828]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.709832]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.709836]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.709839] ---[ end trace 9aab25b38802f2c0 ]---
Jul  2 15:40:37 dev kernel: [  695.709850] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.709862] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:125
btrfs_put_block_group+0x6c/0x70 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.709865] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.709867] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.709899] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.709901] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.709906]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.709910]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.709923]  [<ffffffffa02eaeac>]
btrfs_put_block_group+0x6c/0x70 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709937]  [<ffffffffa02f3910>]
btrfs_free_block_groups+0xb0/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709954]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709958]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.709968]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709972]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.709976]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.709986]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.709990]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.709994]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.709998]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710002]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710006]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710009] ---[ end trace 9aab25b38802f2c1 ]---
Jul  2 15:40:37 dev kernel: [  695.710046] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.710061] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:4305
btrfs_free_block_groups+0x2ce/0x370 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.710064] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.710065] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.710103] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.710106] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.710111]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.710115]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.710130]  [<ffffffffa02f3b2e>]
btrfs_free_block_groups+0x2ce/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710147]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710151]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.710162]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710166]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.710170]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.710180]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710184]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.710187]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.710191]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710195]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710199]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710202] ---[ end trace 9aab25b38802f2c2 ]---
Jul  2 15:40:37 dev kernel: [  695.710204] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.710218] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:4306
btrfs_free_block_groups+0x368/0x370 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.710221] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.710222] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.710254] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.710256] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.710261]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.710265]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.710279]  [<ffffffffa02f3bc8>]
btrfs_free_block_groups+0x368/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710296]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710301]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.710311]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710315]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.710319]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.710329]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710333]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.710337]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.710340]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710344]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710348]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710351] ---[ end trace 9aab25b38802f2c3 ]---
Jul  2 15:40:37 dev kernel: [  695.710353] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.710367] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:4307
btrfs_free_block_groups+0x352/0x370 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.710370] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.710371] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.710403] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.710405] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.710410]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.710414]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.710428]  [<ffffffffa02f3bb2>]
btrfs_free_block_groups+0x352/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710449]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710454]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.710464]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710468]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.710472]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.710482]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710486]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.710489]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.710493]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710497]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710501]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710504] ---[ end trace 9aab25b38802f2c4 ]---
Jul  2 15:40:37 dev kernel: [  695.710505] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.710519] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:7567
btrfs_free_block_groups+0x262/0x370 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.710522] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.710524] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.710556] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.710558] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.710563]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.710567]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.710581]  [<ffffffffa02f3ac2>]
btrfs_free_block_groups+0x262/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710598]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710603]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.710613]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710617]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.710620]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.710630]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710634]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.710638]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.710642]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710645]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710650]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710652] ---[ end trace 9aab25b38802f2c5 ]---
Jul  2 15:40:37 dev kernel: [  695.710655] space_info 1 has 1102032896
free, is not full
Jul  2 15:40:37 dev kernel: [  695.710659] space_info
total=5377097728, used=3674714112, pinned=0, reserved=600350720,
may_use=0, readonly=0
Jul  2 15:40:37 dev kernel: [  695.710662] ------------[ cut here ]------------
Jul  2 15:40:37 dev kernel: [  695.710676] WARNING: at
/mnt/work/alex/linux-btrfs-chris/source/fs/btrfs/extent-tree.c:7567
btrfs_free_block_groups+0x262/0x370 [btrfs]()
Jul  2 15:40:37 dev kernel: [  695.710679] Hardware name: Bochs
Jul  2 15:40:37 dev kernel: [  695.710681] Modules linked in: btrfs(O)
deflate ctr twofish_generic twofish_x86_64_3way lrw xts gf128mul
twofish_x86_64 twofish_common camellia_generic serpent_generic
blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic
xcbc rmd160 sha512_generic crypto_null af_key ppdev nfsd nfs lockd
fscache auth_rpcgss nfs_acl psmouse sunrpc serio_raw parport_pc
microcode mac_hid i2c_piix4 lp parport floppy zlib_deflate libcrc32c
[last unloaded: btrfs]
Jul  2 15:40:37 dev kernel: [  695.710712] Pid: 4399, comm: umount
Tainted: G        W  O 3.4.0-999-generic #1340525350
Jul  2 15:40:37 dev kernel: [  695.710715] Call Trace:
Jul  2 15:40:37 dev kernel: [  695.710719]  [<ffffffff8105026f>]
warn_slowpath_common+0x7f/0xc0
Jul  2 15:40:37 dev kernel: [  695.710724]  [<ffffffff810502ca>]
warn_slowpath_null+0x1a/0x20
Jul  2 15:40:37 dev kernel: [  695.710738]  [<ffffffffa02f3ac2>]
btrfs_free_block_groups+0x262/0x370 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710755]  [<ffffffffa02feca4>]
close_ctree+0x1a4/0x310 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710759]  [<ffffffff81197ece>] ?
evict_inodes+0xce/0x130
Jul  2 15:40:37 dev kernel: [  695.710773]  [<ffffffffa02d76c9>]
btrfs_put_super+0x19/0x20 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710777]  [<ffffffff8117ef32>]
generic_shutdown_super+0x62/0xf0
Jul  2 15:40:37 dev kernel: [  695.710781]  [<ffffffff8117f056>]
kill_anon_super+0x16/0x30
Jul  2 15:40:37 dev kernel: [  695.710791]  [<ffffffffa02d9f4a>]
btrfs_kill_super+0x1a/0x90 [btrfs]
Jul  2 15:40:37 dev kernel: [  695.710795]  [<ffffffff8117f52c>]
deactivate_locked_super+0x3c/0xa0
Jul  2 15:40:37 dev kernel: [  695.710799]  [<ffffffff8117fe1e>]
deactivate_super+0x4e/0x70
Jul  2 15:40:37 dev kernel: [  695.710802]  [<ffffffff8119b60c>]
mntput_no_expire+0xdc/0x130
Jul  2 15:40:37 dev kernel: [  695.710806]  [<ffffffff8119c906>]
sys_umount+0x66/0xe0
Jul  2 15:40:37 dev kernel: [  695.710810]  [<ffffffff816758e9>]
system_call_fastpath+0x16/0x1b
Jul  2 15:40:37 dev kernel: [  695.710813] ---[ end trace 9aab25b38802f2c6 ]---
Jul  2 15:40:37 dev kernel: [  695.710816] space_info 4 has 1073614848
free, is not full
Jul  2 15:40:37 dev kernel: [  695.710819] space_info
total=1082130432, used=49152, pinned=0, reserved=12288,
may_use=1179648, readonly=8454144
====> mount again
Jul  2 15:44:06 dev kernel: [  904.813369] Btrfs loaded
Jul  2 15:44:22 dev kernel: [  921.353427] device fsid
3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa devid 1 transid 13
/dev/mapper/sda
Jul  2 15:44:22 dev kernel: [  921.354226] btrfs: setting nodatacow
Jul  2 15:44:22 dev kernel: [  921.357722] parent transid verify
failed on 20971520 wanted 13 found 5
Jul  2 15:44:22 dev kernel: [  921.375692] parent transid verify
failed on 20971520 wanted 13 found 5
Jul  2 15:44:22 dev kernel: [  921.376169] btrfs read error corrected:
ino 1 off 20971520 (dev /dev/mapper/sda sector 40960)
Jul  2 15:44:22 dev kernel: [  921.376174] btrfs: failed to read chunk
root on dm-0
Jul  2 15:44:22 dev kernel: [  921.376746] btrfs: open_ctree failed
Jul  2 15:45:15 dev kernel: [  973.801194] device fsid
3f3f4343-d8e4-4dd7-ba9f-03f335b6bcfa devid 1 transid 13
/dev/mapper/sda
Jul  2 15:45:15 dev kernel: [  973.801961] btrfs: setting nodatacow
Jul  2 15:45:15 dev kernel: [  973.803795] parent transid verify
failed on 20971520 wanted 13 found 5
Jul  2 15:45:15 dev kernel: [  973.803989] parent transid verify
failed on 20971520 wanted 13 found 5
Jul  2 15:45:15 dev kernel: [  973.804739] btrfs read error corrected:
ino 1 off 20971520 (dev /dev/mapper/sda sector 40960)
Jul  2 15:45:15 dev kernel: [  973.804745] btrfs: failed to read chunk
root on dm-0
Jul  2 15:45:15 dev kernel: [  973.806169] btrfs: open_ctree failed
Jul  2 16:00:01 dev kernel: [ 1860.193154] quiet_error: 129 callbacks suppressed
