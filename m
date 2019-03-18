Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC936C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4EF72173C
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 19:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfCRTyf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:54:35 -0400
Received: from mout.gmx.net ([212.227.15.19]:55329 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfCRTyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 15:54:35 -0400
Received: from thetick.localnet ([77.47.110.32]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MRWzQ-1hU4kz3fSK-00ScSy for
 <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 20:54:33 +0100
From:   Marc Joliet <marcec@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Balancing raid5 after adding another disk does not move/use any data on it
Date:   Mon, 18 Mar 2019 20:54:26 +0100
Message-ID: <3329335.FRGrtYsUPj@thetick>
In-Reply-To: <6a8b2244-46c1-7754-145c-b7a71f1f1b73@knorrie.org>
References: <7a713010-5db6-2627-2593-8e13092868b1@husak.pro> <f3082d89-ee37-b421-0bb3-ff2e28cc31af@husak.pro> <6a8b2244-46c1-7754-145c-b7a71f1f1b73@knorrie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5577179.tPCZqqqJme"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Provags-ID: V03:K1:zzK4CxU7OGqBEd049IuzOwkfInKbzBqEOrzJ82v4qToyRQ/n4cY
 7Wro5LfugnObeVIIS5ZaaY/0JzBt7bkYPiMXye0/Epu5U/pM0dXBf269B0hmTa2u+wqzm70
 lq9ZS6K1gTmhBtIxGqd2ZzXYKvXSPCNdaHRkvCYDhvqKHpTkRmA0TN5Opg/RpcKQPjjLcOC
 GBTE+SYpwbX5oUUEL0lsA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:U1B8Mgugewc=:5u6+iKEFxlEB+L0a8Ov733
 iG0+0/LjrrHmdqUve4xHH2cXgak5YYuTjwrxNqbiK3Rf3DyCkcD9xGSAdRVe09KuqVZal14kY
 ivJV52rfJf/eiACHaVqmOp1+B/9lqPN13Kv7lb6U+JgOKFNI/5Yiom8dGiUUGK3sS1WnwXRc9
 nUuZBvZI6+KsXygkk82bQzDS/BsiRfzv2Bns+YfBgGtQqjoi/vTOLYJuDD+eHGlEe67zALmv4
 JrsjpFPwUKD0ZCb7k6qXOwVOsZILObZ1mHu96s689F3/xplidxcCA4+tJ0IpKzpjFGijVJd3z
 Upe+EhNAgp5m68TxQb70hvQQuWDLwByc01s87WCN6lO9/cDCHXJHnq4fxpgeQcVmN9AnWu24w
 aa9PNmhnPz9ZFpwJIy7Ybl4l8bHPNI0py4jmj+FoKAjACRDmfMEFoxdj03vP7qmiTTWA/kMPz
 pPlNzh5bs2Af6JRrIdEmOh9c6E5LKJRR6spofzyOJ45HlHGXzpegxh4zi97H55TfzMZMApXAn
 FA5pqMBPbzWd0Zs1i4/7ESbfi2PwT1lgd/X136+DIxY4QvzUIZrjn5oWCgUT/9g7ExwsBDhoL
 koVOrhYrfoA/8r4kc7aUaE+u2G9u1J71DRv2xyyRayP0N9fKWJYL+E/9mUAlxuvpP/dHyISY8
 kawwPfqRNYs5nuane2iMpxigtB5wQFRyAp3zbBJE6x7R7EEZSY+e6A97cFdsDxPLPXlSCZFkC
 pmiypnqqeqV1G2W8YcW8Yr9DBVidWNQke7kvlKHifbq20lbvM6hBPWbXeT70GAWzOnnGenmpl
 +V9wIoEtHqNuPjQnrvcJP/0BhPQlVg1MwiA2Mb4DVxo8QiFsVvLcojbWIyeahv/k+BEJC1S6Y
 T/2Xogwf5LHMe4/KEkY44NjUYeKWBk1yBIiWV0RJ++VnGP7hBsNgkDfsFXtzOw
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--nextPart5577179.tPCZqqqJme
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Sonntag, 17. M=C3=A4rz 2019, 23:53:45 CET schrieb Hans van Kranenburg:
> My latest thought about this was that users use
> pip to have some library dependency for something else, so they don't
> need standalone programs and example scripts?

My current understanding is that that Python land kinda wants everybody to =
use=20
pip to install anything written in Python (except the science people, who=20
gravitate more towards conda, though it can wrap pip for software not packa=
ged=20
natively).  So yeah, it's perfectly natural to install scripts with pip,=20
though I forgot where exactly in setup.py you have to specify them.

Examples include SCons (which is also distributed via pip), various linters=
=20
such as flake8, and test frameworks such as nose which also come with scrip=
ts=20
needed to drive them.

(Also, I seem to remember that there are provisions for specifying examples=
=20
separately from regular scripts, but I forgot the specifics.)

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart5577179.tPCZqqqJme
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAlyP93IACgkQv9DmhiyI
ePQ87xAAl4q2u1FnvuXN67qEgaoPyy+HDlSoXElI06+bm3W0x2KlQrR7N6uFA7kJ
Rt/7FoHYN6B4fcDUue5ccdT+K9AEopA2UiXLZY6vjDaH7TbDlwBy5Wc97f4a/M2y
qDtp8a4aYpX+7z4WnnE275FtksJuKVr9l+oLIKPrGLQaDTW7Bv2N3zbwosd87Tik
NhFPyhx1lYPzs2zeCHnDv2MHDjriAvaxIlE9Xt7dPZt5sBrf041DY4dOFZZCHzdI
vYeBYOJVQ9NbUtuqXxLJA9NcK6Sdcs4C5E1KcMutA/4PWUkkEGMV8gW6AOy3VCHp
ys/gW7eSAnJRq2WX4cY/ulBtVL+j4TgnChYr56veinQ7jucAiSI41eegdgTU2xA/
7xgJNcGnQQchVsakyEq/H7e6g7LIkrJDSw1fbrY48hUe06I6iNxtKRwj2rzK0t3n
XAkNfIht9YdtfPPAy16RVIdrtFvni7F+gn9F6ig5iDJms1z1k8yWQScbmlRIUPKg
eSNZ/TWibm2jpt84/hA5slulr0pZFhbP1PVQwU27hmvu0CirWv6hoFcL1A6Rn29f
qZnppgZ7DniNgPwXxwSjyVTUB73I6OC9c7PlW897d81sJqXKJzw4ZRWZ+4Hqzc/k
PJnNwJ+5Yi1cZKvQ1eRzoyGZgzcFXmJMnTQcD1mBcxvZgem1hXs=
=SLx4
-----END PGP SIGNATURE-----

--nextPart5577179.tPCZqqqJme--



