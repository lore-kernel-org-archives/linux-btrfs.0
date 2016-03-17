Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:46124 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbcCQIjd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 04:39:33 -0400
Date: Thu, 17 Mar 2016 13:39:28 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: parent transid verify failed on snapshot deletion
Message-ID: <20160317133928.1a214bdc@natsu>
In-Reply-To: <CAJCQCtQr66+5ufqom-DMoJDuT+fkg20mbvz+je2cUZ43i3Zneg@mail.gmail.com>
References: <20160312204847.2092f3f3@natsu>
	<20160312221524.646e1a66@natsu>
	<20160313142428.377b51b8@natsu>
	<pan$a52ce$b1beae3d$57f5b99c$a796a0ec@cox.net>
	<20160313222442.1fa22a57@natsu>
	<CAJCQCtSnSm355BC-hVRL9NnRLxXiYQefbepvm2yfTXd6PdLghw@mail.gmail.com>
	<20160314015554.544ee05c@natsu>
	<CAJCQCtQr66+5ufqom-DMoJDuT+fkg20mbvz+je2cUZ43i3Zneg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/6r_fUOLrjY2Mv7Cc0f3ib4h"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/6r_fUOLrjY2Mv7Cc0f3ib4h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 13 Mar 2016 15:52:52 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> I really think you need a minute's worth of kernel messages prior to
> that time stamp.

There was no messages a minute, or even (from memory) many hours prior to t=
he
crash. If there was something even remotely weird or block-device or
FS-related, I would've of course included it with the original report.

--=20
With respect,
Roman

--Sig_/6r_fUOLrjY2Mv7Cc0f3ib4h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlbqbUMACgkQTLKSvz+PZwidpQCfd0lzqvj69HB02x225Zn9tNTb
/xIAn2WwkYS4yUq4OQSt0N/zGSf+WEux
=Wh8N
-----END PGP SIGNATURE-----

--Sig_/6r_fUOLrjY2Mv7Cc0f3ib4h--
