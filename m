Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53637 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbcAAMXn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 07:23:43 -0500
Date: Fri, 1 Jan 2016 12:23:42 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: UGlee <matianfu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: how btrfs uses devid?
Message-ID: <20160101122342.GA1586@carfax.org.uk>
References: <CAEgruXuFNsumiyBXrWwiu47WVuukSHLynMJHN7e3E1cYWn3QnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="edESjMboOAwUFn6i"
In-Reply-To: <CAEgruXuFNsumiyBXrWwiu47WVuukSHLynMJHN7e3E1cYWn3QnQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--edESjMboOAwUFn6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 01, 2016 at 08:16:28PM +0800, UGlee wrote:
> Dear all:
> 
> If a btrfs device is missing, the command tool tells user the devid of
> the missing devices.
> 
> I understand that each device (disk) in a btrfs volume has been
> assigned a uuid (UUID_SUB field in udevadm info output). If the device
> is missing, it's hard to tell user to input such uuid string in
> command line. So devid is for convenience.

> In our product, we want to record all disk information of a volume in
> a file. If a disk is missing, not because it's broken, but because the
> user has so many disks and in some cases they may put back the wrong
> one. In this scenario, we can provide the disk information (such as
> serial number) to user and help them to check if they did something
> wrong.
> 
> My question is: is the devid just an alias to sub uuid? for a given
> disk device, it is never changed during any btrfs operation, including
> add, remove, balance and replace? or it may be changed, and when?

   Actually, devid is the ID that the FS uses internally in the device
tree to identify them. It's not just a convenience -- it's the
"official" identifier for the device within the filesystem.
 
> One more question just for curiosity. I checked the source code of
> btrfs-progs briefly. It seems that there is no data structure in
> superblock recording all sub-uuids or all devids for the volume, so
> how does btrfs figure out the missing devid? since they are not always
> sequential integers, for example, after one device is removed, the
> devid is simply removed and the devid of other device is not
> re-numbered.

   The devices that should be there (identified by devid) are listed
in the device tree. If one of those doesn't match up with a
currently-known device for that filesystem (as determined by btrfs dev
scan), then it's missing.

   Hugo.

-- 
Hugo Mills             | I gave up smoking, drinking and sex once. It was the
hugo@... carfax.org.uk | scariest 20 minutes of my life.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--edESjMboOAwUFn6i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWhm/OAAoJEFheFHXiqx3kHk0QAJ8JwqqvLv//+3G4vmJNCfwN
q+X/TIIWNyXfoAc6upJ4UrYsajMLrCTM/8MnSaad83dSy3CjRtLLroV1Jzys+aMw
ys8WQsx6JFISIemaxmpdxunaISF0mYT5DRZbVuCalF4AG8viQ14qxtj8tJ6aPksJ
fflHRiZ+RRwq/W4UnYA+jlyksuLEk5cpw7vXy4GwkMuPqxE8/4IflxJioMM+uP6p
OtRwzGY+NOcDtDSh2kf9fBei8/N1VdHcrjXyp7CStflOmhyqMUw2k4yjNv7iEOdV
m29OKdAR7/NkJYoEg+yRXsiLKjDg5JPwD1QUMQ1JDiiADOqkhsHSlmUDMd28wy3+
tFv9RtsAffdFyeMOwkwd1n4LgDn6AWIiEgwfcZRM7IG8vnfi2agIq2aY/Eg9JAUG
ARxxqAPX3N2r55djIunQ/HAVkM0WKcRJ8BRq89W4zNCq1M1vxWrLC0Z/9k+zcNuj
LwQBJuE8ZQxyCM/3sLNYUzTpwHZZW7eVpfGIAScdONA1YMfkSOQ/e21kqdRXs0jR
XR6n599pP10AHcmreAZdXn/dk56QPAoAmssWruDDhVQHd16eV6+oUvctx+huJPTf
4PWSy4ML5NLfb3fUtijRZmKgejNLb+e4JbqGjQvVO8qHpgJfMU0RoNZpis9KUml0
AYh141bqNj5tj+mnxftA
=ozUe
-----END PGP SIGNATURE-----

--edESjMboOAwUFn6i--
