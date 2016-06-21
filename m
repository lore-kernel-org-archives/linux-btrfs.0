Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48076 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbcFUMTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 08:19:55 -0400
Date: Tue, 21 Jun 2016 08:19:53 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Is "btrfs balance start" truly asynchronous?
Message-ID: <20160621121953.GO15597@hungrycats.org>
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
 <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2O+9B+xSKalj/wdD"
In-Reply-To: <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2O+9B+xSKalj/wdD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 21, 2016 at 07:24:24AM -0400, Austin S. Hemmelgarn wrote:
> (for example, you can't easily start a balance on a remote
> system via a ssh command, which is the specific use case I have).

Wait, what?

	ssh remotehost -n btrfs balance start -d... -m... /foo \&

or

	ssh remotehost -f btrfs balance start -d... -m... /foo

It even works with systemd's auto-kill feature (send btrfs balance all the
SIGKILLs you want, the kernel just ignores them).


--2O+9B+xSKalj/wdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldpMOkACgkQgfmLGlazG5z8PgCeJNkNrFfnjAmvCSgf+aMBwnVu
B58AoMtANRpgBvSHR3Hi05Fq9H33V6wi
=ui/N
-----END PGP SIGNATURE-----

--2O+9B+xSKalj/wdD--
