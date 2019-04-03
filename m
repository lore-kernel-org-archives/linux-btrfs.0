Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4979C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 09:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8924A20882
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 09:08:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="kn+Ntabw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfDCJIJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:08:09 -0400
Received: from mout.gmx.net ([212.227.15.15]:39691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfDCJIJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 05:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554282471;
        bh=rSvvWB0hRhvc/zQjAHFu9g6GLBr44ZY6phl1qqz+8/M=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=kn+NtabwrZTFHR/rp/CEPT5DB+X0h5aU3T54m7jHkUijGsEnEvKbZa3g5ApnMqk55
         OE2sAledFs0/mOP3Fn6kGTSvjef1ls1zMjipANjUQlkHUIXg2tBNHf5txeqVVhmJIW
         O4K7+U0Z2Br73Wqefnr7I9pg/fZXD6lK9JZyJbFU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MRoRF-1hMmvX0USf-00SuTe; Wed, 03
 Apr 2019 11:07:51 +0200
Subject: Re: [PATCH v5.3 11/11] btrfs: Do mandatory tree block check before
 submitting bio
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Leonard Lausen <leonard@lausen.nl>, David Sterba <dsterba@suse.cz>
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-12-wqu@suse.com>
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
Message-ID: <513a77d6-b9e1-3c45-ff11-ee1387fc3d4d@gmx.com>
Date:   Wed, 3 Apr 2019 17:07:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190320062749.30953-12-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OItliVWuojXdCmefxdTAlyRbYY6gqK46X"
X-Provags-ID: V03:K1:CwPYL7bpxCbkg+MW8K2C+eZUUANwDQCzCzPOMXg12FDcYHR3q6X
 oG6x3b5+sribEStVRQoOtBb9MCZSrfMUmB56/mL39nkc3oo+cu5Eo3sJ5Jz+HUJ2y6cpoF9
 R+kqVZr6uEOPfRVvNjN+4qnLUO0H9loZnBqvoZiLrC1wNzxJhsnev1tbqILa/Fvl+N+y7TD
 Wuel95fT0/ReLIMgg6Gvg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:KWuowsDf7gE=:7hGCjcQGD4CK6w3O1Fg5+0
 bQ34H9xF9tizpNqnJ9SBxP2Jn3qFIbPhmLdpPzQPkc9oAqUHTxMlitxlur2AJiiRDYzXc7XN8
 1F3XF5EgZ5hdNlkYafYlx2frysOYKS5DxNFYIUqcoRdT6eutur2Pc3HpxkQATMke4RESKWE1K
 GftV10oqPeNRfs/md50SyRfVzj0rm5xp7b9MLBMoMubmt/9fUpYMH8Gg06vIbfzMIYxL7IFXi
 nWHPtGSvXs/dFeDd6+NvspV3SK5Fo6QABjaByUzXtZrUjmhxqhmiYlYt2TQQSxUZCOry1ABAu
 b2Mo4ykMG+Sb8/i70bzgWljArj/s5v9ZQVdiyIuAmsevn1oP9tRaC6W/L0UIlNLofDSM+bWuX
 J1sJmYHzJlcpth1hjJ8QxhuqD60TcBmLK/nFUFUgOQIgj38sQU3uItV+2sBWv5cYkiziGF4Ym
 1W+3kIbBc/0V8InnPcR4VdlzqoaE+fS+Cocvkii56BhfYp0JFiq/w46sIO0AQEuEtaYzpbZf8
 ZNz4cGjm+1eKk4f/NawH0fIEBOf+Cs2bTKwYAbi9GK4M28GzIfWbq+STf0M9GtyFXJ80G8qHM
 31KaJJGe9A+vDeaTVnQP4UVH2BN0afPOcZlLVEA58MJxC4Yb/Vr3LcXTpvA+7ODtVzZcvOZTt
 DCOccFUCo5TyG3HcAm0s5IeXLMs3yHux8xN02UhsbE+VkDJaGMDaH0FNAGTdbzKmVjKeItOK/
 QSoIO+hOw12ywQGMZq7lobEP+oIPUMsjYORbWPBcr/dG9qkHeUmFFFhXtcZlFwRccoOIfv9rA
 tXL+TeZggDveoyp0+WY+PIbpUY6IQa3TJ6rIacvPL4dEnyrWUksn+rzhdkKVKpmo1D0MxGgbF
 ERXM0Y4ps7mJHbOV1nHBhzO3vK/L5Tjb8GPewq65dSqTe9W0pVX8cvPPtHB5mZ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OItliVWuojXdCmefxdTAlyRbYY6gqK46X
Content-Type: multipart/mixed; boundary="P4I2bHAEcYnwPQe7SDkwICllJp5rvj6sA";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: Leonard Lausen <leonard@lausen.nl>, David Sterba <dsterba@suse.cz>
Message-ID: <513a77d6-b9e1-3c45-ff11-ee1387fc3d4d@gmx.com>
Subject: Re: [PATCH v5.3 11/11] btrfs: Do mandatory tree block check before
 submitting bio
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-12-wqu@suse.com>
In-Reply-To: <20190320062749.30953-12-wqu@suse.com>

--P4I2bHAEcYnwPQe7SDkwICllJp5rvj6sA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/20 =E4=B8=8B=E5=8D=882:27, Qu Wenruo wrote:
<snip>
> +int btrfs_check_leaf_write(struct btrfs_fs_info *fs_info,
> +			   struct extent_buffer *leaf)
> +{
> +	return check_leaf(fs_info, leaf, false, false);
>  }

Well, I got confused by those two bool paramters.

The first bool is whether to check leaf data.
!!OF COURSE WE NEED TO CHECK LEAF DATA!!

So the 3rd parameter should be "true".

David, would you please fold this change into misc-next branch?

Thanks,
Qu


--P4I2bHAEcYnwPQe7SDkwICllJp5rvj6sA--

--OItliVWuojXdCmefxdTAlyRbYY6gqK46X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykd+AACgkQwj2R86El
/qiL3gf9ECAbO2lDrj7CoSzT8MNhmaA9SLl3P/omXWUK0Mi3GJFuV0LksWRGy01C
rDuhn4v+2yQiBz8pErfpmkKrRPEOeyWlJ9677AGMCckAORm/LtiZajR5KZUUpj0R
g+fBbE0XjlLWBpvxWqakcUwNnhhDT0BiUg505Sa+USY3ATjHZan/N5p0Md4N6aX1
kGZz2lCtoSg9X2WnLjO/qc01931OpO8AS8WkxXG9xRnNcLd58Dxxt+7342efgDni
OvFuLb2RuHoaM4oB5WxxlKFUCv5UZgJytLOdiB98BKmu+hkc5fwYqSLjCptl7bUx
PwQDrbjh8kSuhz5smefHmmAvrs99dA==
=/TIn
-----END PGP SIGNATURE-----

--OItliVWuojXdCmefxdTAlyRbYY6gqK46X--
