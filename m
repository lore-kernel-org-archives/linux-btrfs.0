Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:40558 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3JRQLS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 12:11:18 -0400
Date: Fri, 18 Oct 2013 22:11:15 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Josef Bacik <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix up seek_hole/seek_data handling
Message-ID: <20131018221115.460375f7@natsu>
In-Reply-To: <1382111301-3116-1-git-send-email-jbacik@fusionio.com>
References: <1382111301-3116-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n9iNa7LTojA2p2VEhylDYM+"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/n9iNa7LTojA2p2VEhylDYM+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Oct 2013 11:48:21 -0400
Josef Bacik <jbacik@fusionio.com> wrote:

> Whoever wrote this was braindead.

You do realize you sent a number of people googling for "Delalloc is such a
pain. If we have a hole and we have pending" just out of curiosity? :))

--=20
With respect,
Roman

--Sig_/n9iNa7LTojA2p2VEhylDYM+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlJhXaMACgkQTLKSvz+PZwiMDQCgg8Gw3qBdfeiQ1DaR9cd/DVen
av4An33mAasGfVhYh1VflrdxO/UkcQV7
=khMt
-----END PGP SIGNATURE-----

--Sig_/n9iNa7LTojA2p2VEhylDYM+--
