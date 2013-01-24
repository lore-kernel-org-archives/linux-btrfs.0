Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38153 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab3AXJqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 04:46:34 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4609172eei.21
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 01:46:33 -0800 (PST)
Message-ID: <C53E5EC1712746DBA90EFED6D9BAEF52@LevPC>
From: "Lev Vainblat" <lev@zadarastorage.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Warnings on file removal after Quota exceeded error (EDQUOT)
Date: Thu, 24 Jan 2013 11:39:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I executed the following simple sequence of commands:

# mount /dev/sda /mnt/btrfs
# btrfs quota enable /mnt/btrfs/
# btrfs subvolume create /mnt/btrfs/SV
Create subvolume '/mnt/btrfs/SV'
# btrfs qgroup limit 1m /mnt/btrfs/SV
# dd if=/dev/zero of=/mnt/btrfs/SV/file bs=64x1024
dd: writing `/mnt/btrfs/SV/file': Disk quota exceeded
16+0 records in
15+0 records out
983040 bytes (983 kB) copied, 0.00192474 s, 511 MB/s
# rm /mnt/btrfs/SV/file

The file was removed, but in the kern.log I see:

[67577.594688] ------------[ cut here ]------------
[67577.594723] WARNING: at /source/fs/btrfs/inode.c:7177 
btrfs_destroy_inode+0x266/0x300 [btrfs]()
[67577.594726] Hardware name: Bochs
[67577.594728] Modules linked in: btrfs(O) libcrc32c deflate zlib_deflate 
ctr twofish_generic twofish_x86_64_3way glue_helper lrw xts gf128mul 
twofish_x86_64 twofish_common camellia_generic serpent_generic 
blowfish_generic blowfish_x86_64 blowfish_common cast5_generic des_generic 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm ppdev microcode 
psmouse nfsv4 serio_raw nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc 
parport_pc mac_hid i2c_piix4 lp parport floppy [last unloaded: btrfs]
[67577.594788] Pid: 10692, comm: rm Tainted: G        W  O 3.7.0-560-generic 
#57ba86c00f9573b63b8c06810d4f6915efed2442
[67577.594790] Call Trace:
[67577.594804]  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
[67577.594810]  [<ffffffff81056daa>] warn_slowpath_null+0x1a/0x20
[67577.594830]  [<ffffffffa039b296>] btrfs_destroy_inode+0x266/0x300 [btrfs]
[67577.594838]  [<ffffffff8119e16c>] destroy_inode+0x3c/0x70
[67577.594843]  [<ffffffff8119e2d6>] evict+0x136/0x1d0
[67577.594849]  [<ffffffff8119eb92>] iput_final+0xe2/0x170
[67577.594853]  [<ffffffff8119ec5e>] iput+0x3e/0x50
[67577.594859]  [<ffffffff8119167b>] do_unlinkat+0x12b/0x1d0
[67577.594867]  [<ffffffff81698dde>] ? do_page_fault+0xe/0x10
[67577.594871]  [<ffffffff816984d5>] ? do_async_page_fault+0x35/0xa0
[67577.594877]  [<ffffffff81194042>] sys_unlinkat+0x22/0x40
[67577.594883]  [<ffffffff8169d719>] system_call_fastpath+0x16/0x1b
[67577.594886] ---[ end trace 0b7f0b925e0b6048 ]---
[67577.594888] ------------[ cut here ]------------
[67577.594906] WARNING: at /source/fs/btrfs/inode.c:7178 
btrfs_destroy_inode+0x2ef/0x300 [btrfs]()
[67577.594908] Hardware name: Bochs
[67577.594910] Modules linked in: btrfs(O) libcrc32c deflate zlib_deflate 
ctr twofish_generic twofish_x86_64_3way glue_helper lrw xts gf128mul 
twofish_x86_64 twofish_common camellia_generic serpent_generic 
blowfish_generic blowfish_x86_64 blowfish_common cast5_generic des_generic 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm ppdev microcode 
psmouse nfsv4 serio_raw nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc 
parport_pc mac_hid i2c_piix4 lp parport floppy [last unloaded: btrfs]
[67577.594979] Pid: 10692, comm: rm Tainted: G        W  O 3.7.0-560-generic 
#57ba86c00f9573b63b8c06810d4f6915efed2442
[67577.594981] Call Trace:
[67577.594988]  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
[67577.594993]  [<ffffffff81056daa>] warn_slowpath_null+0x1a/0x20
[67577.595012]  [<ffffffffa039b31f>] btrfs_destroy_inode+0x2ef/0x300 [btrfs]
[67577.595017]  [<ffffffff8119e16c>] destroy_inode+0x3c/0x70
[67577.595022]  [<ffffffff8119e2d6>] evict+0x136/0x1d0
[67577.595027]  [<ffffffff8119eb92>] iput_final+0xe2/0x170
[67577.595032]  [<ffffffff8119ec5e>] iput+0x3e/0x50
[67577.595037]  [<ffffffff8119167b>] do_unlinkat+0x12b/0x1d0
[67577.595042]  [<ffffffff81698dde>] ? do_page_fault+0xe/0x10
[67577.595046]  [<ffffffff816984d5>] ? do_async_page_fault+0x35/0xa0
[67577.595051]  [<ffffffff81194042>] sys_unlinkat+0x22/0x40
[67577.595056]  [<ffffffff8169d719>] system_call_fastpath+0x16/0x1b
[67577.595059] ---[ end trace 0b7f0b925e0b6049 ]---

Then, when I delete the subvolume and unmount the file system I also get 
warnings:

# btrfs subvolume delete /mnt/btrfs/SV
Delete subvolume '/mnt/btrfs/SV'
# umount /mnt/btrfs

[67847.557519] ------------[ cut here ]------------
[67847.557550] WARNING: at /source/fs/btrfs/extent-tree.c:4366 
btrfs_free_block_groups+0x2ce/0x370 [btrfs]()
[67847.557553] Hardware name: Bochs
[67847.557554] Modules linked in: btrfs(O) libcrc32c deflate zlib_deflate 
ctr twofish_generic twofish_x86_64_3way glue_helper lrw xts gf128mul 
twofish_x86_64 twofish_common camellia_generic serpent_generic 
blowfish_generic blowfish_x86_64 blowfish_common cast5_generic des_generic 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm ppdev microcode 
psmouse nfsv4 serio_raw nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc 
parport_pc mac_hid i2c_piix4 lp parport floppy [last unloaded: btrfs]
[67847.557614] Pid: 10706, comm: umount Tainted: G        W  O 
3.7.0-560-generic #57ba86c00f9573b63b8c06810d4f6915efed2442
[67847.557616] Call Trace:
[67847.557629]  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
[67847.557635]  [<ffffffff81056daa>] warn_slowpath_null+0x1a/0x20
[67847.557651]  [<ffffffffa037ba2e>] btrfs_free_block_groups+0x2ce/0x370 
[btrfs]
[67847.557669]  [<ffffffffa0388817>] close_ctree+0x1c7/0x310 [btrfs]
[67847.557678]  [<ffffffff8119f07e>] ? evict_inodes+0xce/0x130
[67847.557689]  [<ffffffffa035e6d9>] btrfs_put_super+0x19/0x20 [btrfs]
[67847.557697]  [<ffffffff811863a2>] generic_shutdown_super+0x62/0xf0
[67847.557703]  [<ffffffff811864c6>] kill_anon_super+0x16/0x30
[67847.557714]  [<ffffffffa03625ca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[67847.557720]  [<ffffffff81186a6c>] deactivate_locked_super+0x3c/0x90
[67847.557725]  [<ffffffff8118740e>] deactivate_super+0x4e/0x70
[67847.557730]  [<ffffffff811a3276>] mntput_no_expire+0x106/0x160
[67847.557734]  [<ffffffff811a4836>] sys_umount+0x66/0xe0
[67847.557742]  [<ffffffff8169d719>] system_call_fastpath+0x16/0x1b
[67847.557745] ---[ end trace 0b7f0b925e0b604a ]---
[67847.557747] ------------[ cut here ]------------
[67847.557761] WARNING: at /source/fs/btrfs/extent-tree.c:4367 
btrfs_free_block_groups+0x368/0x370 [btrfs]()
[67847.557763] Hardware name: Bochs
[67847.557765] Modules linked in: btrfs(O) libcrc32c deflate zlib_deflate 
ctr twofish_generic twofish_x86_64_3way glue_helper lrw xts gf128mul 
twofish_x86_64 twofish_common camellia_generic serpent_generic 
blowfish_generic blowfish_x86_64 blowfish_common cast5_generic des_generic 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm ppdev microcode 
psmouse nfsv4 serio_raw nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc 
parport_pc mac_hid i2c_piix4 lp parport floppy [last unloaded: btrfs]
[67847.557803] Pid: 10706, comm: umount Tainted: G        W  O 
3.7.0-560-generic #57ba86c00f9573b63b8c06810d4f6915efed2442
[67847.557805] Call Trace:
[67847.557811]  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
[67847.557816]  [<ffffffff81056daa>] warn_slowpath_null+0x1a/0x20
[67847.557863]  [<ffffffffa037bac8>] btrfs_free_block_groups+0x368/0x370 
[btrfs]
[67847.557883]  [<ffffffffa0388817>] close_ctree+0x1c7/0x310 [btrfs]
[67847.557889]  [<ffffffff8119f07e>] ? evict_inodes+0xce/0x130
[67847.557900]  [<ffffffffa035e6d9>] btrfs_put_super+0x19/0x20 [btrfs]
[67847.557906]  [<ffffffff811863a2>] generic_shutdown_super+0x62/0xf0
[67847.557912]  [<ffffffff811864c6>] kill_anon_super+0x16/0x30
[67847.557923]  [<ffffffffa03625ca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[67847.557929]  [<ffffffff81186a6c>] deactivate_locked_super+0x3c/0x90
[67847.557934]  [<ffffffff8118740e>] deactivate_super+0x4e/0x70
[67847.557938]  [<ffffffff811a3276>] mntput_no_expire+0x106/0x160
[67847.557942]  [<ffffffff811a4836>] sys_umount+0x66/0xe0
[67847.557948]  [<ffffffff8169d719>] system_call_fastpath+0x16/0x1b
[67847.557951] ---[ end trace 0b7f0b925e0b604b ]---
[67847.557954] ------------[ cut here ]------------
[67847.557967] WARNING: at /source/fs/btrfs/extent-tree.c:7659 
btrfs_free_block_groups+0x262/0x370 [btrfs]()
[67847.557969] Hardware name: Bochs
[67847.557970] Modules linked in: btrfs(O) libcrc32c deflate zlib_deflate 
ctr twofish_generic twofish_x86_64_3way glue_helper lrw xts gf128mul 
twofish_x86_64 twofish_common camellia_generic serpent_generic 
blowfish_generic blowfish_x86_64 blowfish_common cast5_generic des_generic 
xcbc rmd160 sha512_generic crypto_null af_key xfrm_algo kvm ppdev microcode 
psmouse nfsv4 serio_raw nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc 
parport_pc mac_hid i2c_piix4 lp parport floppy [last unloaded: btrfs]
[67847.558010] Pid: 10706, comm: umount Tainted: G        W  O 
3.7.0-560-generic #57ba86c00f9573b63b8c06810d4f6915efed2442
[67847.558011] Call Trace:
[67847.558017]  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
[67847.558022]  [<ffffffff81056daa>] warn_slowpath_null+0x1a/0x20
[67847.558035]  [<ffffffffa037b9c2>] btrfs_free_block_groups+0x262/0x370 
[btrfs]
[67847.558050]  [<ffffffffa0388817>] close_ctree+0x1c7/0x310 [btrfs]
[67847.558055]  [<ffffffff8119f07e>] ? evict_inodes+0xce/0x130
[67847.558067]  [<ffffffffa035e6d9>] btrfs_put_super+0x19/0x20 [btrfs]
[67847.558073]  [<ffffffff811863a2>] generic_shutdown_super+0x62/0xf0
[67847.558078]  [<ffffffff811864c6>] kill_anon_super+0x16/0x30
[67847.558089]  [<ffffffffa03625ca>] btrfs_kill_super+0x1a/0x90 [btrfs]
[67847.558095]  [<ffffffff81186a6c>] deactivate_locked_super+0x3c/0x90
[67847.558100]  [<ffffffff8118740e>] deactivate_super+0x4e/0x70
[67847.558104]  [<ffffffff811a3276>] mntput_no_expire+0x106/0x160
[67847.558108]  [<ffffffff811a4836>] sys_umount+0x66/0xe0
[67847.558113]  [<ffffffff8169d719>] system_call_fastpath+0x16/0x1b
[67847.558116] ---[ end trace 0b7f0b925e0b604c ]---
[67847.558119] space_info 4 has 1073647616 free, is not full
[67847.558122] space_info total=1082130432, used=28672, pinned=0, 
reserved=0, may_use=196608, readonly=8454144

Is this an expected behavior? Am I doing anything wrong here?

Thanks,
    -Lev. 

