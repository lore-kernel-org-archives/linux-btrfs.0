Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A22C432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 06:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73D232064A
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 06:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438681AbfIXGOz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 02:14:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49376 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438592AbfIXGOz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 02:14:55 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id D37F180602; Tue, 24 Sep 2019 08:14:38 +0200 (CEST)
Date:   Tue, 24 Sep 2019 08:14:52 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs compression: check string length
Message-ID: <20190924061452.GA31397@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

AFAICT, with current code user could pass something like "lzox" and
still get "lzo" compression. Check string lengths to prevent that.

Signed-off-by: Pavel Machek <pavel@denx.de>

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b05b361..1083ab4 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -51,7 +51,7 @@ bool btrfs_compress_is_valid_type(const char *str, size_t=
 len)
 	for (i =3D 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
 		size_t comp_len =3D strlen(btrfs_compress_types[i]);
=20
-		if (len < comp_len)
+		if (len !=3D comp_len)
 			continue;
=20
 		if (!strncmp(btrfs_compress_types[i], str, comp_len))

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2JtFwACgkQMOfwapXb+vImNgCeIrP68oJefLVVShRBFhny/37h
274AniqO9oCZ36VAfgTLlXl+FJ7vSZm8
=MF++
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
