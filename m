Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mari.romanrm.net ([157.7.203.202]:37955 "EHLO mari.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaGTTgR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 15:36:17 -0400
Date: Mon, 21 Jul 2014 01:36:09 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: TM <tmjuju@yahoo.com>, linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Message-ID: <20140721013609.6d99c399@natsu>
In-Reply-To: <53CC1553.1020908@shiftmail.org>
References: <loom.20140720T102642-239@post.gmane.org>
	<53CC1553.1020908@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4/vEyKgwSQ8RubYmSwW8tbi"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/4/vEyKgwSQ8RubYmSwW8tbi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jul 2014 21:15:31 +0200
Bob Marley <bobmarley@shiftmail.org> wrote:

> Hi TM, are you doing other significant filesystem activity during this=20
> rebuild, especially random accesses?
> This can reduce performances a lot on HDDs.
> E.g. if you were doing strenous multithreaded random writes in the=20
> meanwhile, I could expect even less than 5MB/sec overall...

I believe the problem here might be that a Btrfs rebuild *is* a strenuous
random read (+ random-ish write) just by itself.

Mdadm-based RAID would rebuild the array reading/writing disks in a complet=
ely
linear manner, and it would finish an order of magnitude faster.

--=20
With respect,
Roman

--Sig_/4/vEyKgwSQ8RubYmSwW8tbi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlPMGikACgkQTLKSvz+PZwhHxwCcDTfZt26R1n6D1gsZHnqN/P+8
fYgAn0aMKMgZBVRRB16nrqfzceXz/Pb7
=u7m8
-----END PGP SIGNATURE-----

--Sig_/4/vEyKgwSQ8RubYmSwW8tbi--
