Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE24C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90DC92087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbfC0OsS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:48:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:54020 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728089AbfC0OsS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:48:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 34362AFB5;
        Wed, 27 Mar 2019 14:48:16 +0000 (UTC)
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     linux-btrfs@vger.kernel.org
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
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
Message-ID: <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>
Date:   Wed, 27 Mar 2019 22:48:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190327140748.GA30466@angband.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XAkivMCY1bHQOohKDZGOYtbnjCl1KwGmw"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XAkivMCY1bHQOohKDZGOYtbnjCl1KwGmw
Content-Type: multipart/mixed; boundary="bS1dy1rD2lhuwX4quymv0xzCVDQ3tdSdK";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <cd66b736-dc8f-dbc4-5253-68117920b8ec@suse.de>
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
References: <20190327094652.16078-1-wqu@suse.com>
 <20190327140748.GA30466@angband.pl>
In-Reply-To: <20190327140748.GA30466@angband.pl>

--bS1dy1rD2lhuwX4quymv0xzCVDQ3tdSdK
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
> How often does this happen in practice?  I'm slightly incredulous about=

> btrfs-progs crashing often.   Especially that pwrite() is buffered on t=
he
> kernel side, so we'd need a _kernel_ crash (usually a power loss) to br=
eak
> consistency.  Obviously, a potential data loss bug is always something =
that
> needs fixing, I'm just wondering about severity.

Here is a valid case where a crash could cause transid error:

- transaction 1
  new em at 16K (fs root, gen =3D 1)
  new em at 32K (extent root, gen =3D 1)
  new em at 48K (tree root, gen =3D 1)
  sb->fs root =3D gen 1
  sb->extent root =3D gen 1
  sb->tree root =3D gen 1

- transaction 2
  new em at 64K (extent root, gen =3D 2)
  new em at 80K (tree root, gen =3D 2)
  sb->fs root =3D gen 1 at 16K
  sb->extent root =3D gen 2
  sb->tree root =3D gen 2

- transaction 3, half backed due to error commit transaction
  new eb at 16K (tree root, gen =3D 3) submitted

In above case, we will write the newest eb at 16K to disk, but with sb
from transaction 2.

Then sb expects to read out a tree with gen 1, but get a tree with gen 3.=

Further more, even we ignore the generation mismatch, the content of em
16K is completely wrong, super block of gen 2 expects fs root content
from em at 16K, but its content is tree root.

This should explain the severity much better.

Thanks,
Qu

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
>=20
>=20
> Meow!
>=20


--bS1dy1rD2lhuwX4quymv0xzCVDQ3tdSdK--

--XAkivMCY1bHQOohKDZGOYtbnjCl1KwGmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlybjSwACgkQwj2R86El
/qgElwf/Q5i0ZApJZHNQB9jvO4CyWT7tPJsAj5FLyqLkT6oaIsYOBLtnzSqYtRDX
ssTbOvkcuoDEaPU+BROnUuUVdY3/AUlLxxkiOIWlGeYppEbMaCoZlJxGDc/McN5D
awDX99WrdCzqQ4dRkbkKysDHBUyyCLRMRsWqU8+8NQ3JOlGtqTq8F1KJ7mFx67hX
DOshxoOeUAAVdUMa3VAOOIjrul9AppbFMHkPF6cYf152Xj//kNz8BDIvGilY/z28
4SIRisf8XfrIJJW8RVzPRHRYFpx9FyYdja3pN4t+zMQkqMq6Ub2Skl+ZDjezow5Q
vfZwFMTIV57Pz4QIovoAwly+zMP7ZA==
=IfLQ
-----END PGP SIGNATURE-----

--XAkivMCY1bHQOohKDZGOYtbnjCl1KwGmw--
