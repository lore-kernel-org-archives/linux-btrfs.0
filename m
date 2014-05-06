Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:50316 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaEFQnq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 12:43:46 -0400
Date: Tue, 6 May 2014 17:43:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: Marc MERLIN <marc@merlins.org>, Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: Please review and comment, dealing with btrfs full issues
Message-ID: <20140506164324.GC24298@carfax.org.uk>
References: <20140506121937.GD10159@merlins.org>
 <53690E27.6090101@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oh6wehMCKJhhoxlo"
In-Reply-To: <53690E27.6090101@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Oh6wehMCKJhhoxlo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 06, 2014 at 06:30:31PM +0200, Brendan Hide wrote:
> Hi, Marc. Inline below. :)
> 
> On 2014/05/06 02:19 PM, Marc MERLIN wrote:
> >On Mon, May 05, 2014 at 07:07:29PM +0200, Brendan Hide wrote:
> >>"In the case above, because the filesystem is only 55% full, I can
> >>ask balance to rewrite all chunks that are more than 55% full:
> >>
> >>legolas:~# btrfs balance start -dusage=50 /mnt/btrfs_pool1"
> >>
> >>"-dusage=50" will balance all chunks that are 50% *or less* used,
> >Sorry, I actually meant to write 55 there.
> >
> >>not more. The idea is that full chunks are better left alone while
> >>emptyish chunks are bundled together to make new full chunks,
> >>leaving big open areas for new chunks. Your process is good however
> >>- just the explanation that needs the tweak. :)
> >Mmmh, so if I'm 55% full, should I actually use -dusage=45 or 55?
> 
> As usual, it depends on what end-result you want. Paranoid rebalancing -
> always ensuring there are as many free chunks as possible - is totally
> unnecessary. There may be more good reasons to rebalance - but I'm only
> aware of two: a) to avoid ENOSPC due to running out of free chunks; and b)
> to change allocation type.

   c) its original reason: to redistribute the data on the FS, for
   example in the case of a new device being added or removed.

> If you want all chunks either full or empty (except for that last chunk
> which will be somewhere inbetween), -dusage=55 will get you 99% there.
> >>In your last example, a full rebalance is not necessary. If you want
> >>to clear all unnecessary chunks you can run the balance with
> >>-dusage=80 (636GB/800GB~=79%). That will cause a rebalance only of
> >>the data chunks that are 80% and less used, which would by necessity
> >>get about ~160GB worth chunks back out of data and available for
> >>re-use.
> >So in my case when I hit that case, I had to use dusage=0 to recover.
> >Anything above that just didn't work.
> 
> I suspect when using more than zero the first chunk it wanted to balance
> wasn't empty - and it had nowhere to put it. Then when you did dusage=0, it
> didn't need a destination for the data. That is actually an interesting
> workaround for that case.

   I've actually looked into implementing a "smallest=n" filter that
would taken only the n least-full chunks (by fraction) and balance
those. However, it's not entirely trivial to do efficiently with the
current filtering code.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hail and greetings.  We are a flat-pack invasion force from ---   
                     Planet Ikea. We come in pieces.                     

--Oh6wehMCKJhhoxlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2kRLFheFHXiqx3kAQJiiA//VSI7hs+EQreSxvVjb9kuLc8cmOV2MszC
AoCFDGDlCB7E1bCQK2wtFBmaqpTaiiTYNJdJwXBFs1ZWWoci4A+L28wMJbME4h5A
23s6z2uQigajykrZv4p6SGP3yPfKqGsw5o6JbtG/I/1zXfW+g6p1eYwR3olhy1d0
Xp1vPsRSbO39UD2z6ml5vJ7q0YNFm3dGZgsTj6X//Hgn0cFZh5LjhNo6YHJJgmCP
OOyNMI/FFKPDbCv0gK6qeHYLRtTYV0liQ+nMhtd83YFG40X/yPMmE6rjTtNMEbcX
55eGL2bjDauiyhgRCrHVW+HAdwvsJNfxibpXhaFHZ+baW81vnO5zhmcSgWuquXcx
jxr0/LLh1gVTY+0ym7YBoxeWKYcNZ7Hfs5KP+FmMQv9trW4y1EvK6tGLkXtg4ioo
7wzxh0rQGGfDtCeHFeqAlUvvWMfUt34ywD3Odgd0IYOD5V0kB7OVm8CMjnfRK9+k
7Vk7/A+PWVEH/fPDE8O9aM4wvr34Jlod/JaUgN9hNo7o/AWAHNnvs1cblp19N5PN
ItXD465r1MC8ZGio8IZIjO0aMGfkQMYG7X/Jv8kUMKxvX5z7V7MVQ7qZjUC6ui1b
c91yQr9TOGTkFjt75CRngOdyrD1IGqKV+mSdCfa6arTmN3m4T1AFAG637cgnodma
f+jU7WMMn58=
=+t8B
-----END PGP SIGNATURE-----

--Oh6wehMCKJhhoxlo--
