From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Tue, 12 Jul 2011 10:44:19 +0100
Message-ID: <20110712094419.GA10498@carfax.org.uk>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
 <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
 <20110710182300.GI4325@carfax.org.uk>
 <4E1B08C4.8070000@jan-o-sch.net>
 <20110711205716.GM4325@carfax.org.uk>
 <4E1C0AB7.4020902@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1C0AB7.4020902@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 12, 2011 at 10:49:59AM +0200, Jan Schmidt wrote:
> On 11.07.2011 22:57, Hugo Mills wrote:
> > On Mon, Jul 11, 2011 at 04:29:24PM +0200, Jan Schmidt wrote:
> >> On 10.07.2011 20:23, Hugo Mills wrote:
> >>>    Yes, this is over three months after the initial posting, but since
> >>> nobody else has looked at it yet, and the patch is in my integration
> >>> stack...
> >>
> >> ... thanks!
> >>
> >>>    I've not reviewed the whole thing -- just the "scrub start" code so
> >>> far. I've removed the bits I've not checked from the file below.
> >>
> >> I rebased the old branch I found to your current integration branch and
> >> fixed up a most of what you mentioned. I'll not send a new version out
> >> until after your complete review (or your statement that this is it or
> >> your statement that you would rather going on reviewing the revised
> >> version).
> > 
> >    Thanks. The other half has just gone out (with few comments).
> 
> I'm through now, but I'll wait another day for you to protest on my
> latest comments before sending the new version.
> 
> >> Things I ripped out are accepted and corrected without resistance.
> >> Comments follow.
> > 
> >    Only a couple of rejoinders below.
> > 
> >>> On Wed, Mar 30, 2011 at 06:53:12PM +0200, Jan Schmidt wrote:
> > [...]
> > 
> >>>> +		case 4: /* read dev id */
> >>>> +			for (j=0; isdigit(l[i+j]) && i+j < avail; ++j)
> >>>> +				;
> >>>> +			if (!j || i+j+1 >= avail)
> >>>
> >>>    j == 0 is clearer than !j here, IMO
> >>>
> >>>> +				_SCRUB_ILLEGAL;
> >>>> +			p[curr]->devid = atoll(&l[i]);
> >>>> +			i += j + 1;
> >>>
> >>>    Is there any reason that you couldn't just use strtoull here? We
> >>> know that the string is terminated with a \n (by the guarantee of
> >>> state 1), so strtoull will always finish within the buffer.
> >>
> >> I just found it way easier to use atoll. We already know the first
> >> character really is a digit, so why bother with a more cumbersome function?
> > 
> >    Ah, my mistake for not being clearer, I think: I was talking about
> > the for loop at the head of the state 4 code as well. That only exists
> > in order to find the end of the number read in by atoll, and strtoull
> > would do that for you.
> 
> Alright, now I see your point. However, with strtoull I would have to
> calculate with character pointers, whereas anything else uses direct
> character access with i and j here. And I don't need the fancy bits of
> strtoull, either. So I'd like to stick with atoll.

   OK, it's not something I feel massively strongly about. Stick with
atoll, then.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "He's a nutcase, you know. There's no getting away from it -- ---  
                     he'll end up with a knighthood"                     

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOHBdzIKyzvlFcI40RAipfAJ0akWUIq/oXOTNsOQTvp1sgjjAbmACg1OAk
FuaJb2jfvr079YlPNY+Et/o=
=jYSa
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
