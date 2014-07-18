Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-d06.mx.aol.com ([205.188.109.203]:65461 "EHLO
	omr-d06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761303AbaGRJgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 05:36:46 -0400
Message-ID: <53C8E900.7070302@aol.de>
Date: Fri, 18 Jul 2014 11:29:36 +0200
From: Karl-Philipp Richter <krichter722@aol.de>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Assertion `!(exist->nmirrors >= 2)' failed
References: <53A9809C.30705@aol.de> <1403659201.22912.2.camel@localhost.localdomain>
In-Reply-To: <1403659201.22912.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="U1IVvd0lI8i69X0Tx0hGRcmtb1iKgHUEp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U1IVvd0lI8i69X0Tx0hGRcmtb1iKgHUEp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Gui,
I'm getting back at this a bit late, but I could now run `btrfsck
--repair` with btrfs-progs 24cf4d8c3ee924b474f68514e0167cc2e602a48d on
Linux 3.16-rc5 in an Oracle VirtualBox VM with Ubuntu 14.04. It doesn't
suceed yet, but at least I'm not getting immediate errors.

Best regards,
Karl

Am 25.06.2014 03:20, schrieb Gui Hecheng:
> On Tue, 2014-06-24 at 15:43 +0200, Karl-Philipp Richter wrote:
>> Hi together,
>> I wondered whether
>>
>>     $ sudo btrfs rescue chunk-recover -y /dev/loop2p1
>>     btrfs: chunk-recover.c:124: process_extent_buffer: Assertion
>> `!(exist->nmirrors >=3D 2)' failed.
>>     $ echo $?
>>     134
>=20
> Hi, Karl
> For the Assertion above, this one below may do a help.
> https://patchwork.kernel.org/patch/4339091/
>=20
> -Gui
>=20
>> is an error in btrfs or an error message of (the correctly working)
>> btrfs. Any ideas what this could mean? I'm having this trouble with a
>> system which is so messed up that I even can't restore
>>
>>     $ sudo btrfs restore /dev/loop2p1 /mnt/data_extension/restore
>>     parent transid verify failed on 1068982272 wanted 47618 found 4757=
5
>>     parent transid verify failed on 1068982272 wanted 47618 found 4757=
5
>>     parent transid verify failed on 1068982272 wanted 47618 found 4757=
5
>>     parent transid verify failed on 1068982272 wanted 47618 found 4757=
5
>>     Ignoring transid failure
>>     leaf parent key incorrect 1068982272
>>     Couldn't setup extent tree
>>     parent transid verify failed on 1068982272 wanted 47618 found 4757=
5
>>     Ignoring transid failure
>>     leaf parent key incorrect 1068982272
>>     Couldn't read fs root: -1
>>
>> I'm issueing the command because it seems to be the last thing I can d=
o
>> to rescue any data of that partition.
>>
>> This occurs with v3.12 (output of `btrfs --version`) as well as the
>> latest commit 24cf4d8c3ee924b474f68514e0167cc2e602a48d of btrfs-progs.=

>>
>> Best regards,
>> Kalle Richter
>>
>=20
>=20


--U1IVvd0lI8i69X0Tx0hGRcmtb1iKgHUEp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTyOkAAAoJEGadKJ8eJ7ZG5GAIAJpNXh70ypL1HKNyWnzqmf4Y
XusKCJv/3dmZtXJ/Ddrei22m7aHzZ4WAy2G9jQesxtKnYU19LgYT7cGt7dHTZdHa
gGP3dUAhMIvQEabJ9cOfK3rjy1hcWS/ku4SrNoTLcwPAoxtMXhVJzDww7aObWF0A
YxuWL6hMhCOMqQC5waWf19GovfAKVrjmWEA3/uPgjtal4W89MCvOXTlp2PEpHlM0
7zxnFevyUPClsLrYluNCa2MmenbqjPka1DMeKpFHqePRbPFTS2QF0Q6cVWMSaR0O
ak5AQ2AabuTeYX4JAr4KoOA0SC6kfDpnmYWzN5tXO9NNyGJSfi1nzH1KckIOK3w=
=bYzV
-----END PGP SIGNATURE-----

--U1IVvd0lI8i69X0Tx0hGRcmtb1iKgHUEp--
