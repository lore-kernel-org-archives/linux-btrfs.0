Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41198 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbbL0Opi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 09:45:38 -0500
Date: Sun, 27 Dec 2015 14:45:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jiri Kanicky <j@ganomi.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to change BTRFS filesystem UUID
Message-ID: <20151227144535.GJ1586@carfax.org.uk>
References: <567FF63E.3010106@ganomi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSVNCtZB1QZ8vhj+"
In-Reply-To: <567FF63E.3010106@ganomi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--VSVNCtZB1QZ8vhj+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 28, 2015 at 01:31:26AM +1100, Jiri Kanicky wrote:
> Hi,
> 
> I cloned several machines from the same disk and they all have same
> BTRFS filesystem UUID. I need to recovery one disk from failure, but
> if I attach two disks to the same machine, both disks have the same
> ID.
> 
> This seem to confuse UDEV, because /dev/disk/by-uuid seem to show
> just one link, not two links to two disks.
> 
> Is there a way to change the BTRFS ID (generate new one) that I can
> differentiate between the two disks on one host?

   btrfstune, with -u or -U

   Hugo.

-- 
Hugo Mills             | I think that everything darkling says is actually a
hugo@... carfax.org.uk | joke. It's just that we haven't worked out most of
http://carfax.org.uk/  | them yet.
PGP: E2AB1DE4          |                                                Vashka

--VSVNCtZB1QZ8vhj+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWf/mPAAoJEFheFHXiqx3k6/wP/RerGmjXq6lBQfu3bgQhy6tM
mWR4XxaFJ0XpLhyAAB5QSZmThnlSP3006Ryc48eK+dv78x0wass8Jd4MRusjcaCT
NrAGZ5iEqXNpUaodtVXnoZn4q1eYMfbRTN9qfaRqM/dXfauZCFIh59PwTB7mla9L
DJjNeTIv1eW31HnR4yqXnu21iYzMgUjfTB5UMhCeblRUY4CsxREnYAN6Ifv6w/u2
3tskcZ5zDRXIsTKUDmMhUPpUFsMZYUJctxQcu2VBK/rLa6LvmNh4do43k8HyYgdf
uQqSC4iIoKNtpTj7CH5p2vCI1AZZrg5bgkifvGcBoDY8stybYQXXljvvlhhCU7/m
H0Y0DRoxvWk5rS6lXHzYtt7PEsoWk7pB7NfPOOhuActF8Jy9OGArBlyWWRAnIKFd
uEOcUc+EcGiIzBMd6KdRYqNXdXQWDhdJ/z5WQQiAA5uWW7WN28/v+tuyIr+tnv/M
lbHOOSBoJp8OnVVqlh2ogbMoUXbZgsqAVTkNxe1AuhA7DeOEQKQVNMjKYj5S6gU6
X6khAnYZbOfq7BvoNfkosHpXPDGcJJDwMgehmGs+pObFd/dUSX8G0hCnfnvR2Cqb
ckfP0AkzvvwuiwR4fxxCr5oDoMUQoqnmDwiFJeS0lthbhLhkiylS0OqVHQbG9Qgm
GU1f2oorN0JfZfLmV3Uq
=TaH+
-----END PGP SIGNATURE-----

--VSVNCtZB1QZ8vhj+--
