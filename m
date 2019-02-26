Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DDFC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 05:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9C42147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 05:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfBZFz0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 00:55:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:57226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725879AbfBZFzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 00:55:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EBC96ABDC
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2019 05:55:23 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: balance: Sync the fs before balancing
 metadata chunks
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190129065739.31707-1-wqu@suse.com>
 <20190225172118.GA24609@twin.jikos.cz>
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
Message-ID: <3e574c54-f714-424e-78bb-4a251a864153@suse.de>
Date:   Tue, 26 Feb 2019 13:55:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190225172118.GA24609@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pFoCibeEG56lnQXJcbTVq1ssJI6YXfJSY"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pFoCibeEG56lnQXJcbTVq1ssJI6YXfJSY
Content-Type: multipart/mixed; boundary="QNj34NN4aJiYahdFvLVqyPkIHX2Mt169O";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <3e574c54-f714-424e-78bb-4a251a864153@suse.de>
Subject: Re: [PATCH] btrfs-progs: balance: Sync the fs before balancing
 metadata chunks
References: <20190129065739.31707-1-wqu@suse.com>
 <20190225172118.GA24609@twin.jikos.cz>
In-Reply-To: <20190225172118.GA24609@twin.jikos.cz>

--QNj34NN4aJiYahdFvLVqyPkIHX2Mt169O
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/26 =E4=B8=8A=E5=8D=881:21, David Sterba wrote:
> On Tue, Jan 29, 2019 at 02:57:39PM +0800, Qu Wenruo wrote:
>> The most straightforward is to sync the fs before balancing metadata
>> chunks.
>>
>> We could enhance the kernel bytes_may_use calculation, but I doubt abo=
ut
>> the complexity.
>> So I take the easy fix to reduce the false ENOSPC reports.
>=20
> Agreed.
>=20
>> +	/*
>> +	 * There may be many over-reserved space for metadata block groups,
>> +	 * especially for inlined file extents.
>> +	 *
>> +	 * Do a sync here will free those over-reserved space and hugely
>> +	 * reduce the possibility of some false ENOSPC
>> +	 */
>> +	if (args->flags & BTRFS_BALANCE_METADATA) {
>> +		ret =3D btrfs_util_sync(path);
>=20
> As the fd is already open, we should use the _fd version,
>=20
>> +		if (ret) {
>> +			error("failed to sync the fs before balance: %m");
>> +			ret =3D -errno;
>> +			goto out;
>=20
> and possibly only warn if there's an error returned as the sync failure=

> is not a critical condition.

AFAIK if we can't even sync the fs, the balance is definitely going to
fail, as the most common failure mode for syncfs is RO fs, caused by
aborted transaction.

Thus I still think we should error out. Or is there some other
non-critical failure mode I missed?

Thanks,
Qu


--QNj34NN4aJiYahdFvLVqyPkIHX2Mt169O--

--pFoCibeEG56lnQXJcbTVq1ssJI6YXfJSY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx01LoACgkQwj2R86El
/qgBegf+Ojs2Cqf5MosYy1IaNrZZPeisJbcb8HzkPKgg+gGFbdrLkfo1HkQeP86X
rFkzH13POnCGvpSq3KaeNmijgcnO5V+4k/m6lyd/1Dowzbpod6nQhBEIia+AlqP+
iSKimgCbBXFy8/KiNfl2Vg+Pw3ZCGo0gaP42kb7bzun47w1Y2E/BcFezPfoc9t54
Cwx9/fZSeRoqf/DxYX1I2PX5T7EsEvxVquC+58FdPUqyzNka1+AX37NsTgGC14At
eyY/XxyoBN2SGxe21Ebxnvovlsdp10JdCGseboJ2bnYenpOB8wXXrLdvt5+8e+q+
ljLOURR+4WCT3f56SckF7r+eYzXw4A==
=GUjZ
-----END PGP SIGNATURE-----

--pFoCibeEG56lnQXJcbTVq1ssJI6YXfJSY--
