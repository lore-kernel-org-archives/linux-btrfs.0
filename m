Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:32875 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732303AbeGaQNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jul 2018 12:13:01 -0400
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
Date: Tue, 31 Jul 2018 22:32:07 +0800
MIME-Version: 1.0
In-Reply-To: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qsftKa8TBK4gKjX2DukRRNimIYBzd6vwx"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qsftKa8TBK4gKjX2DukRRNimIYBzd6vwx
Content-Type: multipart/mixed; boundary="9IZY7usL5nAvuRVi9Ex4LGJXc1S7QLB9r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Thomas Leister <thomas.leister@mailbox.org>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Message-ID: <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
In-Reply-To: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>

--9IZY7usL5nAvuRVi9Ex4LGJXc1S7QLB9r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8831=E6=97=A5 21:49, Thomas Leister wrote:
> Dear David,
> hello everyone,
>=20
> during a recent project of mine involving LXD and BTRFS I found out tha=
t
> quotas on BTRFS subvolumes are enforced, but file system usage and
> limits set via quotas are not reported correctly in LXC containers.
>=20
> I've found this discussion regarding my problem:
> https://github.com/lxc/lxd/issues/2180

That's not the expected usage of btrfs qgroup/quota.

Quota only accounts how many bytes are used exclusively or shared
between subvolumes at extent level.

>=20
> There was already a proposal to introduce subvolume quota support some
> time ago:
> https://marc.info/?l=3Dlinux-btrfs&m=3D147576434114415&w=3D2

It's in fact impossible if I didn't miss something.

There are several technical problems in the proposal:

1) Multi-level qgroups
   The real limit is limited by all related qgroups, including higher
   level qgroup.
   Such design makes it pretty hard to calculation the real limit.

2) Different limitations on exclusive/shared bytes
   Btrfs can set different limit on exclusive/shared bytes, further
   complicating the problem.

3) Btrfs quota only accounts data/metadata used by the subvolume
   It lacks all the shared trees (mentioned below), and in fact such
   shared tree can be pretty large (especially for extent tree and csum
   tree).
   Only accounting quota limit would hit real ENOSPC easily IMHO.

>=20
> @David as I've seen your response on that topic on the mailing list,
> maybe you can tell me if there are any plans to support correct
> subvolume quota reporting e.g. for "df -h" calls from within a
> container? Maybe there's already something on your / SUSE's roadmap? :-=
)
>=20
> As more and more container environments spin up these days, there might=

> be a growing demand on that :-) Personally I'd really appreciate if I
> could read the current file system usage and limit from within a
> container using BTRFS as storage backend.

For current btrfs design, I think it's skeptical to implement such design=
=2E
The main problem here is, btrfs doesn't do the full LVM work. (unlike
ZFS IIRC)
It doesn't really manage multiple volumes, that's why it's called
subvolume in btrfs.
A subvolume is not a fully usable fs, it's just a subset of a full fs.
It relies on all the other trees (root tree, extent tree, chunk tree,
csum tree, and quota tree in this case) to do all the work.
Thus it's pretty hard to implement such special purposed df call.

On the other hand, isn't easier to implement special interface for
container to get real disk usage/limit other than using the old vanilla
df interface?

Thanks,
Qu

>=20
> Best regards,
> Thomas
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--9IZY7usL5nAvuRVi9Ex4LGJXc1S7QLB9r--

--qsftKa8TBK4gKjX2DukRRNimIYBzd6vwx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltgcugACgkQwj2R86El
/qjkcgf/bqtHlr6DwzDwrABcdl8LAF9PVI7ojHfaYK7isOajgRsNv4ShgyCnqK5+
zsmexy49EZVbEtZBn5WVCC/Z6d8dapLoeGYL60s/LpjXK5lF5Lx1m1nkz+47jPmo
ujOuA1fnZb2taJf21CVs5RixKEKM7q8GaUQSSK3C+RQAfPSJFwIIuMRu5RwsMc44
cLZ1eXLKmj94T21WDmsFJ9Nu1TUif6Z20Yo92yKnxui80sF+GCwnIkqCUIoT+Atp
LBCusdvOUz0kOG+/e2phHrOeaQUHe8g4Y78+Og6kWXdSHSOjshmeunHStzlTJi9l
F+EbaPJiOBrxXx5bPcoMMdIf3/IxUg==
=sjvg
-----END PGP SIGNATURE-----

--qsftKa8TBK4gKjX2DukRRNimIYBzd6vwx--
