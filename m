Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57816 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2JCQe1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 12:34:27 -0400
Date: Wed, 3 Oct 2012 17:34:21 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Message-ID: <20121003163421.GC25498@carfax.org.uk>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
 <20121003115615.GB25498@carfax.org.uk>
 <506C6531.4060700@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
In-Reply-To: <506C6531.4060700@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 03, 2012 at 06:17:53PM +0200, Goffredo Baroncelli wrote:
> On 10/03/2012 01:56 PM, Hugo Mills wrote:
> >    Looks good. Only a few comments, inline.
> >
> >On Wed, Oct 03, 2012 at 01:43:14PM +0200, Goffredo Baroncelli wrote:
[snip]
> >    Also, use kB, MB, GB, TB for powers-of-ten based units, and KiB,
> >MiB, GiB, TiB for powers-of-two based units, please. I don't care
> >which you report in, but please do make the distinction. (And note
> >that it's kB with a lower case k, but KiB with an upper case K). This
> >brings us in line with the relevant ISO and IEEE standards.
> 
> I forgot to reply you when you raised this question the first time.
> Even though I am inclined to accept your suggestions, this change is
> not related to my patches. My code uses the functions print_sizes(),
> which is quite old (about 2008). This function is used in a lot of
> places. This suggested to address this issue with another patch.

   OK.

[snip]
> >    Why are the field headings here using - where the field headings in
> >the first section used _? Should you be using _ in both places?
> 
> 2 persons highlighted that :-( ... I will update the code

   It's just a niggle, really, but it's an obvious one.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There is no dark side to the Moon, really. As a matter of ---    
                          fact,  it's all dark.                          

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGxpDb9z9OVl50rAAQIFPRAAnWYg4WomJBW2ynoFxnwozAbbzAzDgHnX
XquvyJbjdvFdSuSa1Cue1Qiob7sW6N0Bp5879JQijozn+uRkIOZTkzodAKj5a7L0
rb6gG/vqMPBewldDlpnNoU28dVdp1A8yBpjG0bfEjiv7nTeEx0otUA3P2D3ipGqU
O+4YgH4SwW3+fQpdvUmcHVpDZiDKno5wLAGNPHUeQIbw0lT5wV1T0sCY3Hrv8KAL
djld606oxlMudtYIRr7WqTWj+KdJtZsNE8AocYi/CdYVLyN7evPs2Mcc9RVu5G69
DNsd6sPSgiGBY6xN6uv3OayHN5cBdYWcYRTTmPAJhrIihEJR7g0fRDuCB68xcKfL
gS7e5KxSB8QtJeLh4mAMH0f1kIwdLu9R+hMS7yKWE9OkWjWLPcix67z8oVnBbFcz
G9MSnNr3jGyJ8lrscGoRsoxtMqSGehZp5sKu9cfg6my0FJiaxkxs+Ws1asyc/jM2
MOIPdH878rgBaXt10dDjg7meiKVq9Yy3hg1I6rzN+YzTjGNsYCuyKWL5vFbxIEwx
w1qiGq9XSaE+RezE0G2KN16A4+DdvwFRB+PfTpHK2Hc7ozX8HexVgc43l0zdZ3CI
vr3JM07DLOJXQ7QXbwM7Hjw+//cPaKBJt9Ik2J8jdOXPqVcQ+XVCDfYxRyLq2XHP
5EQPsXvgFJE=
=usK5
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
