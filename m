Return-Path: <SRS0=fefs=YF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C17C47404
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27624214E0
	for <linux-btrfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJLAei (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 20:34:38 -0400
Received: from shelob.surriel.com ([96.67.55.147]:35894 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfJLAei (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Oct 2019 20:34:38 -0400
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <riel@shelob.surriel.com>)
        id 1iJ5Md-0006Bt-AZ; Fri, 11 Oct 2019 20:34:31 -0400
Message-ID: <311cb7cc8998b153cfa6a4cf6e3723754d719e0d.camel@surriel.com>
Subject: Re: [PATCH] fs: use READ_ONCE/WRITE_ONCE with the i_size helpers
From:   Rik van Riel <riel@surriel.com>
To:     Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, viro@ZenIV.linux.org.uk, jack@suse.cz,
        linux-btrfs@vger.kernel.org
Date:   Fri, 11 Oct 2019 20:34:30 -0400
In-Reply-To: <20191011202050.8656-1-josef@toxicpanda.com>
References: <20191011202050.8656-1-josef@toxicpanda.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-NKizRVlxhnKsb8IONnHF"
User-Agent: Evolution 3.34.0 (3.34.0-1.fc31) 
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-NKizRVlxhnKsb8IONnHF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-10-11 at 16:20 -0400, Josef Bacik wrote:
>=20
> and this works out properly, we only read the value once and so we
> won't
> trip over this problem again.
>=20
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Rik van Riel <riel@surriel.com>
--=20
All Rights Reversed.

--=-NKizRVlxhnKsb8IONnHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAl2hH5cACgkQznnekoTE
3oMtAAf/c3rrD4m+bh26/ghFXZSuR6+H8wnw6B4cBy7wZ+KeNKSuNW/VbYkyHvda
FCk875pDQcVKhZ0+YkdGPpEj56nzgoBu7m5z+VBqi4soRK4UuVGbpO1CzQ0aPCih
9ZBusAH2+V7NL84Febb0+03U/RbPVI100h5luVZUk0XlgCRegCD2aGn1qyU4CQjt
7qFr1l+H9rP9BHFjMFSWxAaeakBfeStBFeVnIuOxoowu/fcXPTrc8A762ZMCzLTZ
sUuKv/BG6+NLV/T6OlQ50ZAmnSienqvpBKkJr8QAmLAizmREW86TK0xpq0JFtzX7
CpgaTxf6D50unYe5uRqNB+WKAOrCxg==
=LWDG
-----END PGP SIGNATURE-----

--=-NKizRVlxhnKsb8IONnHF--

