Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51215 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbLaLvz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 06:51:55 -0500
Date: Thu, 31 Dec 2015 11:51:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Xavier Romero <XRomero@nexica.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID10 question
Message-ID: <20151231115153.GW1586@carfax.org.uk>
References: <47770e1d8a804d31994eebaf733adf55@nex-exchng-01-v.bcn.nexica.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2AZ19bMCakBLong"
In-Reply-To: <47770e1d8a804d31994eebaf733adf55@nex-exchng-01-v.bcn.nexica.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V2AZ19bMCakBLong
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 31, 2015 at 09:52:16AM +0000, Xavier Romero wrote:
> Hello,
> 
> I have 2 completely independent set of 12 disks each, let's name them A1, A2, A3... A12 for first set, and B1, B2, B3...B12 for second set. For availability purposes I want disks to be paired that way:
> A1 <--> B1: RAID1
> A2 <--> B2: RAID1
> ...
> A12 <--> B12: RAID1
> 
> And then I want a RAID0 out of all these RAID1.
> 
> I know I can achieve that by doing all the RAID1 with MD and then build the RAID0 with BTRFS. But my question is: can I achieve that directly with BTRFS RAID10?

   No, not at the moment.

   Hugo.

-- 
Hugo Mills             | Comic Sans goes into a bar, and the barman says, "We
hugo@... carfax.org.uk | don't serve your type here."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--V2AZ19bMCakBLong
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWhRbYAAoJEFheFHXiqx3kTqkQAKl5MURLavf4IUUOKrhnVMSv
YVGEyK0ZvAMRY+n07ehIpDVJioYN2xKti8gZklae1633d+8r2VzBYB6y95POl4lI
D6kVQOi/XYfi29zMxntt/XGSQW6oSKLxB55WfboPvg8A3q8U3EfIM7eEpBTGkkjS
TXvl121Q40y51eNmK9hdTPraC2a1WpVTb4KsK1GxoT6ItiiIdcjLhauU8KmeYIj+
6vGFzQ0NWtDNZu9hLmQj2lGfINpweBO0Kwuxmwmhrke+px9gRmQHa+waR3cenJYc
dG7rwKDAvmCnyvCtBVInLZuFjZkOft0DSlCIfPpOG9nhWMNe36WsiJscI3eVWT+l
G7vj9WlToD+YCSTtYXrQdlxUorzXFJcCfn5+p2uHJk5ju5a+GJB6NoXyFBUy/3Ai
h6V0xlkbkGY/OG0THak/GkVjZfRKaIui7jCjWm5XXo2c6c0HylAlp8sQ5Wu7SOrR
aLNDypvldLrG9zcQeKROObKgel0QTa/o5qhO2JyJ4OO/sSy0C72yfXjEhcnmU+mE
aQclUHuGM/Ty5IG36wbKgkl2hxN5NgckAWcz7GaykzWQg2xxBuOW3F+kb0bU5IM4
0muteauY9FTq7uqVz5sQ/uXCI/VbhDjDPaerxVxsLvUrgqQad+TlyYcaeXcTn2J2
/GjTxSzS67y0lNstfJVp
=DxeL
-----END PGP SIGNATURE-----

--V2AZ19bMCakBLong--
