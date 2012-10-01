Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:38397 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2JAG2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 02:28:36 -0400
Received: from natsu (unknown [IPv6:fd14:8086:1337:1:1e6f:65ff:fea1:3ea6])
	by len.romanrm.net (Postfix) with ESMTPS id 7DA682055B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 06:28:34 +0000 (UTC)
Date: Mon, 1 Oct 2012 12:28:32 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: block rsv returned -28 during balance
Message-ID: <20121001122832.53c25596@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k=r4YIUh2V=TmadKv7Oi=39"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/k=r4YIUh2V=TmadKv7Oi=39
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On a 3.6.0-rc7 kernel, I launched:

  # btrfs fi balance start -f -mconvert=3Dsingle /mnt/tmp/

Current situation:

# df -h /mnt/tmp/
Filesystem             Size  Used Avail Use% Mounted on
/dev/mapper/alpha-lv1  3.6T  2.7T  801G  78% /mnt/tmp

# btrfs fi df /mnt/tmp/
Data: total=3D3.00TB, used=3D2.66TB
System: total=3D4.00MB, used=3D364.00KB
Metadata, DUP: total=3D11.00GB, used=3D5.72GB
Metadata: total=3D63.00GB, used=3D0.00

There seems to be plenty of free space, but the balance seems to have stall=
ed
and the dmesg is being filled with messages like this:

[ 2926.465406] btrfs: block rsv returned -28
[ 2926.465411] ------------[ cut here ]------------
[ 2926.465446] WARNING: at /home/apw/COD/linux/fs/btrfs/extent-tree.c:6323 =
use_block_rsv+0x19f/0x1b0 [btrfs]()
[ 2926.465450] Hardware name: VirtualBox
[ 2926.465452] Modules linked in: joydev microcode parport_pc hid_generic p=
arport psmouse serio_raw pcspkr i2c_piix4 mac_hid xfs btrfs libcrc32c zlib_=
deflate raid456 async_raid6_recov async_memcpy async_pq async_xor xor async=
_tx raid6_pq usbhid hid e1000
[ 2926.465517] Pid: 4682, comm: btrfs Tainted: G        W    3.6.0-030600rc=
7-generic #201209232235
[ 2926.465520] Call Trace:
[ 2926.465532]  [<ffffffff81056fff>] warn_slowpath_common+0x7f/0xc0
[ 2926.465539]  [<ffffffff8105705a>] warn_slowpath_null+0x1a/0x20
[ 2926.465569]  [<ffffffffa00c4edf>] use_block_rsv+0x19f/0x1b0 [btrfs]
[ 2926.465599]  [<ffffffffa00c860d>] btrfs_alloc_free_block+0x3d/0x220 [btr=
fs]
[ 2926.465625]  [<ffffffffa00b45b4>] ? __btrfs_cow_block+0x324/0x4f0 [btrfs]
[ 2926.465663]  [<ffffffffa00f516c>] ? read_extent_buffer+0xbc/0x120 [btrfs]
[ 2926.465689]  [<ffffffffa00b5dfc>] ? comp_keys+0x2c/0x30 [btrfs]
[ 2926.465715]  [<ffffffffa00b43b2>] __btrfs_cow_block+0x122/0x4f0 [btrfs]
[ 2926.465745]  [<ffffffffa00cfff0>] ? verify_parent_transid+0x170/0x170 [b=
trfs]
[ 2926.465771]  [<ffffffffa00b487c>] btrfs_cow_block+0xfc/0x220 [btrfs]
[ 2926.465808]  [<ffffffffa0117c6f>] do_relocation+0x46f/0x560 [btrfs]
[ 2926.465815]  [<ffffffff8169e85e>] ? _raw_spin_lock+0xe/0x20
[ 2926.465842]  [<ffffffffa00bc90b>] ? block_rsv_add_bytes+0x5b/0x80 [btrfs]
[ 2926.465878]  [<ffffffffa0117fa4>] relocate_tree_block+0x244/0x280 [btrfs]
[ 2926.465914]  [<ffffffffa011be73>] relocate_tree_blocks+0x123/0x1a0 [btrf=
s]
[ 2926.465950]  [<ffffffffa011ccba>] relocate_block_group+0x1fa/0x560 [btrf=
s]
[ 2926.466009]  [<ffffffffa011d1df>] btrfs_relocate_block_group+0x1bf/0x2f0=
 [btrfs]
[ 2926.466049]  [<ffffffffa00f83a6>] btrfs_relocate_chunk.isra.53+0x56/0x3b=
0 [btrfs]
[ 2926.466086]  [<ffffffffa00eeda9>] ? release_extent_buffer.isra.37+0x39/0=
x60 [btrfs]
[ 2926.466092]  [<ffffffff8169e85e>] ? _raw_spin_lock+0xe/0x20
[ 2926.466128]  [<ffffffffa00f43b7>] ? free_extent_buffer+0x37/0x90 [btrfs]
[ 2926.466164]  [<ffffffffa00fc602>] __btrfs_balance+0x302/0x3e0 [btrfs]
[ 2926.466201]  [<ffffffffa00fc9d5>] btrfs_balance+0x2f5/0x4d0 [btrfs]
[ 2926.466238]  [<ffffffffa0104e74>] btrfs_ioctl_balance+0x114/0x440 [btrfs]
[ 2926.466275]  [<ffffffffa0106938>] btrfs_ioctl+0x428/0x950 [btrfs]
[ 2926.466282]  [<ffffffff8115a7b6>] ? do_brk+0x226/0x300
[ 2926.466290]  [<ffffffff8119878a>] do_vfs_ioctl+0x8a/0x340
[ 2926.466297]  [<ffffffff81198ad1>] sys_ioctl+0x91/0xa0
[ 2926.466304]  [<ffffffff816a70ad>] system_call_fastpath+0x1a/0x1f
[ 2926.466308] ---[ end trace 37b1b50f9306e0b3 ]---


--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/k=r4YIUh2V=TmadKv7Oi=39
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBpOBAACgkQTLKSvz+PZwgpeQCeLfW5JMaHFN82FykyiFv9gOy4
kk4An28VegVIcrN6jtWoh7i9h4V5dnGk
=G89j
-----END PGP SIGNATURE-----

--Sig_/k=r4YIUh2V=TmadKv7Oi=39--
