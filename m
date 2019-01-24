Return-Path: <SRS0=zIKm=QA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C65C282C0
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 00:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDDF218A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Jan 2019 00:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfAXADA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 19:03:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:60404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfAXADA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 19:03:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88E9BAE6E
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2019 00:02:58 +0000 (UTC)
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190123071518.2528-1-wqu@suse.com>
 <20190123174736.GW2900@twin.jikos.cz>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <4ee239b6-72c6-5c0e-8d2e-f4fa8d4e4a35@suse.de>
Date:   Thu, 24 Jan 2019 08:02:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123174736.GW2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bZ9Kazk9CFS4s3vW7D0rU8Mxu0n1SUhpa"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bZ9Kazk9CFS4s3vW7D0rU8Mxu0n1SUhpa
Content-Type: multipart/mixed; boundary="Xh0XjRMFv6bXo8iTXDim2XvGx6D4WpUq6";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <4ee239b6-72c6-5c0e-8d2e-f4fa8d4e4a35@suse.de>
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190123071518.2528-1-wqu@suse.com>
 <20190123174736.GW2900@twin.jikos.cz>
In-Reply-To: <20190123174736.GW2900@twin.jikos.cz>

--Xh0XjRMFv6bXo8iTXDim2XvGx6D4WpUq6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/24 =E4=B8=8A=E5=8D=881:47, David Sterba wrote:
> On Wed, Jan 23, 2019 at 03:15:11PM +0800, Qu Wenruo wrote:
>> v5:
>> - Use Josef's superior qgroup deadlock fix.
>>   No performance regression now.
>=20
> Does this pass fstests on your side? Namely if test btrfs/007 does not
> crash,
> https://lore.kernel.org/linux-btrfs/20190123135120.GT2900@twin.jikos.cz=
/
>=20

Also hit that bug.

Although it's not trigger by qgroup but a backref walk on current root
causing the problem.

Thanks,
Qu


--Xh0XjRMFv6bXo8iTXDim2XvGx6D4WpUq6--

--bZ9Kazk9CFS4s3vW7D0rU8Mxu0n1SUhpa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxJAK0ACgkQwj2R86El
/qjP8Af+OBOX0Nh3SB2twhCyz88DFIrV5pAXGBS+Ck9ebyQNbxezMnE/rxfRvlCL
YnFuBOT/KqcMsi//q5LXoTkAIadcdA++P1vsbrCFTWPZSImiZaYdmjvrw1a0e9Dk
uZd990OzjcmdZQxmLgj/nxkDX7mZlT+RaCV12ijJX/OArDE04CUFaF5Wj2vHmNKW
Z1gCdbEgxU0FlPIz8uywNUEVzFBcsXBvUQ1h0Diau67U9QoPQguyeOHalXc7pMtK
R2t3fUVoSQqbMTLTNisNmlCYzwQKCxGvoqFSepwbQv9rqQTb06mIfQG+Fx2gHyMw
BoF+XUyiG6b4fQv3x32g0eVuCWzvyw==
=o5M6
-----END PGP SIGNATURE-----

--bZ9Kazk9CFS4s3vW7D0rU8Mxu0n1SUhpa--
