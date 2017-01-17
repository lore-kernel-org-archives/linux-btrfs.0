Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdAQW5b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 17:57:31 -0500
Subject: Re: Unocorrectable errors with RAID1
To: Christoph Groth <christoph@grothesque.org>
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
Cc: linux-btrfs@vger.kernel.org
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <e7412986-d0bd-d0e3-b268-d3aede1cc80b@suse.de>
Date: Tue, 17 Jan 2017 16:57:21 -0600
MIME-Version: 1.0
In-Reply-To: <87lgu9cu2v.fsf@grothesque.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="MXHB42Wve4SVBXXTxCjVsWQkVwc1Frsph"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MXHB42Wve4SVBXXTxCjVsWQkVwc1Frsph
Content-Type: multipart/mixed; boundary="cIeuOT3xLBGgCjco6cCTHXQBCXCiaPAqV";
 protected-headers="v1"
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: Christoph Groth <christoph@grothesque.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <e7412986-d0bd-d0e3-b268-d3aede1cc80b@suse.de>
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
 <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org>
 <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
In-Reply-To: <87lgu9cu2v.fsf@grothesque.org>

--cIeuOT3xLBGgCjco6cCTHXQBCXCiaPAqV
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable



On 01/17/2017 02:25 PM, Christoph Groth wrote:
> Goldwyn Rodrigues wrote:
>> On 01/17/2017 02:44 AM, Christoph Groth wrote:
>>> Goldwyn Rodrigues wrote:
>>>
>>>> Would you be able to upload a btrfs-image for me to examine. This is=
 a
>>>> core ctree error where most probably item size is incorrectly
>>>> registered.
>>>
>>> Sure, I can do that.  I'd like to use the -s option, will this be fin=
e?=20
>>
>> Yes, I think that should be fine.
>=20
> Unfortunately, giving -s causes btrfs-image to segfault.  I tried both
> btrfs-progs 4.7.3 and 4.4.  I also tried different compression levels.
>=20
> Without -s it works, but since this file system contains the complete
> digital life of our family, I would rather not share even the file name=
s.
>=20
> Any ideas on what could be done?  If you need help to debug the problem=

> with btrfs-image, please tell me what I should do.  I can keep the
> broken file system around until an image can be created at some later t=
ime.

As Chris mentioned, try a later version. If you are familiar with git,
you could even try the devel version.

--=20
Goldwyn


--cIeuOT3xLBGgCjco6cCTHXQBCXCiaPAqV--

--MXHB42Wve4SVBXXTxCjVsWQkVwc1Frsph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJYfqFWAAoJEAE1niapr6PJLZ8IAJmDODi54ALG/axDxpPlWxa5
zgQhdIGPQONwxQwbKjDh0HWCNvuulbFYJ4IsXmpEz1WTKsZ1m0fGRm7PIPLD3ruX
LDz6PajqQ/rv6X7cYxqJFfR6nMKGDB3vKDvnyz7yJNZRWFhgVQubxtVx1t6bA/hW
EyehzHu7S1DAzBGLdjUn8+8tSONrS3dCBX0yBrtimRdRQREKSWmxbtBPVmUQzr8d
v21o5Iyk5CQ+d8BTjchPl7IXT/XN7bGT7HfRVVKqDlzXIzmlmBtnelWbCwl6ox5c
zqeTS6OVAtpJs+ND42/VwwUQ1n54DygBHjV3lk5RxeavtDgTPLYezTVzxnTKqyI=
=OiZO
-----END PGP SIGNATURE-----

--MXHB42Wve4SVBXXTxCjVsWQkVwc1Frsph--
