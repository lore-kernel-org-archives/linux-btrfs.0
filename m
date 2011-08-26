From: Sergei Trofimovich <slyich@gmail.com>
Subject: autodegrag: WARNING: at fs/inode.c:1315 iput+0x20b/0x210()
Date: Fri, 26 Aug 2011 23:18:44 +0300
Message-ID: <20110826231844.04016b8f@sf.home>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Z1W+m96klzjFgM7ohH4VnVx"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Z1W+m96klzjFgM7ohH4VnVx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I used 3.1.0-rc2+ kernel for some weeks before without any dmesg warnings.
I've decided to enable autodegrag feature for my btrfs / today and got
warning in $SUBJ.

It's an:
> static void iput_final(struct inode *inode)
> ...
> 	WARN_ON(inode->i_state & I_NEW);

Looks scary. Tried latest mainline kernel and got the same warning.
The issue does not seem to appear at once.

How do I reproduce it:
- boot to the kernel
- start Xorg
- run liferea and firefox at once (parallel or just heavy write load?)
- get warnings in dmesg (a ton of them):

Aug 26 23:07:21 sf kernel: [  204.268669] ------------[ cut here ]---------=
---
Aug 26 23:07:21 sf kernel: [  204.268685] WARNING: at fs/inode.c:1315 iput+=
0x20b/0x210()
Aug 26 23:07:21 sf kernel: [  204.268689] Hardware name: HP Compaq 2510p No=
tebook PC
Aug 26 23:07:21 sf kernel: [  204.268692] Modules linked in: ext2 loop kvm_=
intel kvm fuse scsi_wait_scan usb_storage tun sdhci_
pci yenta_socket sdhci pcmcia_core thermal mmc_core iwl4965 iwl_legacy mac8=
0211 pcmcia_rsrc ac fan processor cfg80211 e1000e sn
d_hda_codec_analog rfkill container battery i915 drm_kms_helper drm snd_hda=
_intel i2c_algo_bit snd_hda_codec button snd_hwdep
Aug 26 23:07:21 sf kernel: [  204.268753] Pid: 715, comm: btrfs-cleaner Tai=
nted: G        W   3.1.0-rc3-00202-g96d185c #138
Aug 26 23:07:21 sf kernel: [  204.268758] Call Trace:
Aug 26 23:07:21 sf kernel: [  204.268769]  [<ffffffff8103e7ba>] warn_slowpa=
th_common+0x7a/0xb0
Aug 26 23:07:21 sf kernel: [  204.268776]  [<ffffffff8103e805>] warn_slowpa=
th_null+0x15/0x20
Aug 26 23:07:21 sf kernel: [  204.268781]  [<ffffffff810eafbb>] iput+0x20b/=
0x210
Aug 26 23:07:21 sf kernel: [  204.268789]  [<ffffffff811b990b>] btrfs_iget+=
0x1eb/0x4a0
Aug 26 23:07:21 sf kernel: [  204.268797]  [<ffffffff811c3ce6>] btrfs_run_d=
efrag_inodes+0x136/0x210
Aug 26 23:07:21 sf kernel: [  204.268803]  [<ffffffff811ad76f>] cleaner_kth=
read+0x17f/0x1a0
Aug 26 23:07:21 sf kernel: [  204.268810]  [<ffffffff81035b7d>] ? sub_preem=
pt_count+0x9d/0xd0
Aug 26 23:07:21 sf kernel: [  204.268816]  [<ffffffff811ad5f0>] ? transacti=
on_kthread+0x280/0x280
Aug 26 23:07:21 sf kernel: [  204.268822]  [<ffffffff8105b056>] kthread+0x9=
6/0xa0
Aug 26 23:07:21 sf kernel: [  204.268830]  [<ffffffff81433914>] kernel_thre=
ad_helper+0x4/0x10
Aug 26 23:07:21 sf kernel: [  204.268836]  [<ffffffff8105afc0>] ? kthread_w=
orker_fn+0x190/0x190
Aug 26 23:07:21 sf kernel: [  204.268842]  [<ffffffff81433910>] ? gs_change=
+0xb/0xb
Aug 26 23:07:21 sf kernel: [  204.268846] ---[ end trace 495191005b4af701 ]=
---

Thanks!

--=20

  Sergei

--Sig_/Z1W+m96klzjFgM7ohH4VnVx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5X/6cACgkQcaHudmEf86pKjQCfVF1uV+XCnlPK31f/bgZquufx
5ooAn0WSoogeMZOZDCgj79sy0HU2FCvT
=4YyL
-----END PGP SIGNATURE-----

--Sig_/Z1W+m96klzjFgM7ohH4VnVx--
