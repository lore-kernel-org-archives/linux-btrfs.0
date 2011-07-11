From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Mon, 11 Jul 2011 21:57:16 +0100
Message-ID: <20110711205716.GM4325@carfax.org.uk>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
 <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
 <20110710182300.GI4325@carfax.org.uk>
 <4E1B08C4.8070000@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E1B08C4.8070000@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 11, 2011 at 04:29:24PM +0200, Jan Schmidt wrote:
> On 10.07.2011 20:23, Hugo Mills wrote:
> >    Yes, this is over three months after the initial posting, but since
> > nobody else has looked at it yet, and the patch is in my integration
> > stack...
> 
> ... thanks!
> 
> >    I've not reviewed the whole thing -- just the "scrub start" code so
> > far. I've removed the bits I've not checked from the file below.
> 
> I rebased the old branch I found to your current integration branch and
> fixed up a most of what you mentioned. I'll not send a new version out
> until after your complete review (or your statement that this is it or
> your statement that you would rather going on reviewing the revised
> version).

   Thanks. The other half has just gone out (with few comments).

> Things I ripped out are accepted and corrected without resistance.
> Comments follow.

   Only a couple of rejoinders below.

> > On Wed, Mar 30, 2011 at 06:53:12PM +0200, Jan Schmidt wrote:
[...]

> >> +		case 4: /* read dev id */
> >> +			for (j=0; isdigit(l[i+j]) && i+j < avail; ++j)
> >> +				;
> >> +			if (!j || i+j+1 >= avail)
> > 
> >    j == 0 is clearer than !j here, IMO
> > 
> >> +				_SCRUB_ILLEGAL;
> >> +			p[curr]->devid = atoll(&l[i]);
> >> +			i += j + 1;
> > 
> >    Is there any reason that you couldn't just use strtoull here? We
> > know that the string is terminated with a \n (by the guarantee of
> > state 1), so strtoull will always finish within the buffer.
> 
> I just found it way easier to use atoll. We already know the first
> character really is a digit, so why bother with a more cumbersome function?

   Ah, my mistake for not being clearer, I think: I was talking about
the for loop at the head of the state 4 code as well. That only exists
in order to find the end of the number read in by atoll, and strtoull
would do that for you.

[...]

> >> +	char fsid[37];
> > 
> >    Magic number. is there a #define in libuuid for this value?
> 
> At least the man page of uuid_parse clearly states uuids have 36 bytes
> plus a \0 in printf format. uuid/uuid.h doesn't contain such a constant.
> But volumes.c, print-tree.c and others do it with 37, too.

   OK, if that's conventional (and not defined in uuid.h), then go
with the magic number.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "I will not be pushed,  filed, stamped, indexed, briefed, ---    
               debriefed or numbered.  My life is my own."               

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOG2OsIKyzvlFcI40RAk2nAJ9ofVkL+V3wBVzAH5dRSbZgy0zgFgCgi1k7
VhOZEpk34j71MliW7eOBnFw=
=QBsf
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
