Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:34123 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757071AbeEJMRl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:17:41 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error for
 qgroup mismatch
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180430061700.18498-1-wqu@suse.com>
 <20180508174513.GO6649@twin.jikos.cz>
 <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
 <20180510114549.GD6649@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f8104a7c-d4d5-8ab4-62c3-96f4045eb619@gmx.com>
Date: Thu, 10 May 2018 20:17:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180510114549.GD6649@suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JYoHG2vfwN3mWJY1bL54yNGsh5LPyHn2d"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JYoHG2vfwN3mWJY1bL54yNGsh5LPyHn2d
Content-Type: multipart/mixed; boundary="dXWV98dxzNXaJkNB4Ugg8RWxmV74sqfiw";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <f8104a7c-d4d5-8ab4-62c3-96f4045eb619@gmx.com>
Subject: Re: [PATCH 1/2] btrfs-progs: check: Make btrfs check return error for
 qgroup mismatch
References: <20180430061700.18498-1-wqu@suse.com>
 <20180508174513.GO6649@twin.jikos.cz>
 <d28e1cb9-7610-89ff-4980-34a969fbe779@gmx.com>
 <20180510114549.GD6649@suse.cz>
In-Reply-To: <20180510114549.GD6649@suse.cz>

--dXWV98dxzNXaJkNB4Ugg8RWxmV74sqfiw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8810=E6=97=A5 19:45, David Sterba wrote:
> On Thu, May 10, 2018 at 09:43:09AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B405=E6=9C=8809=E6=97=A5 01:45, David Sterba wrote:
>>> On Mon, Apr 30, 2018 at 02:16:59PM +0800, Qu Wenruo wrote:
>>>> Current btrfs-check will check qgroup consistency, but even when it
>>>> finds something wrong, the return value is still 0.
>>>>
>>>> Fix it by allowing report_qgroups() to return int to indicate qgroup=

>>>> mismatch, and also add extra logical to return no error if qgroup re=
pair
>>>> is successful.
>>>>
>>>> Without this patch, fstests can't detect qgroup corruption by its fs=
ck
>>>> alone.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>
>>> Applied, thanks. Please send the 0/N (cover letter) mail even for
>>> 2-patch series.
>>
>> Any advice on the necessity of the cover letter?
>>
>> Is cover letter highly recommended for any patches which have any
>> dependency like the 2nd test case?
>=20
> The cover letter is a place where you can get feedback on the whole
> patchset, individual patches get the specific comments to the code.
>=20
> A patchset makes a logical chunk of patches so the cover letter also
> serves as the high-level overview of the changes before I or others eve=
n
> start looking further.
>=20
> I've seen other maintainers to prefer cover letters, but as this is not=

> documented and not generally appreciated by developers, it needs to be
> stated. Developers who post patches frequently could help to improve th=
e
> patch flow process, but lack of cover letter is not a big deal
> otherwise.

Much appreciated about the explain on this topic.

Personally I'm completely fine for cover letters, so I would take this
method for later logically related patches.

Thanks,
Qu


--dXWV98dxzNXaJkNB4Ugg8RWxmV74sqfiw--

--JYoHG2vfwN3mWJY1bL54yNGsh5LPyHn2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr0OFcACgkQwj2R86El
/qitigf+N/ApD+luO5Nvmfw9zFLb6AG1WkJ+6qylcTRUqNf2iYkpEtUKHsHXKVy/
H/gcfIC7RI0tczg8ryxjqqWgD7cxT0OtNngm8uiLvinLCjsTtec9uKV5lA1GPISm
1OwG5GZAapy7gpciE6rMSMpj202n4pSr8ByXFcQvNXRmy1wm3e+wS5pXnln1GY7N
ZsMUPyZ3pBA35ounRbdvjcC1entX32RQLpXlYQRxsrSy2//dS3lTys7VluPVbL22
a9l7f3guPbpeDPJAbzF38NAJZ1QwdyDoJf/MV4wEV0aWbDd9t6j4ZdbQjS8mgUIo
6E3XvAGYCYseT6mVvGxM9JTk51le/A==
=2ZWG
-----END PGP SIGNATURE-----

--JYoHG2vfwN3mWJY1bL54yNGsh5LPyHn2d--
