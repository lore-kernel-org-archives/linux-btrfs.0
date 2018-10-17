Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F86ECDE30
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 051652083A
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 10:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 051652083A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbeJQSZ1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 14:25:27 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:30982 "EHLO
        smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbeJQSZ1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 14:25:27 -0400
Received: from [78.43.137.104] (helo=Michaels-MacBook-Pro-3.local)
        by smtprelay01.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <michael_post@web.de>)
        id 1gCi6v-0003qL-OU; Wed, 17 Oct 2018 11:27:25 +0200
Subject: Re: Urgent: Need BTRFS-Expert
To:     Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
From:   Michael Post <michael_post@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=michael_post@web.de; prefer-encrypt=mutual; keydata=
 xsBNBFHnksUBCACvM/mCgOrWiJ2rzvjm6t4hJtJ9UQYso+Hb7zvy7cVtfDcQA7Bm3JfGNwNW
 k1VHdCgdHokbzo/bqX2GRP/IDmbYCW0FCuxu2PeZ3gIHp+3baEhdAzjKgqfxb/VAb6+q26Lu
 h9nzujBMmbvcz9pXk/yvirBdjZckI1xOo8Q0EMOv4yFQ/zHBVhYnuqN8HAkxq1FPvACYpCSw
 pGBQXb/auoT2+jLy3vT+dxSPWdzgOeAWI3eEKsQ66wHDw98U1q75T7SvxrFtLvXZ3m7QhagJ
 9ChoCRAXBgvwbu/0SFXytmW4Rm4f2b5WU716qNyK20hMsM8iqgSyZIG4jFNa44SmO68lABEB
 AAHNKE1pY2hhZWwgUG9zdCA8bWljaGFlbC5wb3N0QHB1cmVtYXRpYy5kZT7CwH0EEwEKACcC
 GwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AFAlRbh4YFCSvWSsEACgkQUXp8TpPfYDxX9gf/
 a1UYBgGXfAnfMe0g6upNTplxL+HJfLiKtA6foyZBbOLV52JNO/8a6E4Bfw0RgM+EMaQfuHIQ
 ZIXHOwTItT7b3uEqaHVqbQ/tIXK0hzmGbBihZ8m/sFUEgY7QTQQvJ78ERUdl+jH+fLHhVkJt
 Nxl0Od13ewhEUpvGIM34MRXqb6pkH1yuAlYmOfup9f6kKSE5OME303CsbsfEkVKyR1sZRoc6
 isK9z1BGA795RtimQ4xi4oEa1fe1fuMhFbf8XUbKwCWIZx3gfzxBvzixLeaYNtZSopl0vFgv
 dZZbW/K0yFWgR3XtFVY5UaydMxkmNHReCT0V6gBwmx+uP9OIzl+HLc7ATQRR55LFAQgAvwcz
 w/z+UBw6ZxmmFSXIcWhsJNjLjaBN0X6TCh/OZUVqwEwcREfd0FcSw3erZf7GUvtIxiORRIms
 YposKnCMRqcVZAue9X7p11Rvi12xXzFSjLL0sfanIi0LCYF10UgcCEG+s7uW/YUPHjltGcgH
 jJDDZTRY0gV+MlQWFxr6Pesys/yTHWueo85ZEkUGAAwhrxTkA1RGHys6Ru3yNeTw1sQy6bjO
 d1yy3hBPQ7thES9/hCrK4rF8GhcTxCVh+Ut2wvtFMAdNB48g5NqIDudaLY26Nv5XNkaW46Uf
 3OsXMSDW/M6aFIU/5NioFv+DkXHLjR05V/8t0AXJEx3ivpIq1QARAQABwsBfBBgBCgAJBQJR
 55LFAhsMAAoJEFF6fE6T32A8FJQH/1o3mMGvr8ztCHJvXpDJCBwI+gouQeaWBrpBoFHHRtp0
 9qqImrgOUgYsOcUIy3Q9keuv+ZtE6Pz/SdBepj/BHu7ZljYybAKHHmfP/VJfCarGFCVXiPVt
 wSGZFul0W/ZJqETfZK4FVU5C48KCVNrgbTuUxFdjK3gT9lIaiGNehGj78pUJwp/a30Yj2Njf
 0aniHuNrWykrUagNJPeAb3RvNTX4e+X7P+LxlVB7gqBgUUkM0EpPS6Vq5r7Pb2Z9shQw22PP
 tVPSS4Bie8tVfyvussJEw5lndUPFjAMLX91Uyju1HbvvUvZM3qxJrW8ADR04nltwdtIY+VD6
 y8uexxux4zg=
Message-ID: <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
Date:   Wed, 17 Oct 2018 11:27:24 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181017091820.GE16380@carfax.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Y77aYkgoNzanFrRsveBEvP5SGCVdzoSzj"
X-Df-Sender: bXlfbWljaGFlbHBvc3RAcHVyZW1hdGljLmRl
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Y77aYkgoNzanFrRsveBEvP5SGCVdzoSzj
Content-Type: multipart/mixed; boundary="03Td9qauyzaUxVhXTY8igO2UaeLQbY10d";
 protected-headers="v1"
From: Michael Post <michael_post@web.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Message-ID: <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
Subject: Re: Urgent: Need BTRFS-Expert
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
In-Reply-To: <20181017091820.GE16380@carfax.org.uk>

--03Td9qauyzaUxVhXTY8igO2UaeLQbY10d
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hello Hugo,

thanks for your information.

I have an 1 TB BTRFS-Partition which suddenly could not be mounted.

I tried the following commands


host@:btrfs check -b /dev/mapper/vg0-virtualbox
=2E...
Errors found in extent allocation tree or chunk allocation
bytenr mismatch, want=3D1263661723648, have=3D0




host@:btrfs rescue super-recover -y  /dev/mapper/vg0-virtualbox
All supers are valid, no need to recover


Then i did
btrfs rescue chunk-recover -y  /dev/mapper/vg0-virtualbox
This commands fails after around 2.5 hours with the messages, that it
could not recover the chunc tree.

What are the next possibilities?

Greetings,

Michael


--03Td9qauyzaUxVhXTY8igO2UaeLQbY10d--

--Y77aYkgoNzanFrRsveBEvP5SGCVdzoSzj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Thunderbird - https://www.enigmail.net/

iQEzBAEBCgAdFiEEmxB90zjUALsjw+n2UXp8TpPfYDwFAlvHAHwACgkQUXp8TpPf
YDzeiwf+LrYCul/BE7goPPKgi5OUAPtzGz5l7KsiYWPpXzm0GRR9pjA55qmHvqFZ
6B2YWQ650Ynw2RYEskaxBKAfH0Xy8VjI2sZbhdsyX1xntUc7zOlHP/GxjKThPnba
vkoGoHXNHPvE6ifjNEzSM8+af+9WGtVGy4Sbtu5XNEY578OIME9J1zheRtwAh5x/
6bGzJPiuv1hbU3JsHsE6FLHpYJtPJQngCLHI5UCxVGL8EDAekMb3Zj7jzhyvpI7G
1ZHxzyANTlYHadLlXzo35XxqYye0eKF7/IPfwzuS6bvbLtSuCCW19MmN8wpZxtlu
vug5DE2k0jzNtjmp+0B2Ew4YByRFjw==
=pIbt
-----END PGP SIGNATURE-----

--Y77aYkgoNzanFrRsveBEvP5SGCVdzoSzj--
