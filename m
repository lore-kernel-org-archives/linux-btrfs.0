From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: autodegrag: WARNING: at fs/inode.c:1315 iput+0x20b/0x210()
Date: Mon, 29 Aug 2011 22:19:53 +0300
Message-ID: <20110829221953.7abf4d23@sf>
References: <20110826231844.04016b8f@sf.home>
	<20110827171546.43929e96@sf.home>
	<20110828114925.4e619c5c@sf>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FaVSlbatn9kN0Y6g4gfeKbl"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110828114925.4e619c5c@sf>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/FaVSlbatn9kN0Y6g4gfeKbl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > [  282.380849] ------------[ cut here ]------------
> > [  282.380865] WARNING: at fs/inode.c:1315 iput+0x20b/0x210()
> > [  282.380869] Hardware name: HP Compaq 2510p Notebook PC
> > [  282.380873] Modules linked in: ext2 loop kvm_intel kvm fuse scsi_wai=
t_scan usb_storage tun i915 drm_kms_helper drm yenta_socket sdhci_pci sdhci=
 snd_hda_codec_analog iwl4965 mmc_core i2c_algo_bit pcmcia_core thermal con=
tainer ac button fan battery e1000e iwl_legacy mac80211 snd_hda_intel cfg80=
211 snd_hda_codec pcmcia_rsrc processor rfkill snd_hwdep
> > [  282.380932] Pid: 715, comm: btrfs-cleaner Not tainted 3.1.0-rc3-0020=
3-gdbf2e46 #139
> > [  282.380936] Call Trace:
> > [  282.380947]  [<ffffffff8103e7ba>] warn_slowpath_common+0x7a/0xb0
> > [  282.380954]  [<ffffffff8103e805>] warn_slowpath_null+0x15/0x20
> > [  282.380960]  [<ffffffff810eafbb>] iput+0x20b/0x210
> > [  282.380967]  [<ffffffff811b990b>] btrfs_iget+0x1eb/0x4a0
> > [  282.380975]  [<ffffffff811c3ce6>] btrfs_run_defrag_inodes+0x136/0x210
> > [  282.380982]  [<ffffffff811ad76f>] cleaner_kthread+0x17f/0x1a0
> > [  282.380988]  [<ffffffff81035b7d>] ? sub_preempt_count+0x9d/0xd0
> > [  282.380994]  [<ffffffff811ad5f0>] ? transaction_kthread+0x280/0x280
> > [  282.381001]  [<ffffffff8105b056>] kthread+0x96/0xa0
> > [  282.381027]  [<ffffffff81433914>] kernel_thread_helper+0x4/0x10
> > [  282.381034]  [<ffffffff8105afc0>] ? kthread_worker_fn+0x190/0x190
> > [  282.381039]  [<ffffffff81433910>] ? gs_change+0xb/0xb
> > [  282.381044] ---[ end trace 40720e359a3c0fea ]---
>=20
> Konstantin's patch
>=20
>     [PATCH] btrfs: fix warning in iput for bad-inode
>=20
> fixed the issue.

Actually, not quite. Busy spin popped up as described in:

    http://www.spinics.net/lists/linux-btrfs/msg12156.html

--=20

  Sergei

--Sig_/FaVSlbatn9kN0Y6g4gfeKbl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5b5l4ACgkQcaHudmEf86r19ACfcVlQ6vvPeBVcbCkCyAfcmZrA
PP0AnRmT30nyzTRUj4aG9twHNR9x2eck
=e4Lu
-----END PGP SIGNATURE-----

--Sig_/FaVSlbatn9kN0Y6g4gfeKbl--
