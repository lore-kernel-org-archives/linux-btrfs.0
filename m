Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:58678 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbcJJSmk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 14:42:40 -0400
Date: Mon, 10 Oct 2016 23:42:27 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Martin Dev <mrturtledev@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: csum failed during copy/compare
Message-ID: <20161010234227.69746d3f@natsu>
In-Reply-To: <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com>
References: <CAG6KGPS8Gvy2zGCe22mMmk4uXrqVyRP8FHayhe0ph-8vC+kA4A@mail.gmail.com>
        <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/W5T5Oi50Cxg4+rRuwjFcqJE"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/W5T5Oi50Cxg4+rRuwjFcqJE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Oct 2016 10:44:39 +0100
Martin Dev <mrturtledev@gmail.com> wrote:

> I work for system verification of SSDs and we've recently come up
> against an issue with BTRFS on Ubuntu 16.04

> This seems to be a recent change

...well, a change in what?=20

If you really didn't change anything on your machines and the used process,
there is no reason for anything to start breaking, other than obvious hardw=
are
issues from age/etc (likely not what's happening here).

So you most likely did change something yourself, and perhaps the change was
upgrading OS version, kernel version(!!!), or versions of software in gener=
al.

As such, the first suggestion would be go through the recent software updat=
es
history, maybe even restore an OS image you used three months ago (if
available) and confirm that the problem doesn't occur there. After that it'=
s a
process called bisecting, there are tools for that, but likely you don't ev=
en
need those yet, just carefully note when you got which upgrades, paying
highest attention to the kernel version, and note at which point the
corruptions start to occur.

> as the same process has been used for the last 2 years

--=20
With respect,
Roman

--Sig_/W5T5Oi50Cxg4+rRuwjFcqJE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlf74RYACgkQTLKSvz+PZwiVngCfa5h+hEufYUB2acLAorf/OyqP
KFEAn1zdaONgbdL4p8Ll8R+ixPMmNXnk
=RMy0
-----END PGP SIGNATURE-----

--Sig_/W5T5Oi50Cxg4+rRuwjFcqJE--
