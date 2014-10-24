Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44277 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751907AbaJXCFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 22:05:53 -0400
Date: Thu, 23 Oct 2014 22:05:50 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Check tree block failed, want=17716610236416, have=0
Message-ID: <20141024020545.GD17380@hungrycats.org>
References: <20141023231622.GC17395@hungrycats.org>
 <54499D4A.9050204@pobox.com>
 <20141024012448.GC17380@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
In-Reply-To: <20141024012448.GC17380@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 23, 2014 at 09:24:48PM -0400, Zygo Blaxell wrote:
> On Thu, Oct 23, 2014 at 05:28:58PM -0700, Robert White wrote:
> > You may be in deep error land from the long use of 3.10... that
> > said, the --init-csum-tree or --init-extent-tree options may be your
> > friend here. The backtrace shows you are in "open_ctree" so the
> > former is more likely the better bet.

Alas, both fail:

	# btrfs check --repair --init-csum-tree --init-extent-tree /dev/mapper/md15
	enabling repair mode
	Creating a new CRC tree
	Couldn't open file system

Same result with each option individually, except that when
--init-csum-tree is absent, so is the "Creating a new CRC tree" message.

I'm also trying 'btrfs rescue chunk-recover -v' but so far it has read
many gigabytes but not had much to say.

(LVM snapshots + kvm = attack this filesystem with multiple tools at once :-)

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRJs/kACgkQgfmLGlazG5z0OwCfYNTELrNhwdIIB9ej66z5DLZY
9gAAoK1PScXeuIDJNXxMgNNUatFSn3ej
=mZtT
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
