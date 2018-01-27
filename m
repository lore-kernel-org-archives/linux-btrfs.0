Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57112 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbeA0FBN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 00:01:13 -0500
Subject: Re: [PATCH 11/26] libbtrfsutil: add btrfs_util_create_snapshot()
To: Omar Sandoval <osandov@osandov.com>, kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
 <4c742933-cc46-d93f-da34-5914296f2c8a@libero.it>
 <20180126194633.GA19033@vader.DHCP.thefacebook.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <06676a54-ee0c-45b9-007c-5747cdc02aa4@gmx.com>
Date: Sat, 27 Jan 2018 13:00:58 +0800
MIME-Version: 1.0
In-Reply-To: <20180126194633.GA19033@vader.DHCP.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gK3sgopJ7YDKJskcInhgrSebl51u9NR91"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gK3sgopJ7YDKJskcInhgrSebl51u9NR91
Content-Type: multipart/mixed; boundary="nGneKmylsKegq3Qf83wjSoSKDz05SN8v8";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Omar Sandoval <osandov@osandov.com>, kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Message-ID: <06676a54-ee0c-45b9-007c-5747cdc02aa4@gmx.com>
Subject: Re: [PATCH 11/26] libbtrfsutil: add btrfs_util_create_snapshot()
References: <cover.1516991902.git.osandov@fb.com>
 <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
 <4c742933-cc46-d93f-da34-5914296f2c8a@libero.it>
 <20180126194633.GA19033@vader.DHCP.thefacebook.com>
In-Reply-To: <20180126194633.GA19033@vader.DHCP.thefacebook.com>

--nGneKmylsKegq3Qf83wjSoSKDz05SN8v8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8827=E6=97=A5 03:46, Omar Sandoval wrote:
> On Fri, Jan 26, 2018 at 08:31:06PM +0100, Goffredo Baroncelli wrote:
>> On 01/26/2018 07:40 PM, Omar Sandoval wrote:
>>> From: Omar Sandoval <osandov@fb.com>
>>
>>
>> Hi,
>>
>> this is a great work; only few comments:
>> 1) I found not intuitive the naming of the function: i.e. you have=20
>>
>> btrfs_util_create_snapshot()
>> btrfs_util_f_create_snapshot()
>>
>> To me it seems more clear to have
>>
>> btrfs_util_create_snapshot()
>> btrfs_util_create_snapshot_f()
>>
>> I think that it is better move the 'f' at the end: at the begin you ha=
ve the library "btrfs_util", in the middle you have the library function =
'create_snapshot', at the end there is the function variant ('f', because=
 it uses a file descriptor).
>>
>> This is my opinion, even tough there are both examples like you (stat/=
fstat/lstat) and like my one (capt_get_fd/cap_get_file)...
>=20
> Yup, I was going off of the fstat/fsync/etc. convention. I don't
> particularly like, e.g., btrfs_create_snapshot_f(), but
> btrfs_create_snapshot_fd() isn't so bad.

_fd() suffix sounds more reasonable to me too.

>=20
>> 2) I find the prefix 'btrfs_util_' a bit verbose. Why not a simple 'bt=
rfs_', even at the cost of a possible renaming of the conflicting functio=
n in the current btrfs code.
>=20
> That's a reasonable idea, I mostly wanted to avoid naming conflicts but=

> if this is the "one true Btrfs library" it shouldn't be a concern.

Unfortunately, at least there is also some planned work to bring a
shared code base between kernel and btrfs-progs, which is also named
libbtrfs, inspired by libxfs.

And depending on the respect of view, some developer may prefer the
short btrfs_ prefix for libbtrfs, while other developers/users will
definitely prefer btrfs_ prefix for libbtrfsutil.

What about shorted prefix like butil_ or btrutil_?

Thanks,
Qu

>=20
> I'll wait a bit for people to bikeshed on the naming before I go and
> rename everything, but I'm leaning towards the shorter name and
> appending _fd instead of prepending f_.
>=20
>> 3) regarding the btrfs_util_create_snapshot() function, I think that i=
t would be useful to add some more information:
>> a) if used recursive is NOT atomic
>> b) if used recursive, root capabilities are needed
>>
>> The same for the other functions: mark with a 'root required' tag all =
the functions which require the root capabilities.
>=20
> That's a great point, I'll document that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--nGneKmylsKegq3Qf83wjSoSKDz05SN8v8--

--gK3sgopJ7YDKJskcInhgrSebl51u9NR91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpsB4sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjdRwf+IPGxpPluxR1ua3GbLh5jWxZ5
WfQ/dxa3W/JNnzQurqXdsxotpCzK4HQDfIt3qICirBNXuTcqB4ojmGtERLGO31Xd
dSug0Gnw2kpEJ5WWtOp0DhAIsRrZZaA9ymd+N19JJ6gjpKe4t+QQK2lQgPuHNvtO
YXiyBqdlfQ0fHeIKnhYo154ACtdHBfX+BR2jrZrDVHwSx2fBrBD2AU5aUlSKqJTL
pQHCMOZcOPJT4xIR4wGIIcMspjBZBAruApsmlSKnwSb7e/5P7LQgTZgJeuCIgXwy
S2HfuaP8fkHdSvm9lFtAAjy99QhU4l9sy0Pz/9Gu5ni2OqAEji4uNfOugXBBQA==
=dtzL
-----END PGP SIGNATURE-----

--gK3sgopJ7YDKJskcInhgrSebl51u9NR91--
