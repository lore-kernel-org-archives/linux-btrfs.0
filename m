Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50911 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdFTX65 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 19:58:57 -0400
Date: Tue, 20 Jun 2017 16:58:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: 4.11.3: BTRFS critical (device dm-1): unable to add free space :-17 => btrfs check --repair runs clean
Message-ID: <20170620235840.GC5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk> <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org> <20170620231202.GB5303@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
In-Reply-To: <20170620231202.GB5303@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 20, 2017 at 04:12:03PM -0700, Marc MERLIN wrote:
> Given that check --repair ran clean when I ran it yesterday after this fi=
rst happened,
> and I then ran  mount -o clear_cache , the cache got rebuilt, and I got t=
he problem again,=20
> this is not looking good, seems like a persistent bug :-/
>=20
> I'm now going to remount this with nospace_cache to see if your guess abo=
ut
> space_cache was correct.

Now, it seems that disabling the cache is causing some serious hangs:
[ 2055.473113] INFO: task kworker/u16:17:7579 blocked for more than 120 sec=
onds.
[ 2055.496148]       Tainted: G     U          4.11.6-amd64-preempt-sysrq-2=
0170406 #6
[ 2055.520611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 2055.545675] kworker/u16:17  D    0  7579      2 0x00000080
[ 2055.563626] Workqueue: writeback wb_workfn (flush-btrfs-4)
[ 2055.581458] Call Trace:
[ 2055.590154]  __schedule+0x4ef/0x627
[ 2055.602830]  schedule+0x89/0x9a
[ 2055.613618]  io_schedule+0x16/0x38
[ 2055.625324]  wait_on_page_bit_common+0xd8/0x151
[ 2055.640413]  ? inode_to_bdi+0x35/0x35
[ 2055.653701]  __lock_page+0x40/0x42
[ 2055.665431]  lock_page+0x19/0x1c
[ 2055.676315]  extent_write_cache_pages.constprop.31+0x173/0x368
[ 2055.695049]  ? update_load_avg+0x227/0x3c6
[ 2055.708592]  ? update_load_avg+0x3b1/0x3c6
[ 2055.722340]  ? list_add+0x1a/0x34
[ 2055.733520]  ? cfs_rq_throttled.isra.24+0xd/0x1d
[ 2055.748503]  ? update_cfs_shares+0x2e/0xcf
[ 2055.761891]  extent_writepages+0x5b/0x80
[ 2055.774854]  ? __percpu_counter_compare+0x29/0x72
[ 2055.790054]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 2055.809869]  btrfs_writepages+0x28/0x2a
[ 2055.822516]  do_writepages+0x20/0x29
[ 2055.834251]  __writeback_single_inode+0x8a/0x328
[ 2055.849159]  ? inode_cgwb_enabled+0xd/0x3b
[ 2055.862521]  writeback_sb_inodes+0x22e/0x400
[ 2055.876310]  __writeback_inodes_wb+0x6e/0xb0
[ 2055.890057]  wb_writeback+0x163/0x2ca
[ 2055.902436]  wb_workfn+0x1f7/0x2bf
[ 2055.913520]  ? wb_workfn+0x1f7/0x2bf
[ 2055.925090]  ? __switch_to+0x2c8/0x45f
[ 2055.937184]  process_one_work+0x193/0x2b0
[ 2055.950034]  ? rescuer_thread+0x2b1/0x2b1
[ 2055.962833]  worker_thread+0x1e9/0x2c1
[ 2055.974826]  ? rescuer_thread+0x2b1/0x2b1
[ 2055.988016]  kthread+0xfb/0x100
[ 2055.998183]  ? init_completion+0x24/0x24
[ 2056.010902]  ? do_syscall_64+0x77/0x7d
[ 2056.022802]  ret_from_fork+0x2c/0x40
[ 2056.034224] INFO: task rsync:27554 blocked for more than 120 seconds.
[ 2056.054213]       Tainted: G     U          4.11.6-amd64-preempt-sysrq-2=
0170406 #6
[ 2056.077611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 2056.101705] rsync           D    0 27554  27526 0x20020080
[ 2056.119102] Call Trace:
[ 2056.127019]  __schedule+0x4ef/0x627
[ 2056.138385]  schedule+0x89/0x9a
[ 2056.148616]  io_schedule+0x16/0x38
[ 2056.159682]  wait_on_page_bit_common+0xd8/0x151
[ 2056.173787]  ? inode_to_bdi+0x35/0x35
[ 2056.185336]  __lock_page+0x40/0x42
[ 2056.196176]  lock_page+0x19/0x1c
[ 2056.206420]  extent_write_cache_pages.constprop.31+0x173/0x368
[ 2056.224786]  ? _raw_read_unlock+0xe/0x1e
[ 2056.237221]  ? btrfs_set_lock_blocking_rw+0x9a/0x9d
[ 2056.252388]  extent_writepages+0x5b/0x80
[ 2056.264687]  ? insert_reserved_file_extent.constprop.41+0x28e/0x28e
[ 2056.284051]  btrfs_writepages+0x28/0x2a
[ 2056.296117]  do_writepages+0x20/0x29
[ 2056.307426]  __filemap_fdatawrite_range+0x97/0xc3
[ 2056.322374]  filemap_flush+0x1c/0x1e
[ 2056.333627]  btrfs_rename2+0x894/0xf6f
[ 2056.345376]  ? capable_wrt_inode_uidgid+0x3f/0x4e
[ 2056.359977]  ? generic_permission+0x11e/0x175
[ 2056.373719]  vfs_rename+0x234/0x391
[ 2056.384805]  ? vfs_rename+0x234/0x391
[ 2056.396341]  SYSC_renameat2+0x327/0x448
[ 2056.408349]  SyS_rename+0x1e/0x20
[ 2056.418806]  do_fast_syscall_32+0xb7/0xfe
[ 2056.431325]  entry_SYSENTER_compat+0x4c/0x5b
[ 2056.444642] RIP: 0023:0xf76feb39
[ 2056.454861] RSP: 002b:00000000ffe177bc EFLAGS: 00000292 ORIG_RAX: 000000=
0000000026
[ 2056.478081] RAX: ffffffffffffffda RBX: 00000000ffe18890 RCX: 00000000ffe=
1a890
[ 2056.500019] RDX: 0000000000000001 RSI: 00000000ffe1a890 RDI: 00000000000=
00003
[ 2056.521948] RBP: 00000000ffe177f8 R08: 0000000000000000 R09: 00000000000=
00000
[ 2056.543858] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
00000
[ 2056.565809] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00000


Marc
--=20
"A mouse is a device used to point at the xterm you want to type in" - A.S.=
R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet coo=
king
Home page: http://marc.merlins.org/ =20

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQCVAwUBWUm2sH4xUKZ2O+kBAQL87gP/TGeOFN7b3bd0HY4cpv/GoRe1z0WLIay2
K1hNrW2RBSuKULOYMgMNokQQ+W25FkCorcsr66K9qLCq0Y8uewV+mdpZXEVfhNlD
YE6NCtJ7TZuUWdqkuLZDV6r5kg9TyZFf+5b6TQZL7CZnjpdtCCuyR3jrLUIqqNHJ
FAhfmMgJjuY=
=fr2X
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
