Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF97ECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B64B21529
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 15:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B64B21529
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbeJQXrH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 19:47:07 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:38668 "EHLO
        smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbeJQXrG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 19:47:06 -0400
Received: from [78.43.137.104] (helo=Michaels-MacBook-Pro-3.local)
        by smtprelay01.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <michael_post@web.de>)
        id 1gCo5q-00014S-MI; Wed, 17 Oct 2018 17:50:42 +0200
Subject: Re: Urgent: Need BTRFS-Expert
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
 <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
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
Message-ID: <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>
Date:   Wed, 17 Oct 2018 17:50:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="WqhWlD2Pxx2yLNPXuatC6OFW1fndL9yLP"
X-Df-Sender: bXlfbWljaGFlbHBvc3RAcHVyZW1hdGljLmRl
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WqhWlD2Pxx2yLNPXuatC6OFW1fndL9yLP
Content-Type: multipart/mixed; boundary="6CwbbcZ5g6lYYKJBz3QoJAydcH6tfreK5";
 protected-headers="v1"
From: Michael Post <michael_post@web.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Hugo Mills <hugo@carfax.org.uk>,
 linux-btrfs@vger.kernel.org
Message-ID: <1cc35c0e-3ea2-e63f-b42e-084f44b77ffd@web.de>
Subject: Re: Urgent: Need BTRFS-Expert
References: <9996625e-df27-ab14-8192-5b28ac4ffba7@web.de>
 <20181017091820.GE16380@carfax.org.uk>
 <5691be7e-0b5e-1a80-6bdf-4ee258deeb49@web.de>
 <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>
In-Reply-To: <1e492842-18e2-cbaa-08af-fe503b9935f4@gmx.com>

--6CwbbcZ5g6lYYKJBz3QoJAydcH6tfreK5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Qu,
Hello Hugo,

i got this result when i try to recover the chunk tree.

# btrfs check /dev/mapper/vg0-virtualbox
bytenr mismatch, want=3D1263835381760, have=3D0
ERROR: cannot open file system


# btrfs rescue chunk-recover -y  /dev/mapper/vg0-virtualbox
Scanning: DONE in dev0
open with broken chunk error
Chunk tree recovery failed

Did you any clue?


Michael


--6CwbbcZ5g6lYYKJBz3QoJAydcH6tfreK5--

--WqhWlD2Pxx2yLNPXuatC6OFW1fndL9yLP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: Using GnuPG with Thunderbird - https://www.enigmail.net/

iQEzBAEBCgAdFiEEmxB90zjUALsjw+n2UXp8TpPfYDwFAlvHWlEACgkQUXp8TpPf
YDzQHgf7BLVALin5Ir/imzkQZO1zNv+JLH2bO21B7yab5uj5Yqn5xkPR/513KAcw
CDBHzC6/U2U1nSrm+aDlY+S5ZpTZIyojqLJCXVbQ5fIXsOxvueyrmPTa0VS1DWht
GbD0rUkQdAhMG4+7Zgv66pwet2x3G1svv8eL/288lXrluLDa0oNyf8MXqQMO3OOM
szFtv9xMezJci6ATfO9W113te6L/IMr608X6mB2l9AzxONPb+m3LIZkgJ5X8ujs5
XynysxLx/Wo+wvgV7W+iKM0QPfrIUOiElqiMAR9PlfZtr8ZJKsnvMhNXDHobSVif
a90vOGpLIYgSB5ce4P+8No2k+EMnbw==
=qn5D
-----END PGP SIGNATURE-----

--WqhWlD2Pxx2yLNPXuatC6OFW1fndL9yLP--
