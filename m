Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59059 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3CJWY1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 18:24:27 -0400
Date: Sun, 10 Mar 2013 22:24:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130310222423.GG30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <513CAA25.2010803@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TmwHKJoIRFM7Mu/A"
In-Reply-To: <513CAA25.2010803@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TmwHKJoIRFM7Mu/A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 10, 2013 at 04:43:33PM +0100, Goffredo Baroncelli wrote:
> Hi Hugo,
> 
> On 03/09/2013 09:31 PM, Hugo Mills wrote:
> >    Some time ago, and occasionally since, we've discussed altering the
> > "RAID-n" terminology to change it to an "nCmSpP" format, where n is the
> > number of copies, m is the number of (data) devices in a stripe per copy,
> > and p is the number of parity devices in a stripe.
> > 
> >    The current kernel implementation uses as many devices as it can in the
> > striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
> > written as "mS" (with a literal "m"). The mS and pP sections are omitted
> > if the value is 1S or 0P.
> > 
> >    The magic look-up table for old-style / new-style is:
> > 
> > single 		 1C (or omitted, in btrfs fi df output)
> > RAID-0		 1CmS
> > RAID-1		 2C
> > DUP			 2CD
> > RAID-10		 2CmS
> > RAID-5		 1CmS1P
> > RAID-6		 1CmS2P
> 
> 
> Even I found a bit more rational the "nCmSpP" format, I think that this
> is a bit too complex.
> 
> As you told:
> >    Chris is definitely planning fixed values for mS (so you can ask
> > for, say, exactly 4 stripes and one parity), and values for nC greater
> > than 2. As far as I know, there aren't any plans for nC > 1 and pP > 0
> > together. I haven't got far enough into the kernel code to work out
> > whether that's simple or not to implement.
> 
> On the basis of that we should handle few cases than the full "nCDmSpP"
> format allow. So I suggest to allow the following "shorts forms":
> 
> - DUP			-> dD		(to allow more that 2 copy per
> 					 disk)
> 
> - RAID1			-> nC or *C	
> 
> - RAID0 		-> mS or *S

   So we can drop the C clause where it's 1C, in the same way we drop
the S clause when it's 1S, and P when it's 0P. I'm happy with that
much. It makes the parser a little more complicated, but it's no big
problem.

> - RAID10		-> nCmS or *CmS or nC*s
> 
> - RAID with parity	-> mSpP or *SpP or mS*p (it is possible ?)
> 
> - single		-> 1C or 1D or 1S or "single"
> 
> 
> where d,n,m,p are integers; '*' is the literal '*' and means "how many
> possible".

   I don't particularly like this as a generic thing. The * is
ambiguous: does it mean "use as many as possible at all times" (like
the current RAID-0 implementation, for example), or does it mean "use
as many as we can right now, and don't reduce the value"?

   The former is the default for stripes on current RAID-0, -10, -5
and -6. However, it would be problematic for copies on RAID-1, and
-10, because you'd have variable redundancy. For specifying copies,
you'd want the second meaning above, so the * actually means subtly
different things depending on where it appears.

> For example if I have 6 disks:
> *C2S	-> means: 3 copies, 2 stripes ( m*n = 3*2 == num disk == 6)
> 2C*S	-> means: 2 copies, 3 stripes ( m*n = 3*2 == num disk == 6)
> 
> *S2P	-> means: 2 parity, 4 stripes ( p+m = 4+2 == num disk == 6)

> We could also have some defaults, like: d=2, n=2, m=*, p=1, so some
> common forms become:
> D	-> means DUP (d==2)
> S	-> means RAID0 (s=*)
> C	-> means RAID1 (n=2)
> CS	-> means RAID10 (n=2, m=*)
> SP	-> means RAID5 (m=*, p=1)
> SP2	-> means RAID6 (m=*, p=2)

   Too cryptic; special cases -- we'd only be replacing one set of
semantic-free symbols (RAID-18-OMGBBQ) with another set, which is what
I'm trying to get away from with this patch.

   I definitely want to see <number><specifier> clauses only, in a
fixed order and with as little special-casing as possible. We can drop
"unused" clauses, but trying to remove just the numbers for specific
cases, or just to produce new special names and aliases for things
seems counterproductive.

> It would allowable also more complex form like
> 	5C3D4S2P
> but I don't think it will be supported ever.

   Probably not. :)

   It's unclear to me what the 5C3D would actually do. (5 copies on
different drives, and three other copies placed somewhere on the same
devices? And as you say, unlikely to be implemented) I think the "D"
concept should stay as a modifier flag, not a separate clause, as
we've got either n copies all on different drives, or n copies without
the guarantee, which is what the D shows.

   (As an aside, when Chris gives us 3C, it'll be interesting to see
what can be done with 3CD on two drives... TRIPE rather than DUP?)

> I have a request: could we consider to swap letters with the numbers ?
> For example 3S2P could become S3P2. For my *subjective* point of view,
> this seems more clear. What do you think ?

   I read it as "three stripes, two parity", so to me it makes more
sense in <number><letter> order.

> However I am open also to the following forms
> 
> dD -> DUP(d), as backward compatibility DUP means d==2
> nC -> RAID1(n), as backward compatibility RAID1 means n==2
> mS -> RAID0(n), as backward compatibility RAID0 means m==*
> nCmS -> RAID10(n,m), as backward compatibility RAID10 means n=2, m=*
> mSpP -> RAIDP(n,m), as backward compatibility RAID6 means p=2, m=*
> 			RAID5 means p=1, m=*
> 
> more verbose but also more familiar to the administrator.

   I don't particularly want to encourage the re-use or extension of
the RAID-n notation, because what we're doing here is, largely, *not*
the standardised RAID levels.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--TmwHKJoIRFM7Mu/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUT0IF79z9OVl50rAAQJgYRAAkAd9vV95/TMSykVKegIjnkHSPPvq5gJJ
VCAJZ5Xa8bh4nDoMa3RLyXiq9Yc7P3CGKwjIq2UycirvfyikBGv/rwmKhUHFp0br
M17CrGQSJVURkAhmq3vyIwmwNbopyf7h+NP919cSK6EF6tcgSo7CFy54clEhv6Ul
tPszek3wC7U5+w/e3XSm8x59YXSNCqDUHxsZOClQEtPtUXEvDJzEWnV+rpiyyZHJ
rrfd/cAyZUuNrptN4IGDLAqJ7B1l/unJ3tCYrpzrpPJlthUXXdlf9aE48Ol94jmN
rFwiEye0bRoPMrSkp5U5S16XT71KQyHIF5QLJMGSMRC1YSSRSj6zq40kr8IYUJ7t
kUWL61QF08mVSvB93J0BGe+xij36prdYcLWcwMQUfQe6EBXhV4BRpFuAQ6o9/h+o
xrs0LZHjVok2UOrLk4iOoNhFqZm92uvj3BQRHWE3kt7XUqJLQcsx4ZjlEainF9Hd
4luPmjYAGvvaKvjr1FyIDxKWtYBRWTOS3P/sgg1J2TAOXvxN0gTFNfiWQgLpalYp
R+7AZa1Xs23QPV5IXIkiRHHpF6Erhb+EXbEVb5JcCjBkeNuYyWM2ONUr3jcE/gXn
6UIMzLMePauKiJ3i6L2rWhgEEb4CZhp/RrYsO4L7Rg+xzrtqQhYvmr8VsPsg9sct
V13n3eUvPlY=
=UZMk
-----END PGP SIGNATURE-----

--TmwHKJoIRFM7Mu/A--
