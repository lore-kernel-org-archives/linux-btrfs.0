Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725737AbeILEpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 00:45:22 -0400
Subject: Re: [PATCH] btrfs-progs: Continue checking even we found something
 wrong in free space cache
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180904124128.22367-1-wqu@suse.com>
 <20180911144809.GB2154@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <251a3f20-617f-1bee-4567-c563b0744c30@gmx.com>
Date: Wed, 12 Sep 2018 07:43:27 +0800
MIME-Version: 1.0
In-Reply-To: <20180911144809.GB2154@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x92fpTPl0vM6CzHtyx7CwWdBnN3rCSIxY"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x92fpTPl0vM6CzHtyx7CwWdBnN3rCSIxY
Content-Type: multipart/mixed; boundary="awL8lFznUTGnVMmdMu3CGMOM72KrKIJPe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <251a3f20-617f-1bee-4567-c563b0744c30@gmx.com>
Subject: Re: [PATCH] btrfs-progs: Continue checking even we found something
 wrong in free space cache
References: <20180904124128.22367-1-wqu@suse.com>
 <20180911144809.GB2154@twin.jikos.cz>
In-Reply-To: <20180911144809.GB2154@twin.jikos.cz>

--awL8lFznUTGnVMmdMu3CGMOM72KrKIJPe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/11 =E4=B8=8B=E5=8D=8810:48, David Sterba wrote:
> On Tue, Sep 04, 2018 at 08:41:28PM +0800, Qu Wenruo wrote:
>> No need to abort checking, especially for RO check free space cache is=

>> meaningless, the errors in fs/extent tree is more interesting for
>> developers.
>>
>> So continue checking even something in free space cache is wrong.
>>
>> Reported-by: Etienne Champetier <champetier.etienne@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  check/main.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/check/main.c b/check/main.c
>> index b361cd7e26a0..4f720163221e 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
>>  			error("errors found in free space tree");
>>  		else
>>  			error("errors found in free space cache");
>=20
> Please make it a warning and update the message so it says that it will=

> continue despite the errors found.

I'm fine to add warning, but isn't it the expected behavior?

In fact I'm quite surprised that when we found something wrong we just
abort checking.

It's never the case for file/extent tree check. We always report all
errors we found, not only the first error and exit.

Thanks,
Qu

>=20
> I noticed that error handling in check_space_cache is a bit fishy, some=

> errors are stored to 'ret' but ignored at the end of the function.
>=20


--awL8lFznUTGnVMmdMu3CGMOM72KrKIJPe--

--x92fpTPl0vM6CzHtyx7CwWdBnN3rCSIxY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAluYUx8ACgkQwj2R86El
/qh8KggAq4leGP6YMaUNUb/0RQwuW9hhunfuNrjeAQrfIoq+F1G/WpxFgF9kcsDm
pATvVCZPuM02pQaaiOw4Ya1xTHFnPN1UGlN1M0vghT0JPKdBPOjIievJj/Vhbobf
M7LvjeYPwzf+EYYNjrVoPWCfsdVgUnQIg3RTW3BK45bzDu+K7J4Sc7iefb3r9uU9
wpN0foSCvR09ctIUx0KCxDE9mAU/LSIY83qf82rZNAU0V7MnJPlu7a4n84IahMJ/
fDvux27fi4XcBI1z8TOVYGX6NCfBSyT8rye/HMytK1WQKRYIdmJEpFVOrXNoKHr/
c6uixCs+B2UEPYYOC70QXa4+CXMrQw==
=f3t9
-----END PGP SIGNATURE-----

--x92fpTPl0vM6CzHtyx7CwWdBnN3rCSIxY--
