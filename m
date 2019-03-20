Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63518C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 05:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F0892184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 05:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SJW648xr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfCTFEd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 01:04:33 -0400
Received: from mout.gmx.net ([212.227.15.19]:51757 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbfCTFEd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 01:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553058239;
        bh=GyXP9Zt8C+GRdNOS4Xn89deQdrcI4T1i0tfi9z0UWSQ=;
        h=X-UI-Sender-Class:Subject:From:To:References:Date:In-Reply-To;
        b=SJW648xrj1hvuxkHGkN9Qywk6YxHSjCPmPztP9MFiEYKh1ffcv+jxi+8lY51JW/Jn
         uPoBMlohfx3KXPYZgGqksCzhgapijTgYdnXDVPtniRlTrAFg2TE5heqvbhuhBze+Ig
         GS9XD+YAYvPFHJt/3H6n5DDu5ltHkH5Zt0qCaysY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MeP5b-1hNBzN05Lr-00QCnm; Wed, 20
 Mar 2019 06:03:59 +0100
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com> <20190319145050.GL3516@twin.jikos.cz>
 <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <27d0ea4a-f9a2-cccc-4f30-7f4a513a2f86@gmx.com>
Date:   Wed, 20 Mar 2019 13:03:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PtDQ7LRnsvcV8f51wGbPazX26HPEakjz2"
X-Provags-ID: V03:K1:VrrfF2oQ7gOblIrH8VemtxGsmbEejjWdEIgJUq6QnvcWlWs1FtP
 +Ykw/iso1UPnxivgUloRYXEzoQYr11FLVFXwO7hZeHXsCLYyoJXANqXe9T3POaizP1jJGDZ
 OAR1qVfr/SFr9P6+Itp9zDl00lBU9sniFj1OIlLA7qjpzk7T2dpno7UbEd+JNAMMGbKwSD6
 0XtUn3dBaULQ1HWBRSiAA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FWe7m6Dlsz0=:fSJjsGvmu2gtQXmID3VxE5
 Wvq5Rs4gAlg65ihpcW7CzASRiXsM73RgLFKg6RyxnVFLYMmeIs1kcia7XyzS3MnbYcP/rvUO4
 PqLCm/ubv5srhLZngd11aj4EG/PPKG0+VxW2VQ1NGkW+DpURGatiVoMpVUgmxHoZm8r/GwpRd
 qFDxoLhVMNFH7caq0uzyZNjyGc1jKYK8lZkzgLFbxROnYv99+vPtvQ3M8F0sznH6zVEc5GuQr
 pftvsU3wb3FbootUi3F5oTUj75ZMsS+BSpxsx2zsCjemyeKqJYVxZMRVmPLTLqMDoxAQrA4am
 mrhhhylFwqO75X8UNnpK1wLjAX6tFRC2XUYBsPz6DYEANrDQXEGVmhdiGPRu/YP11g5X10N3u
 kNnUUM784BbHrKz//mFAzPE4V2JqIhIJhx19f4IKGPhlJRKo1ARHrk0x0+l00ZiH3SYSHe9S2
 Go1RWELHoxsu3Qfhl6c4CVPLol++Wfp+VgiKKR4ODjtxU3VmYVr9hYX6HESbdhM0Sjdamjlmv
 EtwdRIMxceGdbVwCxGP7XFlfndaTmiRw7K/KwtVmQruI+J3KMRI+Gdtcq2FzaJk2c5yKR7uJf
 w/twmzk0helBSpDy3O0Vaf3mox0aXPc5mPp1SsbL2oEYx5fchJtkFQijfbwrYnKU5d1Chx2p0
 92F2y40trS6OCIA+Mvf09H9u25+ZZo+UOcb2XoXJxjnfeyz/9utfoLzsB03kzw6mprRqJZlRg
 o05UMCOqYVbnk/cu7kToacZrXAOACkVCsQNhI5IDi+rergrutMZsUjmG4Jnz7jmkCaGvCMAya
 PqYxBOqYwIzLSJIQr7vowdTxayskq55/QzKtgAihHuUBcJ5yD+S25AZgOIsexTzKM86xTVm2+
 bRnDC9WpR4CwwnLArM72cHI2FkKcDm8TOV+f82oQ8mssK5TeJfg7wOnpSNlx3V
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PtDQ7LRnsvcV8f51wGbPazX26HPEakjz2
Content-Type: multipart/mixed; boundary="YKuqbju1QqP6Dh5aaJhJP7yVvpH5Yo4OV";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Yoon Jungyeon <jungyeon@gatech.edu>
Message-ID: <27d0ea4a-f9a2-cccc-4f30-7f4a513a2f86@gmx.com>
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com> <20190319145050.GL3516@twin.jikos.cz>
 <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>
In-Reply-To: <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>

--YKuqbju1QqP6Dh5aaJhJP7yVvpH5Yo4OV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8A=E5=8D=888:46, Qu Wenruo wrote:
>=20
>=20
> On 2019/3/19 =E4=B8=8B=E5=8D=8810:50, David Sterba wrote:
>> On Wed, Mar 13, 2019 at 04:55:06PM +0800, Qu Wenruo wrote:
>>> We already have btrfs_check_chunk_valid() to verify each chunk before=

>>> tree-checker.
>>>
>>> Merge that function into tree-checker, and update its error message t=
o
>>> be more readable.
>>>
>>> Old error message would be something like:
>>>   BTRFS error (device dm-3): invalid chunk num_stipres: 0
>>>
>>> New error message would be:
>>>   Btrfs critical (device dm-3): corrupt superblock syschunk array: ch=
unk_start=3D2097152, invalid chunk num_stripes: 0
>>> Or
>>>   Btrfs critical (device dm-3): corrupt leaf: root=3D3 block=3D838860=
8 slot=3D3 chunk_start=3D2097152, invalid chunk num_stripes: 0
>>>
>>> Btrfs_check_chunk_valid() is exported for super block syschunk array
>>> verification.
>>>
>>> Also make tree-checker to verify chunk items, this makes chunk item
>>> checker covers all chunks and avoid fuzzed image.
>>>
>>> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D202751
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>>  fs/btrfs/tree-checker.c | 152 ++++++++++++++++++++++++++++++++++++++=
++
>>>  fs/btrfs/tree-checker.h |   3 +
>>>  fs/btrfs/volumes.c      |  94 +------------------------
>>>  3 files changed, 156 insertions(+), 93 deletions(-)
>>
>> Please split the patch to part where you just move the code and where
>> the logic is changed. btrfs_check_chunk_valid is not the same, old has=

>> -EIO and new -EUCLEAN. Moving a function is ok in the same patch if
>> there's no change.
>=20
> There is change in the verification timing by just moving the code to
> tree checker.

My bad, I though the code move and verification timing must be done in
one patch, and that's definitely wrong.

I'll split the code move and logic change.

Thanks,
Qu

>=20
> The new timing of chunk verification will make btrfs more robust by
> trying the other copy when content doesn't make sense.
>=20
> In fact the code move itself would solve the bug in the kernel bugzilla=
=2E
>=20
> So It doesn't make that much sense to split the patch.
>=20
> Thanks,
> Qu
>=20
>>
>>>
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index b8cdaf472031..fe3f37c23c29 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>> @@ -448,6 +448,152 @@ static int check_block_group_item(struct btrfs_=
fs_info *fs_info,
>>>  	return 0;
>>>  }
>>> =20
>>> +__printf(5, 6)
>>> +__cold
>>> +static void chunk_err(const struct btrfs_fs_info *fs_info,
>>> +		      const struct extent_buffer *leaf,
>>> +		      const struct btrfs_chunk *chunk, u64 logical,
>>> +		      const char *fmt, ...)
>>> +{
>>> +	/* Only superblock eb is able to have such small offset */
>>> +	bool is_sb =3D (leaf->start =3D=3D BTRFS_SUPER_INFO_OFFSET);
>>
>> Please move the initialization and comment out of the declaration bloc=
k
>>
>>> +	struct va_format vaf;
>>> +	va_list args;
>>> +	int i;
>>> +	int slot =3D -1;
>>> +
>>> +	if (!is_sb) {
>>> +		/*
>>> +		 * Get the slot number by iterating through all slots, this
>>> +		 * would provide better readability.
>>> +		 */
>>> +		for (i =3D 0; i < btrfs_header_nritems(leaf); i++) {
>>> +			if (btrfs_item_ptr_offset(leaf, i) =3D=3D
>>> +					(unsigned long) chunk) {
>>> +				slot =3D i;
>>> +				break;
>>> +			}
>>> +		}
>>> +	}
>=20


--YKuqbju1QqP6Dh5aaJhJP7yVvpH5Yo4OV--

--PtDQ7LRnsvcV8f51wGbPazX26HPEakjz2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyRybgACgkQwj2R86El
/qgZawf+KkLn3/5RMEFQBjX8T22q6X1YsNZX+gisExR6isM+0qd38IdYFtxmqK6f
sDnfJnPKpNxx39IdCfJfLk8RhdADCmP/fU24XsyqOEdG2yGavqWzSxo03jwGd1KL
m7ngbv9IsQZlPJk+8dFs/SiPHfYYC605DrZrEMtxbcET6C6ZkkJipfRXiTKzLNzG
7jQ+1GKMGVJgYAN6RCYcMGW/k74J/1qVhfsTcUag39XFUzDC6kCpT+K81HF0wwLh
PtNV748r7yNa+Xo0nY2Mk/7en5jgbwrqtNYAGHQjdwESEj8lgbqb6jQ6dExX2E/r
mYIQm0+pLhCKgypg82Lnlr6p9aMNDQ==
=o6aQ
-----END PGP SIGNATURE-----

--PtDQ7LRnsvcV8f51wGbPazX26HPEakjz2--
