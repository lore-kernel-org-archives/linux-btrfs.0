Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:58996 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753209AbcJLH0P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 03:26:15 -0400
Date: Wed, 12 Oct 2016 12:25:51 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Chris Murphy <lists@colorremedies.com>, ce3g8jdj@umail.furryterror.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Austin Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: RAID system with adaption to changed number of disks
Message-ID: <20161012122551.27d949ee@natsu>
In-Reply-To: <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
References: <D379E551-1272-4548-9601-0CE4C1A8C012@unige.ch>
 <20161011160601.GI7683@carfax.org.uk>
 <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pWpvXqIj+BhsGi=qdvcaUi1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/pWpvXqIj+BhsGi=qdvcaUi1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2016 17:58:22 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> But consider the identical scenario with md or LVM raid5, or any
> conventional hardware raid5. A scrub check simply reports a mismatch.
> It's unknown whether data or parity is bad, so the bad data strip is
> propagated upward to user space without error. On a scrub repair, the
> data strip is assumed to be good, and good parity is overwritten with
> bad.

That's why I love to use Btrfs on top of mdadm RAID5/6 -- combining a mature
and stable RAID implementation with Btrfs anti-corruption checksumming
"watchdog". In the case that you described, no silent corruption will occur,
as Btrfs will report an uncorrectable read error -- and I can just restore =
the
file in question from backups.


On Wed, 12 Oct 2016 00:37:19 -0400
Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:

> A btrfs -dsingle -mdup array on a mdadm raid[56] device might have a
> snowball's chance in hell of surviving a disk failure on a live array
> with only data losses.  This would work if mdadm and btrfs successfully
> arrange to have each dup copy of metadata updated separately, and one
> of the copies survives the raid5 write hole.  I've never tested this
> configuration, and I'd test the heck out of it before considering
> using it.

Not sure what you mean here, a non-fatal disk failure (i.e. within being
compensated by redundancy) is invisible to the upper layers on mdadm arrays.
They do not need to "arrange" anything, on such failure from the point of v=
iew
of Btrfs nothing whatsoever has happened to the /dev/mdX block device, it's
still perfectly and correctly readable and writable.

--=20
With respect,
Roman

--Sig_/pWpvXqIj+BhsGi=qdvcaUi1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlf95YIACgkQTLKSvz+PZwhQsQCfWGRDhQeNEltuc85M/8ZghQpP
mDQAn3siPdirAySnPUayH2GNyaKJtvqb
=WdM+
-----END PGP SIGNATURE-----

--Sig_/pWpvXqIj+BhsGi=qdvcaUi1--
