Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59000 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3CJWE1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 18:04:27 -0400
Date: Sun, 10 Mar 2013 22:04:22 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Message-ID: <20130310220422.GF30771@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <khgcsi$1k4$1@ger.gmane.org>
 <20130310014434.GB30771@carfax.org.uk>
 <khh6er$nmk$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z+pzSjdB7cqptWpS"
In-Reply-To: <khh6er$nmk$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--z+pzSjdB7cqptWpS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 09, 2013 at 09:41:50PM -0800, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 09/03/13 17:44, Hugo Mills wrote:
> > You've got at least three independent parameters to the system in order
> > to make that choice, though, and it's a fairly fuzzy decision problem.
> > You've got:
> > 
> > - Device redundancy - Storage overhead - Performance
> 
> Overhead and performance aren't separate goals.  More accurately the goal
> is best performance given the devices available and constrained by redundancy.
> 
> If I have 1GB of unique data and 10GB of underlying space available then
> feel free to make 9 additional copies of each piece of data if that helps
> performance.  As I increase the unique data the overhead available will
> decrease, but I doubt anyone has a goal of micromanaging overhead usage.
> Why can't the filesystem just figure it out and do the best job available
> given minimal constraints?
> 
> > I definitely want to report the results in nCmSpP form, which tells you
> > what it's actually done. The internal implementation, while not 
> > expressing the full gamut of possibilities, maps directly from the 
> > internal configuration to that form, and so it should at least be an 
> > allowable input for configuration (e.g. mkfs.btrfs and the restriper).
> 
> Agreed on that for the micromanagers :-)
> 
> > If you'd like to suggest a usable set of configuration axes [say, 
> > (redundancy, overhead) ], and a set of rules for converting those
> > requirements to the internal representation, then there's no reason we
> > can't add them as well in a later set of patches.
> 
> The only constraints that matter are surviving N device failures, and data
> not lost if at least N devices are still present.  Under the hood the best
> way of meeting those can be heuristically determined, and I'd expect
> things like overhead to dynamically adjust as storage fills up or empties.

   That's really not going to work happily -- you'd have to run the
restriper in the background automatically as the device fills up.
Given that this is going to end up rewriting *all* of the data on the
FS, taking up storage bandwidth as it does it (and taking a hell of a
long time to complete), I think this is a bit of a non-starter. Oh,
and your performance will drop steadily over the months as it cranks
down through the various options.

   If you want maximum storage (with some given redundancy),
regardless of performance, then you might as well start with the
parity-based levels and just leave it at that.

   Thinking about it, specifying a (redundancy, acceptable_wastage)
pair is fairly pointless in controlling the performance levels,
because it doesn't make the space/speed trade-off explicit. In fact,
without actually doing long-term benchmarks on your hardware and
workloads, it's going to be next-to-impossible to give any concrete
figures, other than "X will be faster than Y".

   So, if you (as $sysadmin) actually care about performance, you'll
have to benchmark your own system and test the various options anyway.
If you don't care about performance and want as much storage as
possible, you'll be using mS1P or mS2P (or possibly mS3P in the
future). There's not much else a heuristic can do, without effectively
exposing all the config options to the admin, in some obfuscated form.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- Great oxymorons of the world, no. 6: Mature Student ---       

--z+pzSjdB7cqptWpS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUT0DZr9z9OVl50rAAQJyAw//Ty0xR+4BOaLj91ZNg5mlHXr0/ngjnbxv
wwtvkuSi2eKoiSn14iwkU6bDa0zKC76o6H75s2uWquHjIAy5l6nUZxNpW9KCCpJo
meKtd4w7Va0degY02xr7e60NPuIAheGm1gT8vZpmFEnvwdnSa9LUelr2wsmirH6j
s1CmkDWzMCjfXF4vkjT8wv6Llzn/10361376WrkVKcfNTZ6Aezfob70ZU+YBGbwM
iofaq8jr5DQX7xw9zC2lQ44tlDfl2yv7fPIbPCZBLpA1MR1429i7JYA9J5dx1/pX
cwC86BR0TXjn62f8H0suTpsqdmKWczb1BF77084XoYrMh6z9lUjcSOV8iSNdaO0G
PJ/v9kMPBwgkA936qZAc+mRe0uxzie5pHCXnVYQE9pjY38l+0w5y+yY/4yjhkRhp
cCOE1wt8aj4/pofdTpbL/xUJownY9hn+RGzzCNlvlCNxfTQm2gA4Oi8xYMnv4CBJ
kq2nkle11PCYHoZIzUwE6mteAoxcq+f7AkbC4QJj3nypUvYAVoqnTbSdkgOaOCXL
piG7V6PmrRAK9lh+t2g0QXM1xbzIAREPyqHlDM6svA7tabtLFjNb+dtIseKiT1WG
jStp6r9HBt7FLiJRgwTMIxacsez0ufQgvsV2a5T5+QVb3xDqdJpu9OFpNMnvjFKH
5rr59FubBG4=
=ga2h
-----END PGP SIGNATURE-----

--z+pzSjdB7cqptWpS--
