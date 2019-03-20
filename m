Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81C9C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4314620835
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 00:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="TsbBzc83"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfCTAqg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 20:46:36 -0400
Received: from mout.gmx.net ([212.227.15.18]:41433 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfCTAqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 20:46:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553042784;
        bh=TS3laHxXrqJkDxup+yCV3PD1pqX+ayYIXLc7YBMLahM=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=TsbBzc83/fdUKyQ7iIndEQx85AwOWLcMYJ8TSBW2DKX1hgtR9osnFhSJtO75swBNA
         JIZ2aOIOkjX7LO3NZXqdg4JCkPcrD8H4vAn6Pc6Y0zJ7m0ep0RVVPE+oUJQJ2IB2on
         4Xo8aiINiEIRoYOlGEyTzkZPKGaxpgSRaVJtH0LY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LxPAo-1gvw4D17G6-0170lM; Wed, 20
 Mar 2019 01:46:24 +0100
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com> <20190319145050.GL3516@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
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
Message-ID: <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>
Date:   Wed, 20 Mar 2019 08:46:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190319145050.GL3516@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5etTlr99HTSlp8AMpRbOs184HPKVxIDPv"
X-Provags-ID: V03:K1:WSaTqeXrPuznGoLXuNxExFROD2Derll4tBD8jqHkY7Vrna76WBz
 LMo/+70VOvNInYJZMjZSTEnoFkxjA77QvmUTFjNzek+lDTlf3GN3CuSR8KPsqQ0MZs1W+rE
 vjAF3PBNh7njl9alADz7oOpBGCVVBtNzTsHu1hqkZwpWYx8ksYlSUGYtyCuaGjkDcCFnZKE
 5HNAu2sitkWEAyUrI7Twg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qlwgh/FXOsc=:lQbAIPMgj7onha1awqyjy8
 SKI4hQP6RooX/yTWsnctfm9J0lejL4caLAb31TUiHHi6JGzZeibpeQOEu36JEG6a6VpHlF+Ih
 wiPMJzziSpcrODSgDL3nIEFWTgjj+SQmoriZtkhpYri2pzQ6okpun4DDwLI83ZERGkE2SgG1F
 ih8h6dIZ1F/TRdH+iy/nvMiW/4lIP6iIfK0CXCdj1HdC8o9JVYyPwWXQIn6QgcQjkzZ+GxOcX
 h4JSpeWcyGU8KpaWc8eLtvrMmJkw60xWNikGj9PO/UyY5TUuF+9CF6T1MictYKrjQn6IVVMrW
 /GddBXv2cBQjUC/GCz5jWyHEAoHAJZJe5AP7G/eiJwn47ofI/voD8Xz7+PcpTfPlbPImruVLl
 PcEYUcpe7RPvXh8AJgrXemQ7njfcwDW0B6KLqA0JFS6Phf1BAtk7fZianUpkS1U82wuog9bvg
 nAYAJ9H0dGqWWEpmGyWZsq+hZHerp/z+/6wnYgmkexSSExgmf1H72ht3RYymbdrFdET0H/AOz
 JkndJSZOXBXo0NcSSjldJyJnpJhVTh5Gv98NWmfK0Py+W0LQGT1Ayh2nkUQj/7NyBrUgEKn/F
 +DBBgSGKsTxQIL8HGXVRCg9jwhPtnFJm5ueUkZie/jclE3+0M1vB74fqj8inzKMJ0IU9C/LZU
 gcpVXK2GAmXwaYbBgp/68dnE6ngRkrQjb5LDj+lUiKf9rDDFrunBJIQ2YKlZ7DTweAx1Zf/nW
 /dr/uJiULpXH84S+XRRpD6ClmPNUOpAngt5pnJa4U/48QjylQi7KNcjlzHLJs/z0wXiQuNQpv
 BgLldKMFqFiELaHoIABYXzmaq2TaAr2SE0aUg3e4/QT8cSXuCpTz0FbJnDt0+ky+0/tlGigMH
 QIk9N9IcAnqNAu1OfL0te5skwS9Bnx4FCayLl5xwCEOGESU6H5sp/0uXRQAXPK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5etTlr99HTSlp8AMpRbOs184HPKVxIDPv
Content-Type: multipart/mixed; boundary="RXffeqORCfigjr25eTewjfn651cqUMt7P";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 Yoon Jungyeon <jungyeon@gatech.edu>
Message-ID: <ce65b283-568f-16d1-375e-654e1337d2e8@gmx.com>
Subject: Re: [PATCH 1/6] btrfs: tree-checker: Verify chunk items
References: <20190313085511.23540-1-wqu@suse.com>
 <20190313085511.23540-2-wqu@suse.com> <20190319145050.GL3516@twin.jikos.cz>
In-Reply-To: <20190319145050.GL3516@twin.jikos.cz>

--RXffeqORCfigjr25eTewjfn651cqUMt7P
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/19 =E4=B8=8B=E5=8D=8810:50, David Sterba wrote:
> On Wed, Mar 13, 2019 at 04:55:06PM +0800, Qu Wenruo wrote:
>> We already have btrfs_check_chunk_valid() to verify each chunk before
>> tree-checker.
>>
>> Merge that function into tree-checker, and update its error message to=

>> be more readable.
>>
>> Old error message would be something like:
>>   BTRFS error (device dm-3): invalid chunk num_stipres: 0
>>
>> New error message would be:
>>   Btrfs critical (device dm-3): corrupt superblock syschunk array: chu=
nk_start=3D2097152, invalid chunk num_stripes: 0
>> Or
>>   Btrfs critical (device dm-3): corrupt leaf: root=3D3 block=3D8388608=
 slot=3D3 chunk_start=3D2097152, invalid chunk num_stripes: 0
>>
>> Btrfs_check_chunk_valid() is exported for super block syschunk array
>> verification.
>>
>> Also make tree-checker to verify chunk items, this makes chunk item
>> checker covers all chunks and avoid fuzzed image.
>>
>> Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D202751
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/tree-checker.c | 152 +++++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/tree-checker.h |   3 +
>>  fs/btrfs/volumes.c      |  94 +------------------------
>>  3 files changed, 156 insertions(+), 93 deletions(-)
>=20
> Please split the patch to part where you just move the code and where
> the logic is changed. btrfs_check_chunk_valid is not the same, old has
> -EIO and new -EUCLEAN. Moving a function is ok in the same patch if
> there's no change.

There is change in the verification timing by just moving the code to
tree checker.

The new timing of chunk verification will make btrfs more robust by
trying the other copy when content doesn't make sense.

In fact the code move itself would solve the bug in the kernel bugzilla.

So It doesn't make that much sense to split the patch.

Thanks,
Qu

>=20
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index b8cdaf472031..fe3f37c23c29 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -448,6 +448,152 @@ static int check_block_group_item(struct btrfs_f=
s_info *fs_info,
>>  	return 0;
>>  }
>> =20
>> +__printf(5, 6)
>> +__cold
>> +static void chunk_err(const struct btrfs_fs_info *fs_info,
>> +		      const struct extent_buffer *leaf,
>> +		      const struct btrfs_chunk *chunk, u64 logical,
>> +		      const char *fmt, ...)
>> +{
>> +	/* Only superblock eb is able to have such small offset */
>> +	bool is_sb =3D (leaf->start =3D=3D BTRFS_SUPER_INFO_OFFSET);
>=20
> Please move the initialization and comment out of the declaration block=

>=20
>> +	struct va_format vaf;
>> +	va_list args;
>> +	int i;
>> +	int slot =3D -1;
>> +
>> +	if (!is_sb) {
>> +		/*
>> +		 * Get the slot number by iterating through all slots, this
>> +		 * would provide better readability.
>> +		 */
>> +		for (i =3D 0; i < btrfs_header_nritems(leaf); i++) {
>> +			if (btrfs_item_ptr_offset(leaf, i) =3D=3D
>> +					(unsigned long) chunk) {
>> +				slot =3D i;
>> +				break;
>> +			}
>> +		}
>> +	}


--RXffeqORCfigjr25eTewjfn651cqUMt7P--

--5etTlr99HTSlp8AMpRbOs184HPKVxIDPv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyRjVgACgkQwj2R86El
/qhpSAf+LukAB0Dj2PNBunxzDlZPuK/HHXDrmQLkZZdGu34RIUVOBTsnGTFNJaOs
/zZegEOsWVnbg+mnS7FCA5FkxEwlwj9VSeuRJFnzfA+HCTNWjGMO/nxRSO+P4P/E
boPeXI8QKUuwhN1EHnM2QQSJRGyl5TyEUz00D3FJ5/ZqCXdwEXaqQG7tLSnfoMjj
zf74vPOAY/wrq3BQt3DzAD5slG+s65cRVaxOEaoFryyd3AJabHlo7B9SIb64mXYT
c4Ax2TA1BbSDAHtepSIPROnA34riqGz4L/SkAPlM03NGuKtG4NRypMF5Z97zlvPz
MYk6t55jl0v1nReZ2jVC8JiUnEOnuA==
=x03Q
-----END PGP SIGNATURE-----

--5etTlr99HTSlp8AMpRbOs184HPKVxIDPv--
