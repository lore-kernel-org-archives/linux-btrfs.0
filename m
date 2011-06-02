From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 0/9] some fixes for bugs spotted by valgrind
Date: Fri, 3 Jun 2011 00:13:25 +0300
Message-ID: <20110603001325.4a64b7c3@sf>
References: <1306790348-9553-1-git-send-email-slyfox@gentoo.org>
	<20110531221037.0454f16e@sf>
	<m262oot2bw.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dyzV7lhbJjQj7hWMYcE+kU8"; protocol="application/pgp-signature"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m262oot2bw.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/dyzV7lhbJjQj7hWMYcE+kU8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Jun 2011 13:17:55 -0700
Andi Kleen <andi@firstfloor.org> wrote:

> Sergei Trofimovich <slyfox@gentoo.org> writes:
> >
> > Am I too paranoid about the issue?
>=20
> It sounds weird, because if the kernel would really checksum
> mutexes on disk you would have a lot of on disk
> format incompatibility between different kernel versions
> (e.g. between lockdep and normal kernels or kernels
> running on different architectures)
>
> If it would really happen (no opinion on that) it would
> be a serious bug.

Oh, I don't think things are so bad.

In order it to be a problem superblock loading would have to
be loaded exactly the same way as it's stored, but it isn't.
At least super copies (baked into btrfs_fs_info) are read
to separate data block (buffer_hear) and then copied properly
(in open_ctree) to super_copy/super_for_commit:

        bh =3D btrfs_read_dev_super(fs_devices->latest_bdev);
        if (!bh) {
                err =3D -EINVAL;
                goto fail_alloc;
        }

        memcpy(&fs_info->super_copy, bh->b_data, sizeof(fs_info->super_copy=
));
        memcpy(&fs_info->super_for_commit, &fs_info->super_copy,
               sizeof(fs_info->super_for_commit));
        brelse(bh);

But the way superblocks are written look racy.

--=20

  Sergei

--Sig_/dyzV7lhbJjQj7hWMYcE+kU8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk3n/P8ACgkQcaHudmEf86qncQCgiFjrAkHtyHQKhz5HuqTBhNpM
OCEAnj4kzWMzCfRFS/8njc8ALrSRVPkz
=axn2
-----END PGP SIGNATURE-----

--Sig_/dyzV7lhbJjQj7hWMYcE+kU8--
