Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49275 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdKUOfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 09:35:06 -0500
Subject: Re: quotas: failure on removing a file via SFTP/SSH
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
Date: Tue, 21 Nov 2017 22:34:55 +0800
MIME-Version: 1.0
In-Reply-To: <1511270292.1680.35.camel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hUVoNXq9tqwBQ3wW1XPhpoUvN6I1mEoaH"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hUVoNXq9tqwBQ3wW1XPhpoUvN6I1mEoaH
Content-Type: multipart/mixed; boundary="D0FmpAXs8DIrgU7vbFIQALHm3XTr7H7Rb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <09f4e574-8cab-26fd-d7ea-64a0cee2b20b@gmx.com>
Subject: Re: quotas: failure on removing a file via SFTP/SSH
References: <1511266131.1680.27.camel@gmail.com>
 <093ee7e4-91f1-7d23-1ef1-81230d07b405@gmx.com>
 <1511270292.1680.35.camel@gmail.com>
In-Reply-To: <1511270292.1680.35.camel@gmail.com>

--D0FmpAXs8DIrgU7vbFIQALHm3XTr7H7Rb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 21:18, ST wrote:
>=20
>=20
>=20
> On Tue, 2017-11-21 at 20:28 +0800, Qu Wenruo wrote:
>>
>> On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 20:08, ST wrote:
>>> Hello,
>>>
>>> I'm trying to use quotas for a simple chrooted sftp setup, limiting
>>> space for each user's subvolume (now for testing to 1M).
>>>
>>> I tried to hit the limit by uploading files and once it comes to the
>>> limit I face following problem: if I try to free space by removing a
>>> file via Linux sftp client (or Filezilla) - I get error:
>>> "Couldn't delete file: Failure"
>>>
>>> Sometimes, but not always, if I repeat it for 3-5 times it does remov=
es
>>> the file at the end.
>>> If I login as root and try to remove the file via SSH I get the error=
:
>>> "rm: cannot remove 'example.txt': Disk quota exceeded"
>>>
>>> What is the problem? And how can I solve it?
>>
>> Kernel version first.
>>
>> If it's possible, please use latest kernel, at least newer than v4.10,=

>> since we have a lot of qgroup reservation related fixes in newer kerne=
l.
>>
>> Then, for small quota, due to the nature of btrfs metadata CoW and
>> relative large default node size (16K), it's quite easy to hit disk
>> quota for metadata.
>=20
> Yes, but why I get the error specifically on REMOVING a file? Even if I=

> hit disk quota - if I free up space - it should be possible, isn't it?

It's only true for fs modifying its metadata in-place (and use journal
to protect it).

For fs using metadata CoW, even freeing space needs extra space for new
metadata.

Thanks,
Qu

>=20
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>=20


--D0FmpAXs8DIrgU7vbFIQALHm3XTr7H7Rb--

--hUVoNXq9tqwBQ3wW1XPhpoUvN6I1mEoaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloUOY8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgqAwf/TC9H0D7Fg3DZEli42TxjUDt7
FfweSYdG0lTs1jjS4RmcsmCZU85hpYUWRB9JGLI/ntKrOEZa9xxpI9/c5XJaJckZ
yStc+HCiTQ5M6movYPFZ03uSVo9OLu/GG0Uqx0iVorE/DTz8pGMPedemUgPKgXTX
0MniQwPHuV0CGl84w1NRONREjnJChnastHYyF5xBuidAnu+iWUHwwa8+wMBP9Tvc
ENFVO7ApJJn3EUCecUdQYr+TCe8F+iV+wG1np2uEY0l93crHdU5/jBSuwwfdbuJb
Dusm91N9a7q1ohE2NIrjBwTdhlB6N7o2FfUYWdnrAgoP8MBoHVMGkI+CpekR2A==
=tSGY
-----END PGP SIGNATURE-----

--hUVoNXq9tqwBQ3wW1XPhpoUvN6I1mEoaH--
