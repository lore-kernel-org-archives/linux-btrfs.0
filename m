Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47265 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752959AbeF1CKo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Jun 2018 22:10:44 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 1BB21217D0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 22:10:44 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94BBA1028D
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jun 2018 22:10:43 -0400 (EDT)
From: Remi Gauvin <remi@georgianit.com>
Subject: Major design flaw with BTRFS Raid, temporary device drop will corrupt
 nodatacow files
To: linux-btrfs@vger.kernel.org
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
Message-ID: <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
Date: Wed, 27 Jun 2018 22:10:43 -0400
MIME-Version: 1.0
In-Reply-To: <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7mgS7zDPVKcGJEWBhpKZzWhDwTcBSv8JB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7mgS7zDPVKcGJEWBhpKZzWhDwTcBSv8JB
Content-Type: multipart/mixed; boundary="ffNvtPR7TVDbkUDb8tLxpQ1UEF6wXkrwi";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <3cac9d11-27f4-2d1f-c980-09cfeafa6003@georgianit.com>
Subject: Major design flaw with BTRFS Raid, temporary device drop will corrupt
 nodatacow files
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>
In-Reply-To: <5cb96201-e856-e780-7382-dae2ca68f445@gmx.com>

--ffNvtPR7TVDbkUDb8tLxpQ1UEF6wXkrwi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-06-27 09:58 PM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B406=E6=9C=8828=E6=97=A5 09:42, Remi Gauvin wrote:
>> There seems to be a major design flaw with BTRFS that needs to be bett=
er
>> documented, to avoid massive data loss.
>>
>> Tested with Raid 1 on Ubuntu Kernel 4.15
>>
>> The use case being tested was a Virtualbox VDI file created with
>> NODATACOW attribute, (as is often suggested, due to the painful
>> performance penalty of COW on these files.)
>=20
> NODATACOW implies NODATASUM.
>=20

yes yes,, none of which changes the simple fact that if you use this
option, which is often touted as outright necessary for some types of
files, BTRFS raid is worse than useless,, not only will it not protect
your data at all from bitrot, (as expected), it will actively go out of
it's way to corrupt it!

This is not expected behaviour from 'Raid', and I despair that seems to
be something that I have to explain!



--ffNvtPR7TVDbkUDb8tLxpQ1UEF6wXkrwi--

--7mgS7zDPVKcGJEWBhpKZzWhDwTcBSv8JB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJbNEOjAAoJEO9Tn/JHRWptMyQIALyv7o4DjlZq9SZ+VTT2tD4o
GLEgqijCzdNwefkrT3AQTHqAiV1c83tjlNZMYfQzdgVnZRQjI+bzkM2kVApvB9Cv
/OdCfK8wD8LDZpvgRAkTWhEMddT7pHvnzX/cdTfBxcxwzxkhcz1qYFSuEsOT+QLz
R4T/0LHMrPT7SB05c0uGEDb4VAzZsVVpyT9cQ+J4MpFeHjhtIKDiMmK9UtlK3JQ3
BgPCL4tQkNanIjPOU2kJgruh4/kHrcR8ciHlVjYa7CaZN4+pf1XXDTpMwLYNMN2h
/5Dk1tnkgcrZJJXHz19n81wgvHTaDMncoJh1olVUcKVd1kBELcjjy5qhLxJS2Wk=
=fsMK
-----END PGP SIGNATURE-----

--7mgS7zDPVKcGJEWBhpKZzWhDwTcBSv8JB--
