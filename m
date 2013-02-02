Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41985 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab3BBQUE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 11:20:04 -0500
Date: Sat, 2 Feb 2013 16:20:00 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Atri Sharma <atri.jiit@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Newbie help-- Making BTRFS partition
Message-ID: <20130202161959.GS16285@carfax.org.uk>
References: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pa4xkLBhPDIhDLv1"
In-Reply-To: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Pa4xkLBhPDIhDLv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 02, 2013 at 08:56:20PM +0530, Atri Sharma wrote:
> Hi all,
> 
> I am running a Fedora 17 system. I am trying to set up a new partition
> of 2 GB size which has BTRFS as file system.
> 
> When I am trying to do mkfs.btrfs on a partition, I get:
> 
> [atri@AtriServer ~]$ mkfs.btrfs /dev/sda3
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> check_mounted(): Could not open /dev/sda3
> error checking /dev/sda3 mount status

   You need to be root, or (typically) to be in the "disk" group in
order to write to a block device.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--Pa4xkLBhPDIhDLv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQ08r79z9OVl50rAAQIKEA/+OrnN6oXIPZO5v8QPtBEGFsfUMvh6XT1r
QPP28Djsjiz/aETwAPDaeRHa1okeNy0MjP38IqXhqRzZaqrVZJUHKToCO/bKrLHk
Z4KeK4OnQx+KyF5GRDAxE+2AvMdJWbf9vQ6LFQYRrjg+Y3fUFaZAkr4fTJmuzUb1
Nh+7XAOHJSbRf1p62OwYri0o9wGqTYI1w2wLPB2pHjJ3GhJ78P4KeuPMub8aJx4q
ccSfDs12DCN/iRQJA/bcedL8ukuH7A2+0aPPck1+RCX9gRaoQxeXwQO/Tz12PGOI
yWheNi5j7yrjf3TfxaVy29hWMEZea6M2dPUwRGdE+NrdhzbcRfACLlWk/1xNoppS
iSqz3V+iNbZ8TQgaIQ2WrX7Ox2IBolXo/ICCjYRBycNONzDlcQe+zbQoIZy08KEY
YfVOqNalixKJSWa6B8xvsUFVPyny32nL5Y7R3rgGGfNPgaX0BOJoVo2f7dsH7KLY
f+7z99ogbnO3JsYh3p+5gV1YiVQJLRV8Y+Xl+ECsI1gre9OX4AU0uA/vqlnwdqf8
/DNd+OaIgbGCUFc0lJS0vJDD4ZOg3wh+YE3CT5RtTWkC3OC5WsBH77+UfCW3CiJO
fSFxHRHprBlJoD4pVbLzjJWqucD4Y88fmW6VtP88lr27cMvAJhM074iO9kILiSPe
uMd4kqBYhIk=
=99m0
-----END PGP SIGNATURE-----

--Pa4xkLBhPDIhDLv1--
