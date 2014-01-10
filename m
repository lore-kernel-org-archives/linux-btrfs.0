Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.229.20.24]:37998 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaAJPRG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 10:17:06 -0500
Date: Fri, 10 Jan 2014 21:16:59 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: backpointer mismatch
Message-ID: <20140110211659.2bc9e1d7@natsu>
In-Reply-To: <pan$d701f$adb6e087$f10cdac$a6ccb243@cox.net>
References: <52CF7032.3090004@oma.be>
	<pan$d701f$adb6e087$f10cdac$a6ccb243@cox.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hmM9YBRd37fDNo+s.1iWar_"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/hmM9YBRd37fDNo+s.1iWar_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jan 2014 14:26:19 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> IOW, your backups shouldn't be btrfs, because btrfs itself is testing,=20
> and any data stored on it is by definition testing-only data you don't=20
> particularly care about, either because you have good tested-restorable=20
> backups, or because the data really isn't that valuable to you in the=20
> first place.=20

On the contrary, I think a backup storage area is an excellent place to sta=
rt
rolling-out btrfs from, because:

1) the snapshot capability allows to do your backups using simple full-mirr=
or
tools such as rsync or mirrordir in incremental mode, propagating only chan=
ges
in the directory tree (and then make and keep a number of date/timed snapsh=
ots
with some automation of your own);

2) it's *backups*, by definition it's non-unique replaceable data that also
exists elsewhere (and in this case on the primary storage, that's probably
much less experimental and more redundant as well).

My primary storage is currently Ext4 and backups are all on btrfs.

--=20
With respect,
Roman

--Sig_/hmM9YBRd37fDNo+s.1iWar_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLQDusACgkQTLKSvz+PZwjEFACePLjT6tCebhoTJ4LhmY1D0Z8Z
vzUAnR9D0dZjtUb0gAFwrUn4PGmWhyVw
=Rlzg
-----END PGP SIGNATURE-----

--Sig_/hmM9YBRd37fDNo+s.1iWar_--
