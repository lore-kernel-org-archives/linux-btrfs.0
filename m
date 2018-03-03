Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33891 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935762AbeCCCqP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 21:46:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ACB5EAD2C
        for <linux-btrfs@vger.kernel.org>; Sat,  3 Mar 2018 02:46:14 +0000 (UTC)
Subject: Re: [PATCH 1/8] btrfs-progs: quota: Add -W option to rescan to wait
 without starting rescan
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-2-jeffm@suse.com>
 <f4e6dff0-c0c7-2e3b-d33b-11a6390ab6dd@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <a4b0898c-c20e-4418-0ab3-6c8c8d5e0e60@suse.com>
Date: Fri, 2 Mar 2018 21:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <f4e6dff0-c0c7-2e3b-d33b-11a6390ab6dd@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lX6qPkrl3q4e2CObMvT4atx8mke25YRAM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lX6qPkrl3q4e2CObMvT4atx8mke25YRAM
Content-Type: multipart/mixed; boundary="tcKH44VCndzKJISkkQMrLARNxVHI1gkXk";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <a4b0898c-c20e-4418-0ab3-6c8c8d5e0e60@suse.com>
Subject: Re: [PATCH 1/8] btrfs-progs: quota: Add -W option to rescan to wait
 without starting rescan
References: <20180302184704.22399-1-jeffm@suse.com>
 <20180302184704.22399-2-jeffm@suse.com>
 <f4e6dff0-c0c7-2e3b-d33b-11a6390ab6dd@suse.com>
In-Reply-To: <f4e6dff0-c0c7-2e3b-d33b-11a6390ab6dd@suse.com>

--tcKH44VCndzKJISkkQMrLARNxVHI1gkXk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 3/2/18 1:59 PM, Nikolay Borisov wrote:
>=20
>=20
> On  2.03.2018 20:46, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>> @@ -135,8 +141,9 @@ static int cmd_quota_rescan(int argc, char **argv)=

>>  		}
>>  	}
>> =20
>> -	if (ioctlnum !=3D BTRFS_IOC_QUOTA_RESCAN && wait_for_completion) {
>> -		error("switch -w cannot be used with -s");
>> +	if (ioctlnum =3D=3D BTRFS_IOC_QUOTA_RESCAN_STATUS && wait_for_comple=
tion) {
>> +		error("switch -%c cannot be used with -s",
>> +		      ioctlnum ? 'w' : 'W');
>=20
> You can't really distinguish between w/W in this context, since ioctlnu=
m
> will be RESCAN_STATUS. So just harcode the w/W in the text message itse=
lf?

Yep.  Derp.

Thanks,

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--tcKH44VCndzKJISkkQMrLARNxVHI1gkXk--

--lX6qPkrl3q4e2CObMvT4atx8mke25YRAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlqaDHYACgkQHntLYyF5
5bLn7RAAk29t3dQO0eN/nfmbuuwSK24YPzMWRf3OOF+AdRG4CNQaBbk5saG8sH/F
Hxx+ZZ9msmb19A8HEOwjXVjhfFIvA8MeEqLW+s4NJFbqKRqQDM6RjV5f7ornx6gU
OcH2RxdxMS4VygZZJ7VT0Q/xMakkZhpsW4BeO85h5aY6TWZqk+mZXeyjgOM1xKec
2dNwGdXv+G2czH9438QxA5ppBX6Jw4mSMq+FGv3LC0D/Q71nuvpZybf17mn1oqRJ
vAjYAkDPpIhwFPno5CP77Y/Q9G2/jLN0ipnndL2cebWAPMKVJdfESVDpNpFnCHIu
ZvUsniJO6NBmjOXK+MtLk79RioUsp4e+XLVvlLmNuNAOsD7qtSccHPwT+8PlE9F0
RlU4MxbWhw0UEWS7NrN+GTUlmnx9Nd5X41YX7JB/l9vhhgp7UIgPj3waL+8dD3xK
sXd1KbraW+UFZ+VpH++gfI/YIswHkmxd3WAxvQHOo229un7nbWp4nNRBgst1DRdv
kI0zvyP60iTj5VeBXBnQXcmKAAFc6YRF2KmlZ+acRvD5iXVMrIknQBy6D0HXkLPq
6L9JvSQYv0hpuwWzyrfoWKf3W2MAfSj2/M/EZaMwCZF4HBguFkp+0l2Nrd2rWISD
6mwFJRjb9G4+SxThBrbbgdh8XTanBI0vzlBX15qwNxqZgdLHohY=
=APVw
-----END PGP SIGNATURE-----

--lX6qPkrl3q4e2CObMvT4atx8mke25YRAM--
