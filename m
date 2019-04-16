Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C389C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 00:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 525D32084B
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 00:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfDPABs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 20:01:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:33642 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbfDPABr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 20:01:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C09C1AD85
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 00:01:45 +0000 (UTC)
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190412154653.GG3476@twin.jikos.cz>
 <259b0c00-cee0-32ae-aa27-4b981d64b8cb@suse.de>
 <20190415165048.GC22216@twin.jikos.cz>
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
Message-ID: <8589cbe9-9074-f1f3-2e60-477ba108f81c@suse.de>
Date:   Tue, 16 Apr 2019 08:01:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190415165048.GC22216@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ceKuepOU7cx1QjqNCUHCsWvPdwkNRvZmC"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ceKuepOU7cx1QjqNCUHCsWvPdwkNRvZmC
Content-Type: multipart/mixed; boundary="GYyUasSGvtLk681VrwQuvqRnsTwN2whCa";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <8589cbe9-9074-f1f3-2e60-477ba108f81c@suse.de>
Subject: Re: [PATCH v3.1 1/9] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
References: <20190404064537.4031-1-wqu@suse.com>
 <20190404064537.4031-2-wqu@suse.com> <20190412154653.GG3476@twin.jikos.cz>
 <259b0c00-cee0-32ae-aa27-4b981d64b8cb@suse.de>
 <20190415165048.GC22216@twin.jikos.cz>
In-Reply-To: <20190415165048.GC22216@twin.jikos.cz>

--GYyUasSGvtLk681VrwQuvqRnsTwN2whCa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/16 =E4=B8=8A=E5=8D=8812:50, David Sterba wrote:
> On Sat, Apr 13, 2019 at 07:48:51AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/12 =E4=B8=8B=E5=8D=8811:46, David Sterba wrote:
>>> On Thu, Apr 04, 2019 at 02:45:29PM +0800, Qu Wenruo wrote:
>>>> +struct btrfs_ref {
>>>> +	enum btrfs_ref_type type;
>>>> +	int action;
>>>> +
>>>> +	/*
>>>> +	 * Only use parent pointers as backref (SHARED_BLOCK_REF or
>>>> +	 * SHARED_DATA_REF) for this extent and its children.
>>>> +	 * Set for reloc trees.
>>>> +	 */
>>>> +	bool only_backreferences:1;
>>>
>>> I renamed this to only_backrefs and was surprised that there were no
>>> compilation errors, ie. this member is not used at all ...
>>
>> Yep, for callers who really uses this member, they just set @parent, a=
nd
>> that's all.
>=20
> So there's nothing in the old and new code that uses it, then why do yo=
u
> add it? If this is for some existing patchset then ok, keep it there bu=
t
> otherwise remove it.

It should be removed.
My bad, at the time of writing, I didn't get the point that @parent is
enough to info to use SHARED_BLOCK_REF_KEY.

Would you mind to fold this removal?

Thanks,
Qu


--GYyUasSGvtLk681VrwQuvqRnsTwN2whCa--

--ceKuepOU7cx1QjqNCUHCsWvPdwkNRvZmC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly1G2YACgkQwj2R86El
/qjfiwf7BstvjwjyWZMRPrlL969OfQ/qf6IySZH/0YcNumOrDTlPRA/cOAkz9nHd
ELKN84sJWfvsWTyjr+JZODEmGGv3BeqAQwBiW/g0mpGFvX3MxxI4WMUhkavax7do
LajrdwGClRs4FEZzo+S9an/ZL46FPSQyUvNUBD4gwV7KzhZaXKKmykqNRaTZzcXr
MMJOqheYjEGa54E3nub5lfMuDkno0Ug42zaNSj1Sw5fHji/b6tp6/uxkbGFNvc4m
Elxl4XK8cT32ocsnzyiEWUPViWhR/8GzGMe5AfO1dQ4GO9rPQ3+i/tguxQpnhj5d
otg6TXXCvDiHAnqBuH6My3Y3Zn/WTQ==
=RVzH
-----END PGP SIGNATURE-----

--ceKuepOU7cx1QjqNCUHCsWvPdwkNRvZmC--
