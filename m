Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59713 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751562AbdKMEh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 Nov 2017 23:37:57 -0500
Subject: Re: btrfs check lowmem vs original
To: Chris Murphy <chris@colorremedies.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
 <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
 <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com>
 <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
 <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
 <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <90b045d0-deb8-ba66-0a43-fa373e630279@gmx.com>
Date: Mon, 13 Nov 2017 12:37:49 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bw1gfami1RtjuoAf3EKmQoxsoTihfMB01"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bw1gfami1RtjuoAf3EKmQoxsoTihfMB01
Content-Type: multipart/mixed; boundary="evvRVnqku6OJI83JNj9nkv2wMUsAVb3QT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <chris@colorremedies.com>, Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <90b045d0-deb8-ba66-0a43-fa373e630279@gmx.com>
Subject: Re: btrfs check lowmem vs original
References: <CAJCQCtQ-WkNShYNGi9hk8s7M_RdLGHV3Jw0zArt_W-uzYQ9BAg@mail.gmail.com>
 <6ee63ff7-6a0c-7828-0751-5769d59bb85f@cn.fujitsu.com>
 <CAJCQCtTdfD6=xWttk5D4JqLpzG9ZMxb-c=GopZPPNsLP6eHHpw@mail.gmail.com>
 <aea6f1e7-7621-a32a-9cce-2e37357f4b82@cn.fujitsu.com>
 <CAJCQCtSDHdytGS51uLAuS9Ki7_CDKsy2x9OpPUmvwYpQ7iRrLQ@mail.gmail.com>
 <69cc700e-5597-594c-cfb7-8f8a0c2a544e@cn.fujitsu.com>
 <CAJCQCtTpuXQPaogXYyVqz=A_3AV9+wwu711aKqgY0wj1QA2bdg@mail.gmail.com>
 <f4bc7f4a-d11c-6887-f148-286c1f0e7cd2@cn.fujitsu.com>
 <CAJCQCtTYDGRoMsqbCCz0tFF86_PT73wUDezfOGGYn2LXZyz2CQ@mail.gmail.com>
 <923a9714-c7fb-cb1e-6753-71caffeb0657@cn.fujitsu.com>
 <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>
In-Reply-To: <CAJCQCtRzxu8-QaZ+VLJLskMkOe=Sw4vdA-dJ7e-WCbrpRWtU9A@mail.gmail.com>

--evvRVnqku6OJI83JNj9nkv2wMUsAVb3QT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8813=E6=97=A5 11:37, Chris Murphy wrote:
> On Sun, Nov 12, 2017 at 7:25 PM, Su Yue <suy.fnst@cn.fujitsu.com> wrote=
:
>=20
>>
>> I have some patches for lowmem mode. But they are not fully tested and=

>> unstable.
>> It will be so nice if you can provide some images.
>=20
> Sorry, Qu got the image offline, I wasn't paying attention that btrfs
> list wasn't cc'd.  The -ss option was taking too long and during the
> imaging a systemd unit mounted the file system so I figured the image
> might be useless or contain extra confusion.
>=20
> Here is the -s image I send to Qu.
>=20
> https://drive.google.com/open?id=3D1cIAANqMicIMp9NfgnvN_SA90kjM0kP0C

Patches for backref lost false warning Cced to you.

Since the reason is clear and test case added, I think it should solve
the "backref lost" false alerts.

However for BUG_ON(), it's tree walk code who can't handle tree reloc
tree, this may be a little complex compared to backref lost.
But since it's a different story, I'll send the fix as another patch(set)=
=2E


The final bug about backref counts mismatch, without the image I'm not
really sure what's going on.

(But extent tree verification is really buggy though)

Thanks,
Qu


--evvRVnqku6OJI83JNj9nkv2wMUsAVb3QT--

--Bw1gfami1RtjuoAf3EKmQoxsoTihfMB01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloJIZ0XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi92Af9H8kNMdnYk+94cGOmcPlxvJ0M
8U1Mj822qg/aKkobJqqUlb/i8YaoD5M05cOKmKuHHlwM8nY32nifJ2UkxhdAJdgI
pktLKmPTh9vQqIKS6ObIaaqVxw4soHQ3JBgQ9ovV7EqgXqK3vg2lIVPU7+IygqZe
AtCOQ4biP+qPuBm2ETPqcN7RsCxVePf+7/FTXH4TBY10GyQ6XnocDzcVcJCHhp/M
r2BRMlBoyZijiukM14k5XFYYyyeCax75DigTkwBkvN2P8KUxVNZg/4w1v0jsK5Qo
TjOoBPqWurQQDMrpDeGR3RRPHrBf+V9bjWjpjiCLfl1B/4n09N4YFn8+SGmRPg==
=oqc4
-----END PGP SIGNATURE-----

--Bw1gfami1RtjuoAf3EKmQoxsoTihfMB01--
