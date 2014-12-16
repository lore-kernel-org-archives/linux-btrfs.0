Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51775 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaLPJFq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:05:46 -0500
Date: Tue, 16 Dec 2014 09:05:40 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] Print the summary
Message-ID: <20141216090540.GK1442@carfax.org.uk>
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
 <1418673780-22000-7-git-send-email-kreijack@inwind.it>
 <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net>
 <548FAB3A.7060009@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qo8f1a4rgWw9S/zY"
In-Reply-To: <548FAB3A.7060009@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Qo8f1a4rgWw9S/zY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 07:47:06PM -0800, Robert White wrote:
> On 12/15/2014 05:58 PM, Duncan wrote:
> >* Please s/disk/device/, here and possibly elsewhere.  I know I'm not the
> >only one who is trying to make the switch in my own usage, as it looks a
> >bit foolish (and/or marks the user as an old fogey who's likely to start
> >lecturing about how a GiB isn't "small", as I'm known to do at times!
> >=:^) already, as it's only going to be more so over time.
> 
> I am actually not fond of "disk" nor "device" as both carry
> potentially false information.
> 
> I prefer "slice", not that I am totally happy with that word either.
> But by the time you get through loopback devices, memory map
> devices, the "device files" that represent parts of "partitioned"
> devices, logical "volumes", and god only knows what future
> "thingies" we will end up dealing with... I like the terms that
> remove false hints.

   All this agreed, but "slice" will be largely viewed as a neologism
by anyone who hasn't used (IIRC) BSD or Solaris. On the other hand,
for all their other flaws, "device" is much better than "disk" here,
as you could he talking about a partition, a flash memory card (which
many people don't view as "disks"), or a network block device. You
could refer to a "block device" to clarify, because that's really what
we're talking about here, but it could get a bit cumbersome.

   Hugo.

> In linux we (currently, and for the foreseeable future) use the
> device files and so conflate "device" with all the above.
> 
> But if the code base and format were to spread to another platform...
> 
> And besides, using device carries its own lingual hazzards.
> 
> "device 1 is a whole device /dev/sda, while device two is a
> partition on a partition called /dev/sdb1, and device three is on a
> partition called /dev/sdb2 which is really on the same device as the
> second device." etc.
> 
> 
> "slice one is a whole device, /dev/sda; slice two is on a partition
> called /dev/sdb1; slice three is on a partition called /dev/sdb2,
> which shares the same device as slice two."
> 
> Much clearer when things get nasty.
> 
> "Slice" comes from programming, where arrays of storage can be
> "sliced" and recombined. The term was popularized (if memory serves)
> by Ada, not that Ada became popular. 8-)
> 
> You can have slices of anything, so like using a "slice of ram" makes sense.
> 
> It just seems like a waste to school yourself to eschew "disk" for
> "device" when the latter carries almost as much problematic baggage
> as the former.

-- 
Hugo Mills             | Great films about cricket: 200/1: A Pace Odyssey
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: 65E74AC0          |

--Qo8f1a4rgWw9S/zY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUj/XkAAoJEFheFHXiqx3kF+sP/RuTn2OBramEv/6OMAKlOaMp
hkHIu1nS9OtDtQTABxEaNpUit0OtiBgxGIQXvXz5aR7b2YRz4c+r1ARrHmvcbyPh
iloyA6oZxrbFQa/Qd1gxWsI5X/VeZFUuL1srfekfAdINVScU6pYwaUjCEbL04ekJ
sqxHTR2BWNOkKK9dGZLw/wnv+0CiuqJG736Xd916rvYpFgPJ0iv7ueFz2DcJSx5f
CtBnhCDCqgXlsiA0PEMnK00fm0f67udt2Wqd3iwx9z3KM/SV2/Ej4NdriXg1UwXP
OaMhHhyUsJVL+P0v6a7RELS0jdJDWdt/xc2lKBhP47PiDsCrs/7CBs4/P+dVNKV7
ycLcoDptgoQRKkKIgkY5ntuOEYZnzoxEL67tlXO8bTt4OMxKewCeIs8NzHsoqX8L
rD9c+pct+k5ZDAk20x4k8Dyve9D0Amk4G4+ZGcQ2Gg5gjWotqQgOMB5K4kux1cVG
7EqkGChBj2xPuGWZ/OJd+FYgieHndS7UH9CElszcY8OjLQ6FfnWHZ004LVJ055YV
4IXFU6GqGJ6c0BrMovtrxPemPR/FAmWnqo6RTtGZX9lS7xpxOTgnjkc8K9x/Nknr
MLNAKVn1XlrT+DQ1UBcfRaBKOhIetItJcthPCsdYD3C3m5e1Qi6v2lFLngw3o3uu
sQnLWa4pDDzoaz3+wfJf
=rZzE
-----END PGP SIGNATURE-----

--Qo8f1a4rgWw9S/zY--
