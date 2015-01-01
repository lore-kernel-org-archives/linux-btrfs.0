Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36551 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750752AbbAAIWa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Jan 2015 03:22:30 -0500
Date: Thu, 1 Jan 2015 03:22:27 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Dave Stevens <geek@uniserve.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: should I use btrfs on Centos 7 for a new production server?
Message-ID: <20150101082227.GB13116@hungrycats.org>
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
In-Reply-To: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2014 at 07:29:10PM -0800, Dave Stevens wrote:
> I have a well tested and working fine Centos5-Xen system.
> Accumulated cruft from various development efforts make it desirable
> to redo the install. Currently a RAID-10 ext4 filesystem with LVM
> and 750G of storage. There's a hot spare 750 drive in the system.
>=20
> I'm thinking of migrating the web sites (almost the only use of the
> server) to a spare then installing Centos-7 and btrfs, then
> migrating the sites back.
>=20
> I see RH marks btrfs in C7 as a technology preview but don't
> understand what that implies for future support and a suitably
> stable basis for storage.
>=20
> The demand on the system is low and not likely to change in the near
> future, storage access speeds are not likely to be dealbreakers and
> it would be nice to not need to use LVM, btrfs seems to have a
> better feature set and more intuitive command set. But I'm uncertain
> about stability. Anyone have an opinion?

If you need the kind of reliability where you can set up a server and turn
your back on it for years, don't use btrfs.  Even ext4 is risky for that.

If you have a farm of machines, working backups and fail-over, or you
are running a development box and can tolerate downtime or data loss,
then by all means test btrfs on them.  If you have a server, singular,
and downtime is a problem, then btrfs is not for you.

It has been 4 days since my last full btrfs filesystem rebuild on
a server.  That one was running kernel 3.17.7 when it failed.  The
previous one was 81 days ago.

You will still need LVM so you can split your raw disks into smaller btrfs
filesystems so that you can replace individual btrfs filesystems when
(not if) they irretrievably corrupt themselves under heavy write loads.

You'll probably also want to create a LVM snapshot whenever you run
btrfs check so you can roll back in case 'btrfs check --repair' makes
things worse.

btrfs can handle random corruption well, but corruption due to kernel
bugs is usually irreparable.  The btrfs tools are able to recover from
previously fixed known bugs, but not the unknown new bugs.

If your filesystem is mostly read with few writes then btrfs will last
longer between catastrophic failures--maybe even long enough for a
three-year server service lifecycle.

> Dave
>=20
> --=20
> "As long as politics is the shadow cast on society by big business,
> the attenuation of the shadow will not change the substance."
>=20
> -- John Dewey
>=20
>=20
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSlA8MACgkQgfmLGlazG5ygygCbBENGHfq5bGWRoROcdib+d/lo
EaIAn334HURpgCDNVEzvP5MA4kpsk+g4
=+lj2
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
