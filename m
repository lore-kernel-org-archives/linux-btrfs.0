Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21790C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4FBB2087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfC0Om2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:42:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:50658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbfC0Om2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:42:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C9393AFB5;
        Wed, 27 Mar 2019 14:42:26 +0000 (UTC)
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Adam Borowski <kilobyte@angband.pl>
Cc:     linux-btrfs@vger.kernel.org
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
 <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>
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
Message-ID: <73ce2851-2456-d344-4ed3-757ba2c8baa1@suse.de>
Date:   Wed, 27 Mar 2019 22:42:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Nm4FCdjkR1Z76EvR9mnJxwJAfGP118IF2"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Nm4FCdjkR1Z76EvR9mnJxwJAfGP118IF2
Content-Type: multipart/mixed; boundary="wypuHqrQOW0U3iMZYNNj2dLEBmG2RUOgu";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <73ce2851-2456-d344-4ed3-757ba2c8baa1@suse.de>
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
 <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>
In-Reply-To: <7fbf45e1-2431-a8f9-1a91-0560bdc6d57c@gmx.com>

--wypuHqrQOW0U3iMZYNNj2dLEBmG2RUOgu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/27 =E4=B8=8B=E5=8D=8810:39, Qu Wenruo wrote:
>=20
>=20
> On 2019/3/27 =E4=B8=8B=E5=8D=8810:07, Adam Borowski wrote:
>> On Wed, Mar 27, 2019 at 05:46:50PM +0800, Qu Wenruo wrote:
>>> This urgent patchset can be fetched from github:
>>> https://github.com/adam900710/btrfs-progs/tree/flush_super
>>> Which is based on v4.20.2.
>>>
>>> Before this patch, btrfs-progs writes to the fs has no barrier at all=
=2E
>>> All metadata and superblock are just buffered write, no barrier betwe=
en
>>> super blocks and metadata writes at all.
>>>
>>> No wonder why even clear space cache can cause serious transid
>>> corruption to the originally good fs.
>>>
>>> Please merge this fix as soon as possible as I really don't want to s=
ee
>>> btrfs-progs corrupting any fs any more.
>>
>> How often does this happen in practice?
>=20
> As long as some BUG_ON() triggers, it's highly possible some transid
> error will happen.
>=20
>>  I'm slightly incredulous about
>> btrfs-progs crashing often.
> We're making progress enhancing btrfs-progs, but just check the recent
> mail list, there is a report of clear free space cache v1 causing
> transid error:
> https://lore.kernel.org/linux-btrfs/c59ce3ee-b0cd-f195-9dfa-11abd362d05=
7@gmx.com/
>=20
> And that's clear cache making the transid problem more serious.
>=20
> Adding to this, we still have a case where bad cacheing em could lead t=
o
> BUG_ON (*), I think btrfs-progs currently is only safe for RO operation=
,
> not heavy write operations.
>=20
> *: The fix is already submitted:
> https://patchwork.kernel.org/patch/10840313/
>=20
>=20
>> Especially that pwrite() is buffered on the
>> kernel side, so we'd need a _kernel_ crash (usually a power loss) to b=
reak
>> consistency.  Obviously, a potential data loss bug is always something=
 that
>> needs fixing, I'm just wondering about severity.
>=20
> Oh, I see the point.
> But there is some case still very concerning:
>=20
> - Trans 1 get committed, write the following ems:
>   em at 16K (fs root, gen =3D 1)
>   em at 32K
>   em at 48K
>=20
> - trans 2 get committed
>   em at 64K (fs root, gen =3D 2)

Slightly wrong, in trans 2, fs root is not updated.

So please discard this mail, I'll resend a better version.

Thanks,
Qu

>   em at 80K
>=20
> - trans 3 get half committed
>   em at 16K (fs root, gen =3D 3)
>=20
> only trans 2 get its super block written to kernel, trans 3 get aborted=

> before writing super block due to whatever the reason is.
>=20
> And you can see in that case, kernel will write:
>  em at 16K (newer gen)
>  em at 32K
>  em at 48K
>  em at 64K
>  em at 80K
>  sb at 4K (gen =3D 2)
>=20
> Then sb 2 will points to older fs root (gen =3D 1), but at that locatio=
n,
> we have fs root with gen =3D 3.
>=20
> Causing the fs unable to be mounted.
>=20
>>
>> Or do I understand this wrong?
>>
>> Asking because Dimitri John Ledkov stepped down as Debian's maintainer=
 of
>> this package, and I'm taking up the mantle (with Nicholas D Steeves be=
ing
>> around) -- modulo any updates other than important bug fixes being on =
hold
>> because of Debian's freeze.  Thus, I wonder if this is important enoug=
h to
>> ask for a freeze exception.
>=20
> I can't help for packaging at all.
> As I'm an Arch user, just like a lot of reporters here. (And "I'm using=

> Arch" here is not a meme).
>=20
> Personally I understand Debian has its policy, but really for
> btrfs-progs, we really like the upstream version.
>=20
> Thanks,
> Qu
>=20
>>
>>
>> Meow!
>>
>=20


--wypuHqrQOW0U3iMZYNNj2dLEBmG2RUOgu--

--Nm4FCdjkR1Z76EvR9mnJxwJAfGP118IF2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlybi8sACgkQwj2R86El
/qgjlgf/csParcL5/nO4LxDHI5CP8SRgo1hDnjZl5A2vSJFnzNBouyaizlYiGhGj
xp63Q6vql9xuTdY0ghnngWatmucEqqX/7AsUEQTuPm/A46Tn3ujkDqZ1sAd2f4AT
XMCr/V728E4cEkiLE3LjmBSydeIBJ5CeNx3BlQFZJDz0cykR9Nj1t+wH3/acEY0b
NsetH7jVxRtcsmfPnhv3NGM0OBiKsRYCuzNHU2vfTCkXngy/AzePgiVujc4q84J6
jLVsNQl+A95EuQ8Q3FUhncadLh/uLAODtzKLk/GD/JbVW51/dQI969V2XD0X87H1
tGdtrFadYpeYp1QEXVYCIFg2PAJ5Sw==
=++sV
-----END PGP SIGNATURE-----

--Nm4FCdjkR1Z76EvR9mnJxwJAfGP118IF2--
