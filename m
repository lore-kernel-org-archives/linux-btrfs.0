Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:37587 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbeH1JLs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 05:11:48 -0400
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo <wqu@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
 <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
Date: Tue, 28 Aug 2018 13:21:40 +0800
MIME-Version: 1.0
In-Reply-To: <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tMUtSarByelCkqa2xBmrFj23ozqlCmBt8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tMUtSarByelCkqa2xBmrFj23ozqlCmBt8
Content-Type: multipart/mixed; boundary="Pa713Iq8AWtNb2q4zDxQr5EnBFoBCLVrl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, Qu Wenruo
 <wqu@suse.de>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <4ada2ba5-0ba9-2e59-470d-5284a013d03a@gmx.com>
Subject: Re: [PATCH v2] btrfs: Always check nocow for quota enabled case to
 make sure we won't reserve unnecessary data space
References: <20180821054016.28058-1-wqu@suse.com>
 <afee4b2f-ee0b-8afb-b4d6-1fd8f5958e3a@jp.fujitsu.com>
 <662fd511-708f-5784-18f8-1282830d5730@suse.de>
 <99167e75-351e-ac1d-1a13-97e7717b4a8a@jp.fujitsu.com>
 <2c3f3e97-06db-4bbb-59d9-c2880190a5a5@suse.de>
 <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>
In-Reply-To: <821fe1eb-cade-ed16-5154-b9f8381d0ca4@jp.fujitsu.com>

--Pa713Iq8AWtNb2q4zDxQr5EnBFoBCLVrl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018/8/24 =E4=B8=8B=E5=8D=884:09, Misono Tomohiro wrote:
[snip]
>>
>> BTW, what's the possibility of such problem in your test environment?
>=20
> It's like one in several times.
> It may depend on hardware performance? (the machine is not so fast),
>=20
> I also noticed following warning happens too (not always):
>=20

After digging into the case, it's more complex than just my patch.

Firstly, we lacks a lot of underflow check when modifying bytes_may_use.
So we need to do all the underflow detection for every modifier of
bytes_may_use.

Secondly, btrfs_cross_ref_exist() check makes NODATACOW check in
__btrfs_buffered_write() unreliable.

For the following case, at __btrfs_buffered_write() time we're pretty
sure we could do NODATACOW, but at sync time, due to cloned range,
btrfs_cross_ref_exist() would detect reflinked prealloc extent, then
falls back to CoW, and finally cause bytes_may_use underflow:

---
mkfs.btrfs -f $dev > $full_log

mount $dev $mnt -o nospace_cache
btrfs quota enable $mnt
btrfs quota rescan -w $mnt

xfs_io -f -c "falloc 0 2M" $mnt/file1 > /dev/null
xfs_io -c "pwrite -b 1M 0 1M" $mnt/file1 > /dev/null
xfs_io -c "reflink $mnt/file1 1M 4M 1M" $mnt/file1 > /dev/null
sync
----

Even without my patch, the "pwrite" command is still CoWed, which could
be avoided.
And that's the reason my patch is causing the underflow.

To fix this, we need more accurate btrfs_cross_ref_exist() check, not
only for @disk_bytenr but also check @len.

Or we could try to flush the whole inode in clone_range() so we could go
through NOCOW routine before clone really happens.

Thanks,
Qu


--Pa713Iq8AWtNb2q4zDxQr5EnBFoBCLVrl--

--tMUtSarByelCkqa2xBmrFj23ozqlCmBt8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluE2+QACgkQwj2R86El
/qg/kwgAmqYhRGYgiwL8ngbYCc/S69txQzFPRKBu3tNydtZI0reg8ixETyzlYXr5
o1UdzMmylkuqefsYZ9XsVc8+pF9gwxMc9EiBwq37IyfkYGkHHl39YVXrVI+iNGh0
eD2znjoZc16aL4P2HviNXiiUe2pr5LK1MBecQvzjlGwV81QrauGF059kZSBfoTu3
bjH5j35R6qOXErzoZPalu+9WP75UnptLNvt9eP8OzEGVREe1QcGRVg0kOi7St5Ja
tz3iEMNgjXQMGfEH2YTXDKHpFnmGtBID6QyN0s8XhUBtuVHcF8GYUqnowueqQMyu
vEbBP8TPrEtUZ89G9tQuGRcQbf4olg==
=+D3w
-----END PGP SIGNATURE-----

--tMUtSarByelCkqa2xBmrFj23ozqlCmBt8--
