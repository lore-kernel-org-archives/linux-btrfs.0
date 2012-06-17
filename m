Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.ru ([50.31.253.214]:45352 "EHLO rin.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456Ab2FQP3S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 11:29:18 -0400
Date: Sun, 17 Jun 2012 21:29:08 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: dave@jikos.cz
Cc: linux-btrfs@vger.kernel.org, sensille@gmx.net, chris.mason@fusionio.com
Subject: Re: Massive metadata size increase after upgrade from 3.2.18 to
 3.4.1
Message-ID: <20120617212908.4fcfd19c@natsu>
In-Reply-To: <20120614113316.GR32402@twin.jikos.cz>
References: <20120609013822.6b06a008@natsu>
	<20120614113316.GR32402@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wt8YSaBl0_mvkwcYT5KfIiq"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/wt8YSaBl0_mvkwcYT5KfIiq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Jun 2012 13:33:16 +0200
David Sterba <dave@jikos.cz> wrote:

> On Sat, Jun 09, 2012 at 01:38:22AM +0600, Roman Mamedov wrote:
> > Before the upgrade (on 3.2.18):
> >=20
> > Metadata, DUP: total=3D9.38GB, used=3D5.94GB
> >=20
> > After the FS has been mounted once with 3.4.1:
> >=20
> > Data: total=3D3.44TB, used=3D2.67TB
> > System, DUP: total=3D8.00MB, used=3D412.00KB
> > System: total=3D4.00MB, used=3D0.00
> > Metadata, DUP: total=3D84.38GB, used=3D5.94GB
> >=20
> > Where did my 75 GB of free space just went?
>=20
> This is caused by the patch (credits for bisecting it go to Arne)
>=20
> commit cf1d72c9ceec391d34c48724da57282e97f01122
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Fri Jan 6 15:41:34 2012 -0500
>=20
>     Btrfs: lower the bar for chunk allocation
>=20
>     The chunk allocation code has tried to keep a pretty tight lid on cre=
ating new
>     metadata chunks.  This is partially because in the past the reservati=
on
>     code didn't give us an accurate idea of how much space was being used.
>=20
>     The new code is much more accurate, so we're able to get rid of some =
of these
>     checks.
> ---
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3263,27 +3263,12 @@ static int should_alloc_chunk(struct btrfs_root *=
root,
>                 if (num_bytes - num_allocated < thresh)
>                         return 1;
>         }
> -
> -       /*
> -        * we have two similar checks here, one based on percentage
> -        * and once based on a hard number of 256MB.  The idea
> -        * is that if we have a good amount of free
> -        * room, don't allocate a chunk.  A good mount is
> -        * less than 80% utilized of the chunks we have allocated,
> -        * or more than 256MB free
> -        */
> -       if (num_allocated + alloc_bytes + 256 * 1024 * 1024 < num_bytes)
> -               return 0;
> -
> -       if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
> -               return 0;
> -
>         thresh =3D btrfs_super_total_bytes(root->fs_info->super_copy);
>=20
> -       /* 256MB or 5% of the FS */
> -       thresh =3D max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, =
5));
> +       /* 256MB or 2% of the FS */
> +       thresh =3D max_t(u64, 256 * 1024 * 1024, div_factor_fine(thresh, =
2));
>=20
> -       if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_byte=
s, 3))
> +       if (num_bytes > thresh && sinfo->bytes_used < div_factor(num_byte=
s, 8))
>                 return 0;
>         return 1;
>  }
> ---
>=20
> Originally there were 2 types of check, based on +256M and on
> percentage. The former are removed which leaves only the percentage
> thresholds. If there's less than 2% of the fs of metadata actually used,
> the metadata are reserved exactly to 2%. When acutual usage goes over
> 2%, there's always at least 20% over-reservation,
>=20
>    sinfo->bytes_used < div_factor(num_bytes, 8)
>=20
> ie the threshold is 80%, which may be wasteful for large fs.
>=20
> So, the metadata chunks are immediately pinned to 2% of the filesystem
> after first few writes, and this is what you observe.
>=20
> Running balance will remove the unused metadata chunks, but only to the
> 2% level.
>=20
> [end of analysis]
>=20
> So what to do now? Simply reverting the +256M checks works and restores
> more or less the original behaviour.


Thanks.
So should I try restoring both of these, and leave the rest as is?

> -       if (num_allocated + alloc_bytes + 256 * 1024 * 1024 < num_bytes)
> -               return 0;
> -
> -       if (num_allocated + alloc_bytes < div_factor(num_bytes, 8))
> -               return 0;

Or would it make more sense to try rolling back that patch completely?

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/wt8YSaBl0_mvkwcYT5KfIiq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/d98QACgkQTLKSvz+PZwhHCwCffHvZhkjGZP72Os35ELix8c9O
1UAAoIVYJHXdl68Efs03zC9kSeZnUO2Y
=2f0L
-----END PGP SIGNATURE-----

--Sig_/wt8YSaBl0_mvkwcYT5KfIiq--
