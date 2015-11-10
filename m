Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:37752 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbKJHzE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 02:55:04 -0500
Date: Tue, 10 Nov 2015 12:55:01 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Subject: Re: Ideas for btrfs-convert fix(or rework)
Message-ID: <20151110125501.1aa6f155@natsu>
In-Reply-To: <56418E5D.9020604@gmx.com>
References: <56418E5D.9020604@gmx.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KnXbMHvZt3SptZkitch/TVm"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/KnXbMHvZt3SptZkitch/TVm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Nov 2015 14:27:41 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

>     But without such work, btrfs-convert will always be a mess and no
>     real support for balance.

I wonder, what happened to the current btrfs-convert?

Perhaps a couple of years ago I converted a 7TB and ~70% full Ext4 filesyst=
em
into Btrfs. At first the result showed up to have about 3TB of Metadata
chunks, but several iterations of balance reclassified this as Data (and th=
us
made it practical to also enable Metadata DUP). Everything went flawlessly =
and
with no data loss whatsoever.

But as we know recently there were reports that it now causes corruption or
does not work. So I wonder what happened that broke it, and is there really=
 no
simpler fix? Even if requiring the user to balance to get rid of the bloated
Metadata like I had to.

--=20
With respect,
Roman

--Sig_/KnXbMHvZt3SptZkitch/TVm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZBotUACgkQTLKSvz+PZwhB3wCfXpNX/LSqgOOjF/SgI3e9MuK4
jfcAn1fPNXi1f/FtXSgXZ9MvOT8CsWSi
=nqin
-----END PGP SIGNATURE-----

--Sig_/KnXbMHvZt3SptZkitch/TVm--
