Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50564ECDE3D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D0E21476
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 13:47:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11D0E21476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbeJSVxs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 17:53:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:36654 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727004AbeJSVxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 17:53:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DAF9AF14
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 13:47:33 +0000 (UTC)
Subject: Re: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181018111729.11128-1-wqu@suse.com>
 <20181019134230.GH16290@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <9fd0eec9-10b2-d81c-3c9d-99213fb6f9d7@suse.de>
Date:   Fri, 19 Oct 2018 21:47:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181019134230.GH16290@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5Q3HzxWpG497cW2zuhsCNpCq4yyPih0FY"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5Q3HzxWpG497cW2zuhsCNpCq4yyPih0FY
Content-Type: multipart/mixed; boundary="jYrq1G72OWm2lm9S2DKxwrRM4pReMPhWH";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <9fd0eec9-10b2-d81c-3c9d-99213fb6f9d7@suse.de>
Subject: Re: [PATCH 0/6] btrfs: qgroup: Delay subtree scan to reduce overhead
References: <20181018111729.11128-1-wqu@suse.com>
 <20181019134230.GH16290@twin.jikos.cz>
In-Reply-To: <20181019134230.GH16290@twin.jikos.cz>

--jYrq1G72OWm2lm9S2DKxwrRM4pReMPhWH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/19 =E4=B8=8B=E5=8D=889:42, David Sterba wrote:
> On Thu, Oct 18, 2018 at 07:17:23PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
>>
>> Which is still based on v4.19-rc1, but with previous submitted patches=

>> as dependency.
>=20
> Please rebase this patchset on top of misc-4.20, this should not change=

> as it's going to be the 1st pull.
>=20
> I tried to pull the git branch and rebase but there were several
> conflicts and some of the paches appeared duplicated so the rebase did
> not recognize the changes as identical.

Yes, the branch has submitted qgroup patches as dependency, and it's
still based on v4.19-rc1, so conflicts are expected.

>=20
> Applying patches from mails causes other sort of conflicts and I can't
> seem to get a compilable version.

I'll look into it.

>=20
> This is not urgent as I want to put the patchset to a topic branch and
> give it some testing before it goes to for-next. Thanks.

OK, however this patchset may still need extra polish, especially for
the 2nd patch.
As you can see in the benchmark part, it reduces nearly half of dirty
qgroup extents but only cuts about 25% relocation time, that's mostly
caused by that 2nd patch, and that 2nd patch could impact balance
performance even for quota disabled case.

So I'm not eager to push it soon either.

Thanks,
Qu



--jYrq1G72OWm2lm9S2DKxwrRM4pReMPhWH--

--5Q3HzxWpG497cW2zuhsCNpCq4yyPih0FY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvJ4GwACgkQwj2R86El
/qj5tQf/R99Ph2cTV8amjJnjNNoTfaubLod/hCKUismQTQF7gPWkDtcNNdodKLnJ
Si1dIHe7mfRZUDAdapCz5Vg4cHDwo9IViP+HKBsrWtETChCR/fQpakAm1Am8lG1l
1jnfQwMhXMqgOvLlK374NIM1tshFSQAvHHsKoxEe5P5zkxDQzQOqNAaKaPcwAPyX
fmqRGLqpvT/giJIMlwz1pbQViSrtm41cCPBDRAx9srn8vO/WAkKvEDm5GGWK2Yoq
kiEv72p7IQPlaHZInpfrRz40wr/EKIgZYjIOUx0q7t24i0S2jvL0Phn7EV6o99x0
gunjC9ImghfUcJD2+kTrCQ8UxdxLqg==
=VonS
-----END PGP SIGNATURE-----

--5Q3HzxWpG497cW2zuhsCNpCq4yyPih0FY--
