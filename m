From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Suddenly, a dead filesystem
Date: Tue, 23 Aug 2011 15:27:27 +0100
Message-ID: <20110823142727.GB4172@carfax.org.uk>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E39vaYmALEf/7YXx"
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi.kivity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--E39vaYmALEf/7YXx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 23, 2011 at 05:15:46PM +0300, Avi Kivity wrote:
> I've been using btrfs for a while as my /home (converted from ext4;
> encrypted lvm) when it died on me. =A0Mounting it crashes immediately,
> here's a log:
[...]
> [ =A0 =A06.456117] Call Trace:
> [ =A0 =A06.456117] =A0[<ffffffffa005646e>] add_inode_ref+0x2e6/0x37c [btr=
fs]
> [ =A0 =A06.456117] =A0[<ffffffffa00493f6>] ? read_extent_buffer+0xc3/0xe3=
 [btrfs]
> [ =A0 =A06.456117] =A0[<ffffffffa0056e14>] replay_one_buffer+0x197/0x212 =
[btrfs]
> [ =A0 =A06.456117] =A0[<ffffffffa0054e94>] walk_down_log_tree+0x15a/0x2c1=
 [btrfs]
> [ =A0 =A06.456117] =A0[<ffffffffa005507a>] walk_log_tree+0x7f/0x19e [btrf=
s]
> [ =A0 =A06.456117] =A0[<ffffffff8123a8d9>] ? radix_tree_lookup+0xb/0xd
> [ =A0 =A06.456117] =A0[<ffffffffa0058148>] btrfs_recover_log_trees+0x28b/=
0x298 [btrfs]
> [ =A0 =A06.456117] =A0[<ffffffffa0056c7d>] ? replay_one_dir_item+0xbd/0xb=
d [btrfs]
> [ =A0 =A06.456117] =A0[<ffffffffa002a192>] open_ctree+0x10f1/0x13ff [btrf=
s]
[...]
> Tried btrfsck, immediate segfault.

   Yes, it does that,I'm afraid. (It also doesn't fix anything).

> Both kernel and btrfsprogs are stock Fedora 15. =A0I still have the
> logical volume and would like to recover it. =A0Its fairly easy to try
> out things in a virtual machine, so if you have a patch you want me to
> try out, I'm here.

   It looks like you've got a corrupt log tree. The quick and easy fix
for that is on the wiki in the problem FAQ page [1].

   Could you give a bit more information about what happened in the
crash immediately prior to the FS being unmountable, and how your
storage is configured?

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_=
filesystem.2C_and_I_get_a_kernel_oops.21

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- You stay in the theatre because you're afraid of having no ---   =20
                         money? There's irony...                        =20

--E39vaYmALEf/7YXx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOU7jPIKyzvlFcI40RAph3AKDD5tZoLxMR6bKAj+izjQ+i0VuwPQCffo0F
HkExLlCTtyM+YQ6UjOLBowE=
=S8E5
-----END PGP SIGNATURE-----

--E39vaYmALEf/7YXx--
