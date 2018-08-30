Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33203 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbeH3FYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 01:24:04 -0400
Subject: Re: How to erase a RAID1 ?
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
Date: Thu, 30 Aug 2018 09:24:15 +0800
MIME-Version: 1.0
In-Reply-To: <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KJo3x1PYIfD2E1ry4OF6AmOMLpMD4w7xp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KJo3x1PYIfD2E1ry4OF6AmOMLpMD4w7xp
Content-Type: multipart/mixed; boundary="cklUpX2zXE8UNDe319rcvl1EzPFbPsH9p";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Pierre Couderc <pierre@couderc.eu>, linux-btrfs@vger.kernel.org
Message-ID: <f77df1e6-8030-716b-fc95-81ef3ae4f173@gmx.com>
Subject: Re: How to erase a RAID1 ?
References: <04e4b43f-b21e-b6fd-dfad-0506ff35aff7@couderc.eu>
 <52b06c19-c9e2-29c1-b761-98d770c2d6c7@gmx.com>
 <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>
In-Reply-To: <2e47e913-104e-8d0c-8d49-69518681147b@couderc.eu>

--cklUpX2zXE8UNDe319rcvl1EzPFbPsH9p
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

[Forgot to Cc the list]

On 2018/8/29 =E4=B8=8B=E5=8D=8810:04, Pierre Couderc wrote:
>
> On 08/29/2018 02:52 PM, Qu Wenruo wrote:
>>
>> On 2018/8/29 =E4=B8=8B=E5=8D=888:49, Pierre Couderc wrote:
>>> I want to reinstall a RAID1 btrfs system (wchis is now under debian
>>> stretch, and will be reinstalled in stretch).
>> If you still want to use btrfs, just umount the original fs, and
>>
>> # mkfs.btrfs -f <old devices>
>>
>> Then a completely new btrfs.
>>
> The problem is to "unmount" the RAID1 system..

If it's not the root fs, it could be unmount if there is no user
reading/writing or has any opened file.

>
> I have not found how to do that.
>
> I have found a solution by reinstalling under debian, it now asks if
> need to reformat thez btrfs disk...

If it's root fs, either go booting from another device, or just let the
installer (well, it's booting from memory/another device already) to
re-format the fs.

Thanks,
Qu

>



--cklUpX2zXE8UNDe319rcvl1EzPFbPsH9p--

--KJo3x1PYIfD2E1ry4OF6AmOMLpMD4w7xp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluHR0AACgkQwj2R86El
/qjbcgf/ZIilsOXnOTekzghq/l++unJRvaLeXgF2ie9bb2eThBUYAGkO/zRMRw+a
PbjJYmEQtkoX1sszZd/TrZ0BmkHdv0mELYq6lYPgnt80/0kgNoGslhfkqq4ZMH08
GBQVTOiCDyIa94kJSytzRmMk2EKAS/oTKtJZAez0URLqwNrXB8wRpnI3oK/jxb9d
DjSDRC0RWlj/gHAmDHmJ0wwdOyEWnnqtpSLm7VUFMcK4Xpy8fBTSDOppH0kvdpJC
BK9TwdWIZkmTQf9QNdh/cNoUhGQqWxM58Bo8C11mO1C9uUaqAzogiSws4gIYY6Zb
M3jC3VyPuc5j3/qQTPbqxtzYqnE96g==
=Nw9g
-----END PGP SIGNATURE-----

--KJo3x1PYIfD2E1ry4OF6AmOMLpMD4w7xp--
