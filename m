Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.93.76]:32796 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbbDCHRB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:17:01 -0400
Date: Fri, 3 Apr 2015 12:16:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Message-ID: <20150403121656.35782bda@natsu>
In-Reply-To: <551E3C06.9040305@cn.fujitsu.com>
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
	<pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
	<551E3C06.9040305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.NMA6/ThWVmqZkmfhBWVJbB"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/.NMA6/ThWVmqZkmfhBWVJbB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Apr 2015 15:06:46 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> >> +WARNING: If one hopes to rollback to ext2/3/4, he or she should not e=
xecute

It also seems a bit awkward to spell out "he or she", if you want to refer =
to
a user without specifying the gender, in software documentation it's more
common to use "they": https://en.wikipedia.org/wiki/Singular_they

--=20
With respect,
Roman

--Sig_/.NMA6/ThWVmqZkmfhBWVJbB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUePmgACgkQTLKSvz+PZwgxHwCeIZBlLeJ8BpXMsrHNu9wCnT1d
8msAn2nG7kkv+29oBqzVPyd5q0gG7Mnj
=iuuL
-----END PGP SIGNATURE-----

--Sig_/.NMA6/ThWVmqZkmfhBWVJbB--
