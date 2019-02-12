Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4219C282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B1D21773
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 07:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfBLH5j (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 02:57:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:42388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725916AbfBLH5j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 02:57:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5011DAC71;
        Tue, 12 Feb 2019 07:57:37 +0000 (UTC)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Remi Gauvin <remi@georgianit.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>
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
Message-ID: <b4897bdc-628f-8930-90ef-62b9bbf08e1b@suse.de>
Date:   Tue, 12 Feb 2019 15:57:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4uuynD3RKvgePGuXzeIX6qYaQxnSjg7sx"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4uuynD3RKvgePGuXzeIX6qYaQxnSjg7sx
Content-Type: multipart/mixed; boundary="qCXcofz69ydhdLxHxL6V4azz97R87mk1F";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Remi Gauvin <remi@georgianit.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <b4897bdc-628f-8930-90ef-62b9bbf08e1b@suse.de>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>
In-Reply-To: <406ce62a-6ff4-af73-b7fb-69733ccdbdc1@georgianit.com>

--qCXcofz69ydhdLxHxL6V4azz97R87mk1F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/12 =E4=B8=8B=E5=8D=883:55, Remi Gauvin wrote:
> On 2019-02-12 2:47 a.m., Qu Wenruo wrote:
>>
>>
>> Consider this use case:
>>
>> One btrfs with 2 devices, RAID1 for data and metadata.
>>
>> One day devid 2 got failure, and before replacement arrives, user can
>> only use devid 1 alone. (Maybe that's the root fs).
>>
>> Then new disk arrived, user replaced the missing device, caused SINGLE=

>> or DUP chunks on devid 1, and more importantly, some metadata/data is
>> already in DUP/SINGLE chunks.
>>
>=20
>=20
> Maybe the btrfs-replace command can have some magic logic attached that=

> checks for single/dup chunks after completion and either launches an
> automatic convert, or prompts the user that one is probably needed?

The problem is, how btrfs-progs know which chunks are old existing
chunks and which are new chunks created by balance?

I considered this method, but kernel fix without creating unnecessary
chunks are way more cleaner.

Thanks,
Qu
>=20
>=20
>=20


--qCXcofz69ydhdLxHxL6V4azz97R87mk1F--

--4uuynD3RKvgePGuXzeIX6qYaQxnSjg7sx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxifG4ACgkQwj2R86El
/qjB8wf+IqeUAcA0rfX9f03/FXGl3vmdDg9bVD2DxsK2soOozUY6iFtaHuIVq52h
6cibZtA3AB2M9eI02IM6e39JoPNgrCBjiGjm8DhJr/mWQZPSShSz5bTvBDQkaQHe
QmrihOoKISr3hMCnsSVb5n62XOM5VGHFEMNxOygEx0rX7sm5B/trh98EWlrE9ejG
gBhEWgWDdeMlaCtzyy6ywX2yX2ZoGewgX3SJNNMb+NiqFMecivpcFk/xvsRSxPwp
WVTOjwnLakceZh89LyJUZFas3qwUpsFNOSia8BSfb7eFwsA736vNPZDcXKMAkQ6k
VHM6b2XVoM2ttgEYjdUXc/9PPSet7A==
=RGbV
-----END PGP SIGNATURE-----

--4uuynD3RKvgePGuXzeIX6qYaQxnSjg7sx--
