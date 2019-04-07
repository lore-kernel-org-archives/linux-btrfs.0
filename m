Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03622C10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E4F21738
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfDGHIx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:08:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60472 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfDGHIw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Apr 2019 03:08:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6D602AE63;
        Sun,  7 Apr 2019 07:08:50 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] block: Add new BLK_STS_SELFTEST status
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20190406103759.6330-1-wqu@suse.com>
 <20190407070451.GA32498@infradead.org>
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
Message-ID: <41acfcc7-1971-88a0-e34d-00fc34a5c190@suse.de>
Date:   Sun, 7 Apr 2019 15:08:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190407070451.GA32498@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PUq8pNMavZveXAPBShXfjk4WKu24F4nL1"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PUq8pNMavZveXAPBShXfjk4WKu24F4nL1
Content-Type: multipart/mixed; boundary="8RwIKB0avcbaxwEYXq1ir8IVqO76JVa91";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Message-ID: <41acfcc7-1971-88a0-e34d-00fc34a5c190@suse.de>
Subject: Re: [PATCH v2 1/2] block: Add new BLK_STS_SELFTEST status
References: <20190406103759.6330-1-wqu@suse.com>
 <20190407070451.GA32498@infradead.org>
In-Reply-To: <20190407070451.GA32498@infradead.org>

--8RwIKB0avcbaxwEYXq1ir8IVqO76JVa91
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/7 =E4=B8=8B=E5=8D=883:04, Christoph Hellwig wrote:
>> +	[BLK_STS_UCLEAN]	=3D { -EUCLEAN,	"structure needs cleaning" },
>=20
> The subject line doesn't mention this new error code.  That being said
> while this sounds slightly less bad than the original name it still
> sounds weird..
>=20
> The various filesystems really use EFSCORRUPTED which is just mapped
> to EUCLEAN, so maybe this really should be
>=20
> 	[BLK_STS_FSCORRUPTED]	=3D
> 		{ -EUCLEAN, "file system corruption detected" },
>=20
> But then again I really wonder why you need to pass this information
> through a blk_status_t to start with.  In general these kinds of error
> should be passed through file system specific errno fields.
>=20

For functions called in endio hook, we return blk_status_t.
Or for case like hook before submitting bio, we set bio->bi_status to
record it.

Yes, it's possible to restore such info into fs specific structure, but
why not reuse the bi_status we all use and love?

Thanks,
Qu


--8RwIKB0avcbaxwEYXq1ir8IVqO76JVa91--

--PUq8pNMavZveXAPBShXfjk4WKu24F4nL1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlypofsACgkQwj2R86El
/qievAf/RxZZtCLLqIUmLYM9GZymwXoR01+FDz7K5Y57itgqM1N0yveNQWGMlEHT
ZvvGpsb8kRmtwP8aEnkFh9aoS0nlJpEBt+Xx5sWS+fF+zTaRY0zsWQkSUbAscXRe
SZIWGidmo2t1Nq/OuPUAfu4+p604TiFeYUOEbp+ywcX/YznwrekDiATHgDXsKqbl
WKDjHQ+Ugy7QhG+sCYeyxr+XGDlNvzFe9kbK4TS1h5ep+maGxMvRPVlSqTh/vlZv
2jCp9nzr4WhArFKQYhieCoYkAiJiegpn0swQTdkWekdskQmfk0WojXcZxaElj/J0
G7rvMw8MZLTDhUzZriCjRwXL7IbCug==
=9OsA
-----END PGP SIGNATURE-----

--PUq8pNMavZveXAPBShXfjk4WKu24F4nL1--
