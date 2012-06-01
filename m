Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tulsa-1.icequake.net ([65.38.17.15]:42482 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933193Ab2FAOs4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 10:48:56 -0400
Received: from localhost (aurora [127.0.0.1])
	by mail.icequake.net (Postfix) with ESMTP id 2590CFCB2
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2012 09:39:02 -0500 (CDT)
Received: from mail.icequake.net ([127.0.0.1])
	by localhost (aurora.icequake.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9TqgD0TKP8G5 for <linux-btrfs@vger.kernel.org>;
	Fri,  1 Jun 2012 09:38:59 -0500 (CDT)
Received: from localhost (ma65636d0.tmodns.net [208.54.86.166])
	by mail.icequake.net (Postfix) with ESMTPSA id 088FCFCAD
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jun 2012 09:38:58 -0500 (CDT)
Date: Fri, 1 Jun 2012 09:38:57 -0500
From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Several unhappy btrfs's after RAID meltdown
Message-ID: <20120601143857.GB25227@localhost.localdomain>
Reply-To: nemesis@icequake.net
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
 <20120207154225.GD5639@localhost.localdomain>
 <20120207174645.GE5639@localhost.localdomain>
 <20120207174907.GF5639@localhost.localdomain>
 <20120212163134.GA15216@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
In-Reply-To: <20120212163134.GA15216@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


I made a little bit of progress recovering this mess, seems
btrfs-progs has improved since I last tried.

# ./btrfs-find-root /dev/mapper/tr5ut-vicep--library
[..]
Well block 317865713664 seems great, but generation doesn't match, have=3D5=
74372, want=3D575931
Well block 317874491392 seems great, but generation doesn't match, have=3D5=
75930, want=3D575931
Found tree root at 317874626560

Seems like this is a good sign that btrfs-find-root was able to find
the root.

But I'm still stuck on this trying to run btrfs-restore:

# ./btrfs-restore -v -i -u 1 -t 317874626560 /dev/mapper/tr5ut-vicep--libra=
ry .
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
checksum verify failed on 317874630656 wanted 491D9C1A found FFFFFFA6
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
Csum didn't match
btrfs-restore: disk-io.c:441:
find_and_setup_root: Assertion `!(ret)' failed.
Aborted

It seems like -i should ignore the csum mismatch, what am I missing?

--=20
Ryan C. Underwood, <nemesis@icequake.net>

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPyNQBIonHnh+67jkRAqGpAKCC1T8g+Yhij4nDlueYkP9VgZxJoQCeIL13
a0xgnIb8mOqdMAKiHRYuWKM=
=IJor
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
