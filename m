From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 1 Sep 2011 21:20:08 +0100
Message-ID: <20110901202008.GA11655@carfax.org.uk>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <1312404713-sup-6548@shiny>
 <loom.20110818T030824-742@post.gmane.org>
 <1313700115-sup-2457@shiny>
 <4E5664F8.9090802@cchtml.com>
 <4E5FD978.7030901@cchtml.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Michael Cronenworth <mike@cchtml.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5FD978.7030901@cchtml.com>
List-ID: <linux-btrfs.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 01, 2011 at 02:14:00PM -0500, Michael Cronenworth wrote:
> On 08/25/2011 10:06 AM, Michael Cronenworth wrote:
> >
> >Is there an update on this? I don't see any new code for
> >btrfs-progs-unstable, but I might be looking in the wrong place.
> >
> >Will this fsck tool be able to handle problems such as:
> >"parent transid verify failed on # wanted # found #" ?
> 
> Does anyone have an update on this? I haven't seen any news for
> several weeks now.

   As a reply to your question:

On Thu, Aug 18, 2011 at 04:50:08PM -0400, Chris Mason wrote:
> There are always bugs to fix, and I have #1 and #2 mostly ready.  I had
> hoped to get #1 out the door before I left on vacation and I still might
> post it tonight.

   You may have missed the "on vacation" bit.

   The canonical place to look for btrfsck updates is the relevant FAQ
item on the btrfs wiki. When Chris has a released version of the
recovery tools, that FAQ entry will be updated at least as soon as I
read it (service may be a bit slow between 00:00 and 09:00 GMT, but
I'm sure others will step in to do the update in that instance). If
you don't see anything new there, there's nothing new to report.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "No!  My collection of rare, incurable diseases! Violated!" ---   

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOX+j4IKyzvlFcI40RAoYiAKCFcB1RH+3HLwRaX/KmDPFTxkO5qQCeNWb3
8N5k9hOa5fU7ig914M7ep1M=
=X5RP
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
