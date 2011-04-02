From: Sergei Trofimovich <slyich@gmail.com>
Subject: Re: 2.6.39-rc1: kernel BUG at fs/btrfs/extent-tree.c:5479!
Date: Sat, 2 Apr 2011 13:41:32 +0300
Message-ID: <20110402134132.0391f4fd@sf.home>
References: <20110402121946.6bf27f80@sf.home>
	<4D96EE76.5040208@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Btlkm/pYNFirU53GZwbRNkr"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	Arne Jansen <sensille@gmx.net>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D96EE76.5040208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Btlkm/pYNFirU53GZwbRNkr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 02 Apr 2011 17:37:58 +0800
liubo <liubo2009@cn.fujitsu.com> wrote:

> On 04/02/2011 05:19 PM, Sergei Trofimovich wrote:
> > The partition is a physical ~5GB --mixed lzo compressed partition.
> >=20
> > The kernel 2.6.39-rc1 + reverted commit c59021f846881a957ac5afe456d0f59=
d6a517b61.
> > (see http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09083.h=
tml)
> >=20
>=20
> Hi, Sergei,
>=20
> I'm digging this...
>=20
> Can u show me steps to reproduce this?

I use the filesystem as a storage of large CVS tree and
as temp storage for large compilations, so I can roughly
describe what I did and when it failed.

I've formatter btrfs 5G partition as --mixed and mounter it with lzo compre=
ssion
on the kernel of version 'v2.6.38-4148-g054cfaa', then checked out there
large CVS tree (~170K files, weights 177MB), copied there linux source (not=
 built)
and copied my '/var/'. I ran compiles there and started to get -ENOSPC
OOpses when 'df -h' reported 3.5G free.

As Linus pulled josef's changes, so I've updated to v2.6.38-6555-ga44f99c
and kernel started to OOps right after mount (added assert started to trigg=
er earlier).
I've reported it to this ML (link above). josef and sensille helped me to d=
ebug what's
going wrong [both CCed]. sensille pointed to the commit, which is guilty to=
 miscomputing
available space. As I understood they know what exactly screwed up.

The second case (this one):
I still use the same filesystem (didn't reformat, so it might carry some co=
rruption
after debugging patches).
I've reverted your change c59021f846881a957ac5afe456d0f59d6a517b61
and made sure it stops OOpsing for me, then updated to 2.6.39-rc1
and reverted only this commit. Filesystem became usable until I've decided
to run large compile on it (clang debug source).

I think at the time of OOps the following things did happen simultaneously:

1. one process was splitting debug symbols of some binary:
  - opened original binary for read
  - write to new file (stripped binary)
  - write debug symbols to separate file

2. another process logged that action to log file

3. the filesystem filled-up and OOpsed. At the time of OOps
   'df -h' showed 200M free.

I'm trying to reproduce this second case ATM (build takes
more, that an hour).

--=20

  Sergei

--Sig_/Btlkm/pYNFirU53GZwbRNkr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2W/V8ACgkQcaHudmEf86qqzwCcD+0eqvRpxfQrdFYURSjE0YS4
6ugAnjE5o+7ayYJD16IttJKD+Y4sbj/J
=mKjq
-----END PGP SIGNATURE-----

--Sig_/Btlkm/pYNFirU53GZwbRNkr--
