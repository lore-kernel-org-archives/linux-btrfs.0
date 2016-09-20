Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754109AbcITNPP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 09:15:15 -0400
Subject: Re: stat(2) returning device ID not existing in mountinfo
To: Tomasz Sterna <tomek@xiaoka.com>, linux-btrfs@vger.kernel.org
References: <1474057691.16275.16.camel@xiaoka.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <d5df5a17-fb7f-80a2-9308-66fe0e5335f3@suse.com>
Date: Tue, 20 Sep 2016 09:15:10 -0400
MIME-Version: 1.0
In-Reply-To: <1474057691.16275.16.camel@xiaoka.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="GfXrqqpxG1X43FJVSV7wMUEuUqFwQCl6M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GfXrqqpxG1X43FJVSV7wMUEuUqFwQCl6M
Content-Type: multipart/mixed; boundary="eE9jNWI2HE1MKuuJe0IsK0neGFpBvWOSK";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Tomasz Sterna <tomek@xiaoka.com>, linux-btrfs@vger.kernel.org
Message-ID: <d5df5a17-fb7f-80a2-9308-66fe0e5335f3@suse.com>
Subject: Re: stat(2) returning device ID not existing in mountinfo
References: <1474057691.16275.16.camel@xiaoka.com>
In-Reply-To: <1474057691.16275.16.camel@xiaoka.com>

--eE9jNWI2HE1MKuuJe0IsK0neGFpBvWOSK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/16/16 4:28 PM, Tomasz Sterna wrote:
> Hi.
>=20
> I have spotted an issue with stat(2) call on files on btrfs.
> It is giving me dev_t st_dev number that does not correspond to any
> mounted filesystem in proc's mountinfo.

That's by design.  Your particular file system may only use one device
but, internally, btrfs uses virtualized storage that may be spread
across multiple devices.  To make things more complicated, snapshots
mean that:

sled1a:/mnt # btrfs sub list .
ID 257 gen 14 top level 5 path a
ID 258 gen 14 top level 5 path b

sled1a:/mnt # ls -laRi
=2E:
total 16
256 drwxr-xr-x 1 root root   4 Sep 20 09:08 .
256 drwxr-xr-x 1 root root 220 Sep 16 09:49 ..
256 drwxr-xr-x 1 root root   8 Sep 14 10:24 a
256 drwxr-xr-x 1 root root   8 Sep 14 10:24 b

=2E/a:
total 4112
256 drwxr-xr-x 1 root root       8 Sep 14 10:24 .
256 drwxr-xr-x 1 root root       4 Sep 20 09:08 ..
257 -rw-r--r-- 1 root root 4194304 Sep 14 10:24 file

=2E/b:
total 4112
256 drwxr-xr-x 1 root root       8 Sep 14 10:24 .
256 drwxr-xr-x 1 root root       4 Sep 20 09:08 ..
257 -rw-r--r-- 1 root root 4194304 Sep 14 10:24 file

Under normal circumstances those are two files with the same st_dev and
the same inode number.  That would normally correspond to a hard link,
but the files do not (necessarily) correspond to the same file.

=2E.. but because we use anonymous device numbers for each subvolume, we
have different device numbers for each one.

sled1a:/mnt # stat --format "%n st_dev=3D%d" {a,b}/file
a/file st_dev=3D69
b/file st_dev=3D70

It's a pretty big usability wart that we don't consistently report the
device number.  We do it correctly in stat() but there are other places
in the code that assume that inode->i_sb->s_dev will work.  In the SUSE
kernels, we have patches that add a super_operation to report the
correct device number everywhere, but even that is a hack.

> I already attempted a illinformed-patch in fs/btrfs/super.c:
>=20
> @@ -1127,6 +1127,7 @@ static int btrfs_fill_super(struct super_block *s=
b,
>  		goto fail_close;
>  	}
> =20
> +	sb->s_dev =3D inode->i_sb->s_dev;
>  	sb->s_root =3D d_make_root(inode);
>  	if (!sb->s_root) {
>  		err =3D -ENOMEM;
>=20
> but it didn't help.

It wouldn't.  That is assigning a variable to itself.

> I would like to dig deeper and fix it, but first I have to ask:
> - Which number is wrong?
>   The one returned by stat() or the one in mountinfo?

The one in mountinfo, but then that means that the user only sees the
anonymous devices in mount(8), which isn't what we want either.

I'm afraid the correct fix is very involved and requires non-trivial
changes in the VFS layer as well.  It's on my long-term TODO list.  I
currently have some patches that do the magic with vfsmounts but it's
far from being usable.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--eE9jNWI2HE1MKuuJe0IsK0neGFpBvWOSK--

--GfXrqqpxG1X43FJVSV7wMUEuUqFwQCl6M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX4TZeAAoJEB57S2MheeWyz8sP/2DuI5ncXNCoLcrG6+rH21qJ
9iyqxxX5XbDvOqYgNt2DR9wZkSIL/slb5+q/9R5sngnsGhOC9X+NaLrfHmVPX18y
YcepD6Ml3Fjibc1V+PFGMxOgI1K8LAgkzBSfhEZU5kVddX0xEd+NWXuVHXgZ5bpj
zqtYLbB/Aysebjt1KnxGn3LRJJXMsPdRE230Xdh1GgRkIP+YLE0aqHp6QCOjiPYY
WZjjL0vtJW2hFu1AmRrD82q1c7uJWg4tZV2eksF/lfjPBdljEZngkKnUFiwtIe/G
JmaENyLrlf5WhAZeUGMBRbd7U+eVv4NysX8B1tWFFS9HTKEPp22o9FKfwnjQyyj4
DLnogMfYVCAqJgRd5n9zJYX3PEvPmYv1IWGDvsjrMDXxWgKpKf4TFS2VgC01v0+i
/iy//T5atf3qqnBGVhhZDRcom8HKjG0bpsvgTA69kOjv30QpZNOTZj51nBDowEXJ
pxGdSDOM9owdwAVfWpia630IBnwV/52SvLOL/WVU2auKgBQnwiI5V6AnGy4gerdd
rgezq79vgAPvdCJOm+NdCvAsd/5uDXeX96Bzcu4BJdSvYkCZYDI/sgU2o59VcAYK
2piAEB16BYts5mU3vbCwxfSBxP4eN8uxU5VOS3vMCBOCNfwZUhAEYRFOS6I03uyl
Wf5sJqj55E86etkd6PFq
=b9np
-----END PGP SIGNATURE-----

--GfXrqqpxG1X43FJVSV7wMUEuUqFwQCl6M--
