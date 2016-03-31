Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:51882 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbcCaIBm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 04:01:42 -0400
Date: Thu, 31 Mar 2016 13:01:37 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to cancel btrfs balance on unmounted filesystem
Message-ID: <20160331130137.6b130aa0@natsu>
In-Reply-To: <20160331062112.GT9342@torres.zugschlus.de>
References: <20160331062112.GT9342@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/L316v.2yhRIkFuvY0yOH/7G"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/L316v.2yhRIkFuvY0yOH/7G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Mar 2016 08:21:12 +0200
Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:

> the balance restarts immediately after mounting

You can use the skip_balance mount option to prevent that.

--=20
With respect,
Roman

--Sig_/L316v.2yhRIkFuvY0yOH/7G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlb82WMACgkQTLKSvz+PZwja2gCglWrUZ4H6r3pZQ7GTBuafdRTP
a4kAmwfv1txV87GrsPuUvx0acKjqn8E4
=XpNt
-----END PGP SIGNATURE-----

--Sig_/L316v.2yhRIkFuvY0yOH/7G--
