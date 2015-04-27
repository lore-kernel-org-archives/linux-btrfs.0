Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38413 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbbD0MPW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 08:15:22 -0400
Date: Mon, 27 Apr 2015 12:15:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs freeze/thaw when using with LVM2
Message-ID: <20150427121521.GB18187@carfax.org.uk>
References: <loom.20150427T140306-446@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M+mJV+fSrF9QWN+i"
In-Reply-To: <loom.20150427T140306-446@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--M+mJV+fSrF9QWN+i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2015 at 12:05:28PM +0000, sri wrote:
> Hi,
> 
> I would like to know if btrfs file system is created on LVM2 logical 
> volumes, does freeze and thaw operations takes place for btrfs to make 
> file system consistent??

   No, because the filesystem is *always* consistent, because of the
way that the CoW update mechanism works.

> If not is there a way (ioctl etc..) to run btrfs freeze/thaw before and 
> after creating LVM2 snapshot of a btrfs file system?

   As I said above, none is needed.

   HOWEVER, you shouldn't take LVM snapshots of a btrfs filesystem AT
ALL, if you have the original FS mounted on that system, or if you
plan on mounting the FS or its snapshots on that system. It's fine if
the only things mounting it are independent of the base system, and
don't see the snapshots (e.g. you're exporting LVs as block devices to
a VM host, and the snapshot is never seen by the VM; or you're
exporting LVs via NBD, and the remote system never sees the
snapshot).

   If, on the other hand, you're expecting to have /dev/mapper/foo
mounted, and then take a snapshot of it on the same system, you can
expect massive filesystem corruption, because the kernel can't
distinguish between the original block device and the snapshot, and
may try using the wrong one (or possibly both).

   Hugo.

-- 
Hugo Mills             | Someone's been throwing dead sheep down my Fun Well
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                          Nick Gibbins

--M+mJV+fSrF9QWN+i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVPihZAAoJEFheFHXiqx3kYRMP/2JtwrCfPn4ROTLsGTcpbWmr
ic7a9EdHhYExY5eR26EBfnH2zJfkjTqAZiGVC6ILI4ITBDn/eYo8oG9z9s2/qGj2
wzu4dyw4fi1KCpItpilHadGUOvKdJHr+BLfkPLkhof2NGnjIPwweYd01inaYsvnp
o8kDqrJDokujVf6tzdPRKHKaNEyjpxlIdQn8YVxCxrf+QsW1bCQ/qQ9KZaZfWYO2
tz3znD6PnXnYQcB7+VITxd+4BfjNvt+VwAfXyMtaRVaLBvcEPf93kcCdSErv3XPx
7MCu7t98ERsiErYq55vMFzdcBX8PpvputZK3a0c60G7dwONjrVUkn0BMAuPD9zQW
ZxNVVoOq8G7bJzVM74Mz/P2IDqn02kMabYjS1xBEoFXhQOJ0RimUf+vl9//RTXcp
A/nV2mR3GRCAE4EQSYeiN/DUZsUeo7kDwFhEUBZH+J3bC8GSpykt7tN3wgBDcnu8
V7Gl8jXRfwki4ZauF8l9iq9mXHppIVKFpp4/6llaa09C82Ra6jjYF7/DivWWS3oe
ZlFvqqXeu6FAGjcIpne6YBTFKgRiHeJXlYmgEp/BNm7QgUrrsvEbGIuWMUPgptoK
00SEjB4Yy5UPxC37VDrnbJ3nJ7kWZhrRkDC1ETrah5eDA+XHyY5bTV1Ig4JKf8nQ
TuvALmDCxj3D+PPLpA3T
=0Eiu
-----END PGP SIGNATURE-----

--M+mJV+fSrF9QWN+i--
