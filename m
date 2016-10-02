Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:48430 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751229AbcJBUWe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 2 Oct 2016 16:22:34 -0400
Received: from natsu (unknown [IPv6:fd39::e9:9eff:fe8f:1bcf])
        by len.romanrm.net (Postfix) with SMTP id E610E29BEF
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Oct 2016 20:22:29 +0000 (UTC)
Date: Mon, 3 Oct 2016 01:22:25 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Unable to open ctree
Message-ID: <20161003012225.089c4d38@natsu>
In-Reply-To: <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
References: <20161002181754.wxved3j66dzrvfoc@tiamat>
        <CAJCQCtTr3tG_8YSB_8gfBkpy558HKC+cz394B0wH2Je3v9kZmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//=.KpHj6rW1jEu_QMTqzpfn"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_//=.KpHj6rW1jEu_QMTqzpfn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Oct 2016 13:29:56 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> Well short of a bug, the problem aren't the checksums. The problem is
> the metadata is wrong, so if you recalculate checksums you're likely
> end up with an even more corrupted file system because it'll start out
> trusting bad metadata.

It appears that metadata got created with profile "single", because the dev=
ice
is SSD. If this was DUP metadata, this entire problem wouldn't happen.
It is a terrible idea to downgrade metadata to single on detecting SSDs at
mkfs. The original rationale was that "SSDs will deduplicate it anyways", b=
ut
there are many ways things can corrupt way before reaching the SSD (from the
point of view of which it will look like the computer sent two different
metadata blocks, if one got corrupted in flight), and secondly, the ability=
 of
SSDs to perfectly deduplicate small 4K sized pieces of data at hundreds of
megabytes in read/write speeds is VASTLY overestimated here.


--=20
With respect,
Roman

--Sig_//=.KpHj6rW1jEu_QMTqzpfn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlfxbIUACgkQTLKSvz+PZwiclACfQwjdG75jZiph5vCN0NHaoc7Z
CpQAn3qcOqU5ChLfkOLYCmYYlk4Dj2aW
=WIzd
-----END PGP SIGNATURE-----

--Sig_//=.KpHj6rW1jEu_QMTqzpfn--
