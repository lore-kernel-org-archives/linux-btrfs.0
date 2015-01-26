Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39169 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751532AbbAZEm7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Jan 2015 23:42:59 -0500
Date: Sun, 25 Jan 2015 23:42:59 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.19-rc5: Bug 91911: [REGRESSION] rm command hangs big time with
 deleting a lot of files at once
Message-ID: <20150126044259.GD15935@hungrycats.org>
References: <2506104.3YBgc9qdaM@merkaba>
 <pan.2015.01.23.14.38.09@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rqzD5py0kzyFAOWN"
In-Reply-To: <pan.2015.01.23.14.38.09@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2015 at 02:38:09PM +0000, Holger Hoffst=E4tte wrote:
> On Fri, 23 Jan 2015 15:01:28 +0100, Martin Steigerwald wrote:
>=20
> > Hi!
> >=20
> > Anyone seen this?
> >=20
> > Reported as:
> >=20
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D91911
>=20
> You might be interested in:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/=
?h=3Devict-softlockup&id=3D29249e14d6e3379a5c4bb098dd4beddfefbc606f
>=20
> and
>=20
> https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/=
?h=3Devict-softlockup&id=3De4a58b71ff981b098ac3371f4d573dc6a90006ce
>
> I'm sure everyone would love to hear how this works out for you ;-)

I merged both commits and I've been running with them since Friday.
Several softlockups since then, in unlinkat() and renameat2().
Some typical stacks:

[<ffffffff81386214>] ? free_extent_state.part.29+0x34/0xb0
[<ffffffff81386715>] ? free_extent_state+0x25/0x30
[<ffffffff81386e6a>] ? __set_extent_bit+0x3aa/0x4f0
[<ffffffff8185de02>] ? _raw_spin_unlock_irqrestore+0x32/0x70
[<ffffffff8109ec61>] ? get_parent_ip+0x11/0x50
[<ffffffff8185a2d9>] schedule+0x29/0x70
[<ffffffff81387dc0>] lock_extent_bits+0x1b0/0x200
[<ffffffff810b4df0>] ? add_wait_queue+0x60/0x60
[<ffffffff81375e99>] btrfs_evict_inode+0x139/0x550
[<ffffffff8120d708>] evict+0xb8/0x190
[<ffffffff8120dec5>] iput+0x105/0x1a0
[<ffffffff812001d9>] do_unlinkat+0x189/0x2d0
[<ffffffff811f775a>] ? SyS_newlstat+0x2a/0x40
[<ffffffff814a52ce>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[<ffffffff81202e26>] SyS_unlink+0x16/0x20
[<ffffffff8185e96d>] system_call_fastpath+0x1a/0x1f

Note that the above stack is _very_ typical.  I've caught machines
with well over 100 processes stuck in "D" state with an identical stack
trace from "btrfs_evict_inode" to "system_call_fastpath".

[<ffffffff81390100>] lock_extent_bits+0x1b0/0x200                          =
                                                                           =
         =20
[<ffffffff8137e0aa>] btrfs_evict_inode+0x12a/0x540                         =
                                                                           =
         =20
[<ffffffff81214978>] evict+0xb8/0x190                                      =
                                                                           =
         =20
[<ffffffff81215135>] iput+0x105/0x1a0                                      =
                                                                           =
         =20
[<ffffffff81210cb0>] __dentry_kill+0x190/0x200                             =
                                                                           =
         =20
[<ffffffff812112ba>] dput+0xba/0x190                                       =
                                                                           =
         =20
[<ffffffff8120a8b0>] SyS_renameat2+0x510/0x580                             =
                                                                           =
         =20
[<ffffffff8120a95e>] SyS_rename+0x1e/0x20                                  =
                                                                           =
         =20
[<ffffffff818711ad>] system_call_fastpath+0x16/0x1b                        =
                                                                           =
         =20
[<ffffffffffffffff>] 0xffffffffffffffff                                    =
                                                                           =
         =20

The above is a typical renameat2() softlockup stack.

[<ffffffff81179888>] wait_on_page_bit+0xb8/0xc0
[<ffffffff8118e584>] shrink_page_list+0x8c4/0xb20
[<ffffffff8118edcd>] shrink_inactive_list+0x19d/0x500
[<ffffffff8118fa7d>] shrink_lruvec+0x59d/0x760
[<ffffffff8118fcc3>] shrink_zone+0x83/0x1c0
[<ffffffff811903de>] do_try_to_free_pages+0x16e/0x460
[<ffffffff8119080e>] try_to_free_mem_cgroup_pages+0x9e/0x180
[<ffffffff811e393e>] mem_cgroup_reclaim+0x4e/0xe0
[<ffffffff811e48ad>] try_charge+0x15d/0x500
[<ffffffff811e729d>] mem_cgroup_try_charge+0x8d/0x1a0
[<ffffffff8117997f>] __add_to_page_cache_locked+0x8f/0x280
[<ffffffff81179b98>] add_to_page_cache_lru+0x28/0x80
[<ffffffff8117a08b>] pagecache_get_page+0xab/0x1d0
[<ffffffffc02fb5a4>] alloc_extent_buffer+0xe4/0x380 [btrfs]
[<ffffffffc02d228f>] btrfs_find_create_tree_block+0x1f/0x30 [btrfs]
[<ffffffffc02d238f>] readahead_tree_block+0x1f/0x60 [btrfs]
[<ffffffffc02ac9b0>] reada_for_balance+0x160/0x1e0 [btrfs]
[<ffffffffc02b4f57>] btrfs_search_slot+0x687/0xac0 [btrfs]
[<ffffffffc02ceddf>] btrfs_lookup_inode+0x2f/0xa0 [btrfs]
[<ffffffffc032ee25>] __btrfs_update_delayed_inode+0x65/0x210 [btrfs]
[<ffffffffc03303ea>] btrfs_commit_inode_delayed_inode+0x13a/0x150 [btrfs]
[<ffffffffc02e52ba>] btrfs_evict_inode+0x2ca/0x520 [btrfs]
[<ffffffff8120d838>] evict+0xb8/0x190
[<ffffffff8120dff5>] iput+0x105/0x1a0
[<ffffffff81209bd8>] __dentry_kill+0x1b8/0x210
[<ffffffff8120a31a>] dput+0xba/0x190
[<ffffffff812037d0>] SyS_renameat2+0x440/0x530
[<ffffffff812038fe>] SyS_rename+0x1e/0x20
[<ffffffff817a836d>] system_call_fastpath+0x1a/0x1f
[<ffffffffffffffff>] 0xffffffffffffffff

The last one is a little older (from 3.17.4) but it's a bit more
interesting.  Since mem cgroups were involved, I allocated a lot more
RAM to the cgroup and it seems to have helped reduce the frequency of
this bug occurring.


>=20
> -h
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--rqzD5py0kzyFAOWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlTFxdMACgkQgfmLGlazG5xPhQCfeBSKnqzuRy/HKpwQZH809dcR
UzsAoJPdukdkFsrKn9iPHuujR41m5DHI
=ZuXy
-----END PGP SIGNATURE-----

--rqzD5py0kzyFAOWN--
