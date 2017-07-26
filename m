Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38396 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750898AbdGZNWn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 09:22:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 93D70AB1E
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 13:22:42 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-5-jeffm@suse.com>
 <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>
Date: Wed, 26 Jul 2017 09:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5OJSSQ4mPsAEhefeiV0mSGMdm6d1sR10r"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5OJSSQ4mPsAEhefeiV0mSGMdm6d1sR10r
Content-Type: multipart/mixed; boundary="ngDVjQBRWTt5dccQlKkDTdX7FnN7Na1bw";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <bf9d2dae-4291-2dad-9101-f5fb18215699@suse.com>
Subject: Re: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-5-jeffm@suse.com>
 <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
In-Reply-To: <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>

--ngDVjQBRWTt5dccQlKkDTdX7FnN7Na1bw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 7/26/17 3:08 AM, Nikolay Borisov wrote:
>=20
>=20
> On 25.07.2017 23:51, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> ---
>>  backref.c | 11 +++++++----
>>  1 file changed, 7 insertions(+), 4 deletions(-)
>>
>> diff --git a/backref.c b/backref.c
>> index ac1b506..be3376a 100644
>> --- a/backref.c
>> +++ b/backref.c
>> @@ -130,6 +130,11 @@ struct __prelim_ref {
>>  	u64 wanted_disk_byte;
>>  };
>> =20
>> +static struct __prelim_ref *list_first_pref(struct list_head *head)
>> +{
>> +	return list_first_entry(head, struct __prelim_ref, list);
>> +}
>> +
>=20
> I think this just adds one more level of abstraction with no real
> benefit whatsoever. Why not drop the patch entirely.

Ack.  I thought it might be more readable but it ends up taking the same
number of characters.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--ngDVjQBRWTt5dccQlKkDTdX7FnN7Na1bw--

--5OJSSQ4mPsAEhefeiV0mSGMdm6d1sR10r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2

iQIVAwUBWXiXoB57S2MheeWyAQjOzQ//Zf2IWnMfFi9oAhPbj+wxZ9FP/RG1s60z
ubiK2Irm0X1S0FEAneKJMa58W4bVxnKfAi/pKsO8VSMX6H/R1Nu7pRsg6CIr/J5K
QaGV+7hRhjJ/dZrzqO4cV9cFPLZuqLDYbEmc90uJDuRXP9HZLXr9waSEVFf7z17r
1TRMYdECn1eqgMqNhZs2ySWg3vdya9F68Nbz6NRRTlVz8vKyyPgRTTomJVGBpO/3
59iPJqGhottQoFydTeSFpzlgnksbwjE7MNjUs0kJ5ZU3ZFyXV4qWtWoftf4oyVrV
KO/54Bv9EhcMrm9zbGcsOeXVAEaPL42kGQ+eQ85N5mbebfiOna+9opnZ3vHTWekz
hJlYhjyj6q6ahL1old0phaAzhDkqr0G/UCUvcp5hoe8amzPk3c+VcbJtgSGGhrAi
fbyYotVyn02O9xsciGj2s07k0ADgRGKZvTTy0w8DTr0b6Mg1z9MA82OVkIJVeC6P
P+aK76S5N2UoyRXYHuOE/gQvAsZX+3l/ANAnxdeIRoeK9puSwG+JVNGgn7w9FBPV
MfUX5Po5c/NSYQv9Yns1XflzXu+NOO8H4G5KPT271ILFq1rvoRQg4MszkCTrxqEX
D4Q/eoKb3erHZTM8LcpPYaoYsHaEHfvFhdJkTSriMMLEF+DOXUDNuf3oAZuu5MnF
XFnCYSXF/8Y=
=F3Lu
-----END PGP SIGNATURE-----

--5OJSSQ4mPsAEhefeiV0mSGMdm6d1sR10r--
