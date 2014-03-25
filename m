Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50106 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaCYUK0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 16:10:26 -0400
Date: Tue, 25 Mar 2014 20:10:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: free space inode generation (0) did not match free space cache
 generation
Message-ID: <20140325201020.GC7442@carfax.org.uk>
References: <532DF38B.40409@friedels.name>
 <532DFDAB.7000600@friedels.name>
 <pan$b7ff$285d59f6$2419371$b3946ebe@cox.net>
 <53309AF9.8090203@friedels.name>
 <pan$8258b$aea97c0c$211631c9$d306a8a9@cox.net>
 <5331E10E.6080806@friedels.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
In-Reply-To: <5331E10E.6080806@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 25, 2014 at 09:03:26PM +0100, Hendrik Friedel wrote:
> Hi,
> 
> >Well, given the relative immaturity of btrfs as a filesystem at this
> >point in its lifetime, I think it's acceptable/tolerable.  However, for a
> >filesystem feted[1] to ultimately replace the ext* series as an assumed
> >Linux default, I'd definitely argue that the current situation should be
> >changed such that btrfs can automatically manage its own de-allocation at
> >some point, yes, and that said "some point" really needs to come before
> >that point at which btrfs can be considered an appropriate replacement
> >for ext2/3/4 as the assumed default Linux filesystem of the day.
> 
> Agreed! I hope, this is on the ToDo List?!

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Block_group_reclaim

   Yes. :)

> >[1] feted: celebrated, honored.  I had to look it up to be sure my
> >intuition on usage was correct, and indeed I had spelled it wrong
> 
> :-)

   Did you mean "fated": intended, destined?

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- IMPROVE YOUR ORGANISMS!!  -- Subject line of spam email ---     

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUzHirFheFHXiqx3kAQK4ag/9FExOG/D3tT7on/elcLQHNAFtFlso6BX7
NOFphw/2Fji+u5BIO9VmAu0pgNIys/gj1IPxqVRucBKtDE73J6yJF7K/Q2MyMf4E
kISdcyt4AYFi2pPkhWw5DsYpxJDxDv/Wm6DHuyLR4QeiDAbCZsjpnlqPdcWMlm0j
GHXuNlw9Dli5pFEiEtngZsF6dw2+InhQ1TrAcSVrKsIYKbIwwGloEBRYlGttP02I
RB8bgkBe+vs5omPZRy/ePXyDENou5utO8tlcIltI3NYowR2Ek6yU528Y18j1MdO5
P91Wy42PANMoQfLiuDsfCVZQr0bPVPBO6Sz/zLl4Byl8uXK+cfm2on4178t8mBoL
RHloTEunO0RX4bx3IULiRbwVJz/awoKxu3sFSArioQQx/rNSp3XnK7tki9nsDpw2
HHlfoHD0+8vPzOatKusfuH+Ujq/78paakRPZZ/Uaawstzh1eRzPhrkGSW1NYpNfn
cHr/2D/+GoP6xAXBhb3mUo8GFcO3YFUPGLIImyFEAHnADfrJAacjk/k5QmVBf0nl
YA0XblyoZX9TYdIDCBJMABGjMZ6WE/YR/ViciF79YmbAY4Lp4RsMfUVC2ikPZeJB
jxmKf43fSx/0JVU9C8oQ7cflpaE2oMnAt8iC2c0zV0Cv6PlRkL8RlvmmMwFMi9ZH
zc+vPfljCnk=
=Z2kl
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
