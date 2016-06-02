Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:60378 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbcFBFQk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 01:16:40 -0400
Date: Thu, 2 Jun 2016 10:16:34 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, chris@suse.de,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v7 0/8] Inband dedupe for btrfs-progs
Message-ID: <20160602101634.55f9c1be@natsu>
In-Reply-To: <20160601213210.GK7633@wotan.suse.de>
References: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160601213210.GK7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2sE4viX1zSrkZxbDr2eUCkW"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/2sE4viX1zSrkZxbDr2eUCkW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Jun 2016 14:32:10 -0700
Mark Fasheh <mfasheh@suse.de> wrote:

> Can we please have seperate and obvious namespaces for in-band dedupe and
> out-of-band dedupe commands? I realize that there is no oob-dedupe
> funcationality in btrfs-progs today but I would like to avoid confusing
> users in the case that this code hits btrfs-progs.
>=20
> Specifically by this, I mean I'd like to see anything except 'dedupe' as =
the
> btrfs command, so a user who sees 'btrfs dedupe ....' is not confusing the
> two forms we have.
>=20
> I don't personally care what other name is used and of course it could ha=
ve
> 'dedupe' in the name just not solely 'dedupe'. As a poor example, we could
> call it 'btrfs inband-dedupe ...'.

There might be no such code added ever -- but everyone will be stuck with
typing "inband-dedupe" instead of the simple and short "dedupe" forever
because of this "future precaution".

At least make that "dedupe-inband", so that the shorthand form of "dedupe"
also works for now, and only starts throwing a warning if any other subcomm=
and
starting with "dedupe" is added.

--=20
With respect,
Roman

--Sig_/2sE4viX1zSrkZxbDr2eUCkW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAldPwTQACgkQTLKSvz+PZwg2rACfeEsfvUJHg65IBFRFq0xdRgE2
CBgAoIlvAPg+VsRPu+k2TukMTpb0ftyE
=OtRY
-----END PGP SIGNATURE-----

--Sig_/2sE4viX1zSrkZxbDr2eUCkW--
