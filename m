Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58051 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728334AbeISPK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 11:10:59 -0400
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
To: Tomasz Chmielewski <tch@virtall.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <090849f6-dbd2-999f-d215-0c82553a00cd@gmx.com>
Date: Wed, 19 Sep 2018 17:33:43 +0800
MIME-Version: 1.0
In-Reply-To: <e0f21dace16885d1bd615dd723235d57@virtall.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AVw4UkXB7eBR19l70Yp68yVxb38dt4Od0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AVw4UkXB7eBR19l70Yp68yVxb38dt4Od0
Content-Type: multipart/mixed; boundary="UifoVllNB5c8uZOgrW4ApbiIjbovXPnIL";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Chmielewski <tch@virtall.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <090849f6-dbd2-999f-d215-0c82553a00cd@gmx.com>
Subject: Re: very poor performance / a lot of writes to disk with space_cache
 (but not with space_cache=v2)
References: <e0f21dace16885d1bd615dd723235d57@virtall.com>
In-Reply-To: <e0f21dace16885d1bd615dd723235d57@virtall.com>

--UifoVllNB5c8uZOgrW4ApbiIjbovXPnIL
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/19 =E4=B8=8B=E5=8D=884:43, Tomasz Chmielewski wrote:
> I have a mysql slave which writes to a RAID-1 btrfs filesystem (with
> 4.17.14 kernel) on 3 x ~1.9 TB SSD disks; filesystem is around 40% full=
=2E

This sounds a little concerning.
Not about the the usage percentage itself. but the size and how many
free space cache could be updated for each transaction.

Detail will follow below.

>=20
> The slave receives around 0.5-1 MB/s of data from the master over the
> network, which is then saved to MySQL's relay log and executed. In idea=
l
> conditions (i.e. no filesystem overhead) we should expect some 1-3 MB/s=

> of data written to disk.
>=20
> MySQL directory and files in it are chattr +C (since the directory was
> created, so all files are really +C); there are no snapshots.

Not familiar with space cache nor MySQL workload, but at least we don't
need to bother extra data CoW.

>=20
>=20
> Now, an interesting thing.
>=20
> When the filesystem is mounted with these options in fstab:
>=20
> defaults,noatime,discard
>=20
>=20
> We can see a *constant* write of 25-100 MB/s to each disk. The system i=
s
> generally unresponsive and it sometimes takes long seconds for a simple=

> command executed in bash to return.

The main concern here is how many metadata block groups are involved in
one transaction.

=46rom my observation, although free space cache files (v1 space cache)
are marked NODATACOW, they in fact get updated in a COW behavior.

This means if there are say 100 metadata block groups get updated, then
we need to write around 12M data just for space cache.

On the other than, if we fix v1 space cache to really do NODATACOW, then
it should hugely reduce the IO for free space cache

>=20
>=20
> However, as soon as we remount the filesystem with space_cache=3Dv2 -
> writes drop to just around 3-10 MB/s to each disk. If we remount to
> space_cache - lots of writes, system unresponsive. Again remount to
> space_cache=3Dv2 - low writes, system responsive.

Have you tried nospace_cache? I think it should behavior a little worse
than v2 space cache but much better than the *broken* v1 space cache.

And for v2 space cache, it's already based on btrfs btree, which get
CoWed like all other btrfs btrees, thus no need to update the whole
space cache for each metadata block group. (Although in theory, the
overhead should still be larger than *working* v1 cache)

Thanks,
Qu

>=20
>=20
> That's a huuge, 10x overhead! Is it expected? Especially that
> space_cache=3Dv1 is still the default mount option?
>=20
>=20
> Tomasz Chmielewski
> https://lxadm.com


--UifoVllNB5c8uZOgrW4ApbiIjbovXPnIL--

--AVw4UkXB7eBR19l70Yp68yVxb38dt4Od0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluiF/cACgkQwj2R86El
/qjTswf/U3e6ifsFxgXxY6qT1UG+JFQ9Emf9tT0vnsujXS6AGiU7hD7ua5+S6zxn
sonqFP4lRxpgcKrh7W5qZKlrNBkJhlQMyIj+7EcJjtSlBihlGgVVV4mQ6f2kttPH
NT0JSje75bt4Dm91Ge7cZkLJyVkqPoYFG+UC2HOLp6Sb59X5ri27XMKGfgZremJT
gT33Oh1Gk5zGrv6KM5BrU8uJr53KgdAp3F/syPfd6s24VVAgJsPUirTGizj65qdQ
6Ab9OJVXJZDbaO7RfmjCW7bnrq/kJML7UfL2Vkk/iNTKP8QJvpUGUlM+xjct2UY5
Gdc8egJCIldCasez/yfqNIdrOBPlrQ==
=62dH
-----END PGP SIGNATURE-----

--AVw4UkXB7eBR19l70Yp68yVxb38dt4Od0--
