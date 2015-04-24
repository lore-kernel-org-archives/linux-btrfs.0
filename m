Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50498 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbDXOmu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 10:42:50 -0400
Date: Fri, 24 Apr 2015 14:42:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Cc: "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: Re: rollback of a snapshot is just read-only
Message-ID: <20150424144249.GW18187@carfax.org.uk>
References: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DA@XCH11.scidom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vAr1W/eR4LdSeo08"
In-Reply-To: <15785B7E063D464C86DD482FCAE4EBA501CAC3EF69DA@XCH11.scidom.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--vAr1W/eR4LdSeo08
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2015 at 04:08:24PM +0200, Lentes, Bernd wrote:
> Hi,
> 
> it should be just a small problem, but it is one. How can I rollback to a snapshot of my root filesystem ?
> Googeling, I found a lot of solutions, each different.
> I finally choosed this one: https://btrfs.wiki.kernel.org/index.php/UseCases#I_want_to_be_able_to_do_rollbacks_with_Btrfs
> 
> I made the snapshot, changed some configuration, and afterwards I'd like to rollback to the snapshot:
> 
> - btrfs subvolume snapshot -r  /  /.snapshots/vor_nvidia

   You made a read-only snapshot.

> - change some configuration
> 
> - btrfs subvolume set-default 625 (id of the snapshot)
> 
> - reboot

   ... so it's going to be read-only when you try using it as your
root FS. :)

> My /-folder is again the old one, that's ok. The change of the configuration has disappeared. But it is just read-only:
> pc63422:~ # touch /test
> touch: cannot touch '/test': Read-only file system
> 
> mount says:
> 
> ...
> /dev/sda1 on /  type btrfs (rw,ssd,space_cache)
> ...
> 
> It seems to be rw !?

   There's a bit of an awkward distinction here: subvolumes (and hence
snapshots) have a read-only property which is entirely independent of
the mount flags. So you've got a read-write mount (i.e. the VFS will
allow a write attempt, and pass it down to the FS), but that part of
the FS is itself read-only (so the FS will complain).

   What you should probably be considering is not using set-default,
but instead using mount options (subvol=/path) to select the subvolume
you want to mount. If you want to make a read-only snapshot into a
read-write one, you can simply snapshot it again without the -r
option.

   Hugo.

-- 
Hugo Mills             | Reading Mein Kampf won't make you a Nazi. Reading
hugo@... carfax.org.uk | Das Kapital won't make you a communist. But most
http://carfax.org.uk/  | trolls started out with a copy of Lord of the Rings.
PGP: E2AB1DE4          |

--vAr1W/eR4LdSeo08
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVOlZoAAoJEFheFHXiqx3ktRcP/jjR2jXGXYPS7PwTdq/RnBQE
NSU6zj8Um3tpkwQPMWFLF0pSdI0H9L5hZyHk6Eb3Nd/qqo4Xyumo9DdznMtQ+7KR
yTx5fItXPvcEOBmHEJBuHlbnAy6wg9ElAPtgUoIkK1L1Oha1IVUpmp9NWH6Ila7l
6tMY1Lc/gMhX5hSq0Xf/c/rKE4cPHYYGLV3FYFoTLspFiRoL8C+ZbOOooBovM2vI
hmVgCdpKhoD1anOljxai6rRdjQjZhUmlgKxnJr1ckYQ8nIYlmNlKG/r8vtdyiziB
/GOwQB+PnY4oAH8geVfOMpgydwnam3ZNSLwAww9/k84wRBZFI0+JO5+bzXzkd+p1
Suz463HSv6+jAoWPtFuVZP66OxymInP9ycPpDtigNzPnyGperdrJVbHyRZ9SF6xU
JtyK9lF6FZGr07MTJbvmbERqfo4onlO6Sj7hAM6VkZy1L1cJIPafRQ+Cd9hyZPAJ
D77WFmkUwULugnitTf8Uvb6QhkOen04yPClJ5eMekx139fUE93CWe5U4JlWI1ARM
SvJGGOUTME3orZb9kvy/941m4UiaqtzYDY3a8DIYTDaJqgXLTddZaK1rYWyZV7p8
WaIcGmGW+Hkt8ag5GKyGusrmwwtRqVPnWTmdRXTlCvECQ5NHNT0PVneTtpjERySV
jNehtDRXQLP5Epqr8i0t
=BYNo
-----END PGP SIGNATURE-----

--vAr1W/eR4LdSeo08--
