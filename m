Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:48413 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaDVR4Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 13:56:24 -0400
Date: Tue, 22 Apr 2014 18:56:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size
 Drives
Message-ID: <20140422175619.GC30423@carfax.org.uk>
References: <53540367.4050707@aeb.io>
 <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com>
 <5354A4EA.3000209@aeb.io>
 <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net>
 <BDB8ED64-0A92-4C22-A07D-C06D790410ED@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
In-Reply-To: <BDB8ED64-0A92-4C22-A07D-C06D790410ED@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 22, 2014 at 11:42:09AM -0600, Chris Murphy wrote:
> 
> On Apr 21, 2014, at 3:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> > Adam Brenner posted on Sun, 20 Apr 2014 21:56:10 -0700 as excerpted:
> > 
> >> So ... BTRFS at this point in time, does not actually "stripe" the data
> >> across N number of devices/blocks for aggregated performance increase
> >> (both read and write)?
> > 
> > What Chris says is correct, but just in case it's unclear as written, let 
> > me try a reworded version, perhaps addressing a few uncaught details in 
> > the process.
> 
> Another likely problem is terminology. It's 2014 and still we don't have consistency in basic RAID terminology. We're functionally in the 19th century uncoordinated disagreement of weights and measures, except maybe worse because we sometimes have multiple words that mean the same thing; as if there were multiple words for the term gram or meter. It's just nonsensical and selfish that this continues to persist across various file system projects.
> 
> It's not immediately obvious to the btrfs newcomer that the md raid chunk isn't the same thing as the btrfs chunk, for example.
> 
> And strip, chunk, stripe unit, and stripe size get used interchangeably to mean the same thing, while just as often stripe size means something different. The best definition I've found so far is IBM's stripe unit definition: "granularity at which data is stored on one drive of the array before subsequent data is stored on the next drive of the array" which is in bytes. So that's the smallest raid unit we find on a drive, therefore it is a base unit in RAID, and yet we have no agreement on what word to use.
> 
> And it's not really like the storage industry trade association, SNIA, who published a dictionary of terms in 2013, really helps in this area. I'll argue they make it worse because they deprecate the term chunk, in favor of the terms strip and stripe element. NO kidding, two terms mean the same thing. Yet strip and stripe are NOT the same thing.
> 
> strip = stripe element
> stripe = set of strips
> strip size = stripe depth
> stripe size = strip size * extents not including parity extents
> 
> Also the units are in blocks (sectors, not fs blocks and not bytes). The terms stripe unit, stripe width, and stride aren't found in the SNIA dictionary at all although they are found as terms in other file system projects.
> 
> So no matter how we look at it, everyone else is doing it wrong.

   Also not helped by btrfs's co-option of the term "RAID-1" to mean
something that's not traditional RAID-1, and (internally) "stripe" and
"chunk" to mean things that don't match (I think) any of the
definitions above...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- A clear conscience.  Where did you get this taste ---        
                         for luxuries,  Bernard?                         

--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1atQ1heFHXiqx3kAQLmdxAApguIyPEPLi3EyX7rmGFsrx39uZEc1iM2
c/Y1PF2/u9ZPOJxX9sbJYQ4FgSPnS3Jiv7DjoK7eBzjE7MaUZZNNvGOPV0d8aApm
caaYItp142cwVSY+Rivw1eXQF9lkJ7fNB9t6cCCCWGa2MuLt8G6FRop46cs164U+
MjWWYNVq09je0qIcoZSds9jddL/5jwF9PVCJSco7oo2J7IstDEVJjpov+jNRxPOV
4KneoiitLWbXKquAVdPbP6KqCtLAIx843FVNv+yksrl7B7vb/HHiXsnetFwijgF5
fN9pO90cYWc0D+Lwgc6iW+2IZGSZ5uLJOdDOkIRouRjEybGbrntWHJB6dOddm/R3
RgGzM8ShZgqEwQ7SuIZ74/g8l6tluOfEOtYM6Zag+mwwfJ+euXUv041ntMXiUlZC
BvWqW5PGcsq9OKyG6LlR+bDIbDdfEN8JnuVNpOWwWpwz0qgP6EHvoXCzNBiBmpdd
0+DRSZmpS8HYlzKOO/8lS8SqfAXF6V9Neno3tgJpfeiHnUzKFlLCckLAY9oKWmnu
4LWw8YmujbdU9HY1Tp+OlNayKrYf8HD4VCC37ehAodiGiS0REhjo9hmaWu7TQCQX
6Lp5M8yvIOtPDQUoYaqhEK+z/ipgUqHeFq/J4SfO3dmlXkDyDEfYma2xQcI8XFo+
FsSUUsudfVk=
=OQMK
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
