Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50429 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbeFEFbA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 01:31:00 -0400
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
 <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
 <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
 <ac13c732-29a3-89c7-0fe2-f3222e7cb6ee@gmx.com> <87lgc2mrud.fsf@shaw.ca>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5eac8b95-b6cd-87ef-2f16-573be326ef37@gmx.com>
Date: Tue, 5 Jun 2018 13:30:50 +0800
MIME-Version: 1.0
In-Reply-To: <87lgc2mrud.fsf@shaw.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NNnRjgR73xNWORTSe3eOPZG3nHjunhOPd"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NNnRjgR73xNWORTSe3eOPZG3nHjunhOPd
Content-Type: multipart/mixed; boundary="7NyxJ8nnT7Wk0f7OUTPYjF3MTpWE6RKeT";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
Message-ID: <5eac8b95-b6cd-87ef-2f16-573be326ef37@gmx.com>
Subject: Re: off-by-one uncompressed invalid ram_bytes corruptions
References: <b262fdfc-16b2-21d0-4d7b-745ef106b555@shaw.ca>
 <2dab827b-2c68-ea5c-6730-485037727c36@gmx.com>
 <0b8e2626-fb00-1e82-4f22-c400cea57533@shaw.ca>
 <5093c14b-5d6d-0827-0c04-bf2fd73af0bd@gmx.com>
 <e0854da8-0d3e-946a-5709-7a329175bad3@shaw.ca>
 <de65fc60-fc23-f7d5-1f58-52687d4859e8@gmx.com>
 <b9ac2d21-93aa-e69a-5994-a1839114cfbb@shaw.ca>
 <53d68efd-21fa-3e18-c35e-89a043605471@gmx.com>
 <f50de27a-bb18-ce30-8694-d5f76684846e@shaw.ca>
 <ac13c732-29a3-89c7-0fe2-f3222e7cb6ee@gmx.com> <87lgc2mrud.fsf@shaw.ca>
In-Reply-To: <87lgc2mrud.fsf@shaw.ca>

--7NyxJ8nnT7Wk0f7OUTPYjF3MTpWE6RKeT
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8829=E6=97=A5 22:58, Steve Leung wrote:
> Qu Wenruo <quwenruo.btrfs@gmx.com> writes:
>=20
>> On 2018=E5=B9=B405=E6=9C=8828=E6=97=A5 11:47, Steve Leung wrote:
>>> On 05/26/2018 06:57 PM, Qu Wenruo wrote:
>>>>
>>>>
[snip]
>> Still nope.
>> What about encrypt it and upload it to some public storage provider li=
ke
>> google drive/dropbox?
>=20
> Ok, uploaded to Google Drive.  You'll need to request access to it.
>=20
>   https://drive.google.com/file/d/16NM1NVoMVgkJ_JiePi8VfAzit5_Onz2H/vie=
w?usp=3Dsharing
>=20
> sha256sum for the file should be:
>=20
>   ea0abc21fcbc3a71c68b7307d57b26763ac711bd3437a60e32db3144facfeb3f
Sorry for the slow reply.

After all the testing, the result is a little surprising.

It's indeed *CORRUPTED*! And tree-checker code exposed it.

It's just btrfs-progs and kernel print-tree code doesn't use correct
ram_bytes to output, thus pretty tricky to expose.

The problem is the ram_bytes of that inlined extent, it's indeed larger
than it should, just by one byte.

I'm not completely sure how it's happened, but according to the
timestamp it's 4 years ago and I think some kernel off-by-one error
happens and fixed.

And current kernel can handle it pretty well without reading out the
last byte.
However it's still a corruption.

Although it's not a big problem, and can be fixed easily.
I'll submit a btrfs-progs patch to allow btrfs-check to fix in this week.=


Thanks,
Qu

> Thanks!
>=20
> Steve
>=20


--7NyxJ8nnT7Wk0f7OUTPYjF3MTpWE6RKeT--

--NNnRjgR73xNWORTSe3eOPZG3nHjunhOPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsWIAoACgkQwj2R86El
/qhTRAgAp8sGaqn8Ni6nhcJWu6buGs01Wd1UZRQXG3p2ppOEkF2bA7MX7Ujx3TEA
hdmvRQimEA4DCYWmIQh9UGINi6vJLlK6FBn7c3LDMlWHN5Byz4CXQxAmvNZYh7wa
88SR4KG6nsk+7EBMYWGR25ysTfKq6YXcXUxSmWisXdmFtJKEuWxx7CQwoLx0e5Jp
90emzzmpKoPJcZofFUF07UUR0Ej7jwvUshZGEAX0nsg4EY42xyStZN04cXAE+VDH
JYpfCUYbgAid5zNy1PLUDviO2Kdc3FDAkOKS3c3DwGRYKimVsSWv38kjAJLRbCcV
hqaDs5Z/CZKI7zjdd1qTeo91j1R6pQ==
=7aGR
-----END PGP SIGNATURE-----

--NNnRjgR73xNWORTSe3eOPZG3nHjunhOPd--
