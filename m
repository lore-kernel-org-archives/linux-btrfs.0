Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB7CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 964542087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Wsl2TyPk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfC0OkJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:40:09 -0400
Received: from mout.gmx.net ([212.227.17.21]:36827 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbfC0OkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:40:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553697601;
        bh=VhOMpyuyL9jwHHZzRH/2hKkfIFeJtt28UsS7OEj5FGI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Wsl2TyPkLjvpsNKyEXhgB2EOJjdi1+jljcplZR4+QFgm9nnOw7o+7BbTLMPlxss94
         1ZpXj0duPNAaLIaFksTYBjfHmiERrbaaHoskZpE2RHOV1EeaISTV9tMxl2jsS7YUWS
         k2+UsRG7aReoVp9x500AMIxUESYw2yYlk2Miij9k=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Ld4xA-1gieel1nG4-00iB3M; Wed, 27
 Mar 2019 15:40:01 +0100
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
To:     Adam Borowski <kilobyte@angband.pl>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
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
Message-ID: <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>
Date:   Wed, 27 Mar 2019 22:39:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190327140748.GA30466@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qOL8uRpX8uZWMDqjZPH670RZ66DrCx7yl"
X-Provags-ID: V03:K1:ATifuBJdMLntfXBmYp2Cu2ZQgJO3CZVWRCkHeyy0MlxTyOU9+Pz
 obV9e33I6npv/vi7lFaL0oPiYAWx2qliAZNPvb52r5/5xxL4UfTGCs8r9M9eKQkbTfXkrVE
 rk+jB+6vaJEswvKB0gwWNbx3RQTnbGOkqgP6SIcmRu0Ql+GDv2+ZYBwy++GxWNR5hPHIP1c
 Q0EPuck4Rt+OjJbd+jzMg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:lu/h4vsT1j8=:jnCJyKsxAlvIik1+IodLNp
 jfRv6ma9p7YCVmPl13So1NVkVTsJN3MX3YLLYsNtO0L/QettPmksLEeOwWN4SRggQ9tJmRGjY
 J4SAGquCn+T8EPJIv8drOygaqfB4D8+eS7QYvGjWUoKLHs5ZT5h70faDUH3Lb+h/BMC5Glw/k
 Y8MF8aYOpkacVCG+8JEUnFF2dSSqO2FAlWRp5jhIZojYi1k719VZKN7uhFfUcjhJFlR6SL4jc
 +T+SLqWGuhF6QxRp5VWZ10E9G3yEtQ7kC5tmM15f2WJih6bV+f/x+1fSyYc+SpdOToMdsE5TG
 nyxgk2HEOVRYYPMp5oDVeQwMCquMUhD5/5+Ku7gHin7jM5CplAIKMfF+p4CTadz8zHuHPPUEB
 dHs9L8NjDguSFBTjU7mxycpr3FjedH3U05OgNHA7Gei229+sb01m+GSiMU6t5PUxj4f8D6D6W
 tpbx6czYjM01USLZnKJnUaUehLBO54ndOq+or+cjs4Oe676JJ3pk6akAr4YIWoSNFyZufz8oZ
 hfCYb+sfXOi5dIjVp38vGPLKAceTdwIWqsRNe6Qd9lRz8/sUukAHcvakpSH7OYzvLwpkH6qEu
 0ONb8o42B5bAYANytPMZj1641d0QvKx+YUWY8e5nAQUgxjgkd6hL7y71tYrbxU6WvapG+p0pN
 VsqPhb7TNgYcl+maETNQbb1lzG+HzAUs0rFzOIdvhGqeS3zH4OpIO4V5FFwUSOAvtXDa4QJVA
 yuEEnkQlW7FoePy+ebccidtq9uMj8CXsnT74gLTmI8d0o+KepUqMvOj2vtUFGNdMOk/O9jqFa
 Af1ixJ+CvLSj8oNrh/JIkXP/C/0o5VwvTY/VRmR4eXje9dteDcrKOsoak7JnhwYWGTCecP8ib
 K2w16YJAGXaGib0ITO/X2GE93yswUd4nio4BwRkAJ9/lpuMYR7Z1NnylWqkFxv
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qOL8uRpX8uZWMDqjZPH670RZ66DrCx7yl
Content-Type: multipart/mixed; boundary="x9wHMA3GMJ2rs7AyA5lzLLShLaPHwmyQs";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Adam Borowski <kilobyte@angband.pl>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
In-Reply-To: <20190327140748.GA30466@angband.pl>

--x9wHMA3GMJ2rs7AyA5lzLLShLaPHwmyQs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/27 =E4=B8=8B=E5=8D=8810:07, Adam Borowski wrote:
> On Wed, Mar 27, 2019 at 05:46:50PM +0800, Qu Wenruo wrote:
>> This urgent patchset can be fetched from github:
>> https://github.com/adam900710/btrfs-progs/tree/flush_super
>> Which is based on v4.20.2.
>>
>> Before this patch, btrfs-progs writes to the fs has no barrier at all.=

>> All metadata and superblock are just buffered write, no barrier betwee=
n
>> super blocks and metadata writes at all.
>>
>> No wonder why even clear space cache can cause serious transid
>> corruption to the originally good fs.
>>
>> Please merge this fix as soon as possible as I really don't want to se=
e
>> btrfs-progs corrupting any fs any more.
>=20
> How often does this happen in practice?

As long as some BUG_ON() triggers, it's highly possible some transid
error will happen.

>  I'm slightly incredulous about
> btrfs-progs crashing often.
We're making progress enhancing btrfs-progs, but just check the recent
mail list, there is a report of clear free space cache v1 causing
transid error:
https://lore.kernel.org/linux-btrfs/c59ce3ee-b0cd-f195-9dfa-11abd362d057@=
gmx.com/

And that's clear cache making the transid problem more serious.

Adding to this, we still have a case where bad cacheing em could lead to
BUG_ON (*), I think btrfs-progs currently is only safe for RO operation,
not heavy write operations.

*: The fix is already submitted:
https://patchwork.kernel.org/patch/10840313/


> Especially that pwrite() is buffered on the
> kernel side, so we'd need a _kernel_ crash (usually a power loss) to br=
eak
> consistency.  Obviously, a potential data loss bug is always something =
that
> needs fixing, I'm just wondering about severity.

Oh, I see the point.
But there is some case still very concerning:

- Trans 1 get committed, write the following ems:
  em at 16K (fs root, gen =3D 1)
  em at 32K
  em at 48K

- trans 2 get committed
  em at 64K (fs root, gen =3D 2)
  em at 80K

- trans 3 get half committed
  em at 16K (fs root, gen =3D 3)

only trans 2 get its super block written to kernel, trans 3 get aborted
before writing super block due to whatever the reason is.

And you can see in that case, kernel will write:
 em at 16K (newer gen)
 em at 32K
 em at 48K
 em at 64K
 em at 80K
 sb at 4K (gen =3D 2)

Then sb 2 will points to older fs root (gen =3D 1), but at that location,=

we have fs root with gen =3D 3.

Causing the fs unable to be mounted.

>=20
> Or do I understand this wrong?
>=20
> Asking because Dimitri John Ledkov stepped down as Debian's maintainer =
of
> this package, and I'm taking up the mantle (with Nicholas D Steeves bei=
ng
> around) -- modulo any updates other than important bug fixes being on h=
old
> because of Debian's freeze.  Thus, I wonder if this is important enough=
 to
> ask for a freeze exception.

I can't help for packaging at all.
As I'm an Arch user, just like a lot of reporters here. (And "I'm using
Arch" here is not a meme).

Personally I understand Debian has its policy, but really for
btrfs-progs, we really like the upstream version.

Thanks,
Qu

>=20
>=20
> Meow!
>=20


--x9wHMA3GMJ2rs7AyA5lzLLShLaPHwmyQs--

--qOL8uRpX8uZWMDqjZPH670RZ66DrCx7yl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlybizkACgkQwj2R86El
/qgS2ggAjR15YRJLiaNSqvMNqdsPPsuVHcHa/ApyCsfhBOMz/4HaDXxIj+iU+Xw2
SjASwttTRnfAS09KsLOc5ovFm4wPeMmm2j1xZm0Lkx3w4IjTTBe6XbplRJ0kLuGT
ERsO+jDb4Aszge/DfWVNf36uHSJU/rhcsFxJGtuCtxFX1mulEMShpFzUwiGxVGbi
3nPGRb9qrmxfHlnk4Ynj6ZXwqW/b/IbiQcR3iD9CWepRNx2CM5XjouVd5rIbpI8Q
ozBidL5ZQ3l7UwyxOmzYCU3OyZTBb9lFrf3P4lriuldlmzssjfAIlIPIECLOazpG
zKoKF7HDmUrkiwBK17nzRNFnNkW5sA==
=dFYl
-----END PGP SIGNATURE-----

--qOL8uRpX8uZWMDqjZPH670RZ66DrCx7yl--
