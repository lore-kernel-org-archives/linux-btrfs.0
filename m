From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: hang on 'echo 3 > /proc/sys/vm/drop_caches'
Date: Sun, 4 Sep 2011 19:26:59 +0300
Message-ID: <20110904192659.31acb393@sf.home>
References: <20110904181723.4ad1a3e6@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VspYAi386zWeiOXStPWOCt1"; protocol="application/pgp-signature"
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110904181723.4ad1a3e6@sf.home>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VspYAi386zWeiOXStPWOCt1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Sep 2011 18:17:23 +0300
Sergei Trofimovich <slyich@gmail.com> wrote:

> Short prehistory.
> I've noticed worrying dmesg message today:
>     [26258.950593] btrfs csum failed ino 5360433 off 262144 csum 39955560=
63 private 3831717007
>=20
> 'find / -inum 5360433' helped me to find the file out:
>     /usr/lib64/libasound.so.2.0.0
> I didn't modify it since 18.08.2011
>=20
> I've tried to verify file's checksum against one stored in
> package database and found out file is not corrupted.
>=20
> So the error is an HDD glitch (or some memory corruption in btrfs code?)
>=20
> I've attempted to drop caches and got a hangup:
>     # echo 3 > /proc/sys/vm/drop_caches
>=20
> And now the bash process eats 100% CPU.

After seemingly clean reboot (/sbin/reboot didn't hang, rebooted fine)
I've got corrupted filesystem (or it was corrupted earlier, but I didn't
notice):

[   39.410962] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Contr=
ol: Rx/Tx
[   39.410972] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[  112.639689] BUG: sleeping function called from invalid context at mm/slu=
b.c:1004
[  112.639697] in_atomic(): 1, irqs_disabled(): 0, pid: 2224, name: mc
[  112.639703] 2 locks held by mc/2224:
[  112.639707]  #0:  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<ffffffff81=
0ecb99>] do_lookup+0x239/0x380
[  112.639729]  #1:  (#12){++++..}, at: [<ffffffff811f5cc0>] btrfs_clear_lo=
ck_blocking_rw+0x30/0xc0
[  112.639750] Pid: 2224, comm: mc Not tainted 3.1.0-rc4-00082-g26e254e #150
[  112.639754] Call Trace:
[  112.639765]  [<ffffffff8103424f>] __might_sleep+0xef/0x120
[  112.639773]  [<ffffffff810d8753>] kmem_cache_alloc+0xc3/0xe0
[  112.639781]  [<ffffffff811e3317>] alloc_extent_state+0x17/0x60
[  112.639789]  [<ffffffff811e5467>] set_extent_bit+0x3a7/0x5f0
[  112.639797]  [<ffffffff8109db5e>] ? wait_on_page_bit+0x6e/0x80
[  112.639805]  [<ffffffff811e5820>] lock_extent_bits+0x80/0xb0
[  112.639814]  [<ffffffff811c0862>] verify_parent_transid+0x82/0x160
[  112.639821]  [<ffffffff811c0a9b>] btrfs_buffer_uptodate+0x4b/0x70
[  112.639830]  [<ffffffff811a7874>] read_block_for_search+0x164/0x3e0
[  112.639837]  [<ffffffff811a7095>] ? generic_bin_search+0xf5/0x180
[  112.639846]  [<ffffffff811ad47e>] btrfs_search_slot+0x35e/0x890
[  112.639852]  [<ffffffff810347e1>] ? get_parent_ip+0x11/0x50
[  112.639860]  [<ffffffff811bf30a>] btrfs_lookup_inode+0x2a/0xa0
[  112.639868]  [<ffffffff811ce7c8>] btrfs_iget+0x118/0x4a0
[  112.639876]  [<ffffffff81455ff0>] ? _raw_spin_unlock+0x30/0x60
[  112.639884]  [<ffffffff811d4b83>] btrfs_lookup_dentry+0x4a3/0x4f0
[  112.639891]  [<ffffffff810f6400>] ? d_validate+0x60/0xb0
[  112.639898]  [<ffffffff81454356>] ? mutex_lock_nested+0x2a6/0x3a0
[  112.639905]  [<ffffffff811d4be1>] btrfs_lookup+0x11/0x30
[  112.639913]  [<ffffffff810ec10c>] d_inode_lookup+0x1c/0x50
[  112.639920]  [<ffffffff810ecc59>] do_lookup+0x2f9/0x380
[  112.639928]  [<ffffffff810ee704>] path_lookupat+0x144/0x750
[  112.639936]  [<ffffffff810b7d8e>] ? might_fault+0x4e/0xa0
[  112.639944]  [<ffffffff810eed3e>] do_path_lookup+0x2e/0x80
[  112.639951]  [<ffffffff810eee64>] user_path_at+0x54/0xa0
[  112.639960]  [<ffffffff81100323>] ? vfsmount_lock_local_unlock+0x43/0x70
[  112.639967]  [<ffffffff810e6273>] ? cp_new_stat+0xf3/0x110
[  112.639974]  [<ffffffff810e6107>] vfs_fstatat+0x47/0x80
[  112.639981]  [<ffffffff810e6159>] vfs_lstat+0x19/0x20
[  112.639988]  [<ffffffff810e62ff>] sys_newlstat+0x1f/0x50
[  112.639995]  [<ffffffff81255f0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  112.640047]  [<ffffffff81456afb>] system_call_fastpath+0x16/0x1b
[  112.640196] parent transid verify failed on 167391232 wanted 23923 found=
 38663
[  112.640253] parent transid verify failed on 167391232 wanted 23923 found=
 38663
[  112.640276] parent transid verify failed on 167391232 wanted 23923 found=
 38663

and now getting OOpses after short period of work. btrfsck reports missing =
blocks.

--=20

  Sergei

--Sig_/VspYAi386zWeiOXStPWOCt1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5jptYACgkQcaHudmEf86qJGgCfQeB5Nu9z+Tn4Te/guzIo0TU2
HeQAn0zkAFj3hS3P6uwdsYUQZiNMHxSU
=ZHlk
-----END PGP SIGNATURE-----

--Sig_/VspYAi386zWeiOXStPWOCt1--
