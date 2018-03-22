Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:37047 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755533AbeCVOC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:02:28 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Use macro to replace
 immediate number for readable flags string buffer length
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180322073711.5943-1-wqu@suse.com>
 <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
 <7076d888-34ee-d9d9-8187-8d024b5a1465@gmx.com>
 <3792de77-6b0d-dd8c-7cca-05391a1c0169@suse.com>
 <20180322133927.GZ6955@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <fc652775-82a4-6512-0724-e98fc0e68013@gmx.com>
Date: Thu, 22 Mar 2018 22:02:12 +0800
MIME-Version: 1.0
In-Reply-To: <20180322133927.GZ6955@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WxRbF4RgcW9mAhnYA64sWUrR5omlMhLWB"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WxRbF4RgcW9mAhnYA64sWUrR5omlMhLWB
Content-Type: multipart/mixed; boundary="lsxqZDCijzVDJp5lBX9Uei5A0wizrbAb0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
 Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <fc652775-82a4-6512-0724-e98fc0e68013@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: print-tree: Use macro to replace
 immediate number for readable flags string buffer length
References: <20180322073711.5943-1-wqu@suse.com>
 <a3bf609e-a495-d64b-3124-c462f31f9785@suse.com>
 <7076d888-34ee-d9d9-8187-8d024b5a1465@gmx.com>
 <3792de77-6b0d-dd8c-7cca-05391a1c0169@suse.com>
 <20180322133927.GZ6955@twin.jikos.cz>
In-Reply-To: <20180322133927.GZ6955@twin.jikos.cz>

--lsxqZDCijzVDJp5lBX9Uei5A0wizrbAb0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 21:39, David Sterba wrote:
> On Thu, Mar 22, 2018 at 10:40:22AM +0200, Nikolay Borisov wrote:
>> On 22.03.2018 10:32, Qu Wenruo wrote:
>>> On 2018=E5=B9=B403=E6=9C=8822=E6=97=A5 16:20, Nikolay Borisov wrote:
>>>> On 22.03.2018 09:37, Qu Wenruo wrote:
>>>>> In print-tree, we have a lot of parsers to convert numeric flags to=

>>>>> human readable string.
>>>>>
>>>>> For the buffer size we're using immediate numbers for all their cal=
lers.
>>>>> Change this to macro so it will be much easier for us to expand the=

>>>>> buffer size.
>>>>>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>
>>>> The changes look good per se, however I'd like to have all such macr=
os
>>>> grouped at the beginning of the file - in their own section so to sp=
eak.
>>>>
>>>
>>> That's also what I considered.
>>> However this makes stack consumption larger for some callers who don'=
t
>>> really need that much buffer size.
>>
>> I just meant to have the multiple defines you've introduced grouped at=

>> the beginning of the file. Not having one define for everyone. This is=

>> done purely for aesthetics purposes, though I'm not too hung up on tha=
t
>> so if you decide to ignore it, it's fine.
>=20
> No, that's actually what I prefer, the first part of header or source i=
s
> for defintions. Unless it's really local to the function or single use.=


All right, I'll change the layout.

But leave some comment for each *_flags_to_str() function to info later
contributor what to change.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--lsxqZDCijzVDJp5lBX9Uei5A0wizrbAb0--

--WxRbF4RgcW9mAhnYA64sWUrR5omlMhLWB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlqzt2QXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiDsQf+MWMD6W+XiLLsT49zKmQE593M
IHxXt+2GagrmFjeezth+1Nbvs1yz3Y27bNpS6gydYuexGcxerWAHSinZHdM+dUEB
iM417WcnZySvgvRs3nj9mcCohswLoDcFjhDwnzDEb4nO1xryfD+bUZFH2CDV/uMd
HtHu1faX/NOFjjHRjULlJ5KyMAVhjvNu1qYdRaiEQ8qe0qzZJLa+rH75xCgJ//l/
5T+x4B8cotMsQlIIrAZK2PIPCW1AknX0bfPLpV8zzLU75wJkDnEIHSSvuK5uV17Z
TDM57GPr9KFD0I575mvY0mlVEG+KMATIN43lS0ihDVO/I3+wjavnvA4goqxeYQ==
=o0Pg
-----END PGP SIGNATURE-----

--WxRbF4RgcW9mAhnYA64sWUrR5omlMhLWB--
