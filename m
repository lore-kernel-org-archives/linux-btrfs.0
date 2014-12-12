Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42492 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967795AbaLLN3c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 08:29:32 -0500
Date: Fri, 12 Dec 2014 13:29:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mkfs.btrfs limits "odd" [and maybe a "failed" phantom device?]
Message-ID: <20141212132928.GE1442@carfax.org.uk>
References: <5488C6CF.1080608@pobox.com>
 <20141212035651.GD22023@hungrycats.org>
 <548A84A2.4000501@pobox.com>
 <20141212090647.GA5574@yadt.co.uk>
 <548ACE73.3000000@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WBsA/oQW3eTA3LlM"
In-Reply-To: <548ACE73.3000000@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WBsA/oQW3eTA3LlM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 03:16:03AM -0800, Robert White wrote:
> On 12/12/2014 01:06 AM, David Taylor wrote:
> >The above quote is discussing two device RAID5, you are discussing
> >three device RAID5.
> 
> Heresy! (yes, some humor is required here.)
> 
> There is no such thing as a "two device RAID5". That's what RAID1 is for.
> 
> Saying "The above quote is discussing a two device RAID5" is exactly
> like saying "The above quote is discussing a two wheeled tricycle".
> 
> You might as well be talking about three-octet IP addresses. That is
> you could make a network address out of three octets, but it
> wouldn't' be an IP address. It would be something else with the
> wrong name attached.

   OK. Sounds like I need to dust off the change-of-nomenclature patch
again.

   The argument here is about the 1c1s1p configuration. Is there a
problem with that?

   Hugo.

> I challenge you... nay I _defy_ you... to find a single authority on
> disk storage anywhere on this planet (except, apparently, this list
> and its directly attached people and materials) that discusses,
> describes, or acknowledges the existence of a "two device RAID5"
> while not discussing a system with an arity of 3 degraded by the
> absence of one media.
> 
> All these words have standardized definitions.
> 
> [That's not hyperbole. I searched for several hours and could not
> find _any_ reference anywhere to construction of a RAID5 array using
> only two devices that did not involve airity-3 and a
> dummy/missing/failed psudo target. So if you can find any reference
> to doing this _anywhere_ outside of BTRFS I'd like to see it.
> Genuinely.]
> 
> THAT SAID...
> 
> I really can find no reason the math wouldn't work using only two
> drives. It would be a terrific waste of CPU cycles and storage space
> to construct the stripe buffers and do the XORs instead of just
> copying the data, but the math would work.
> 
> So, um, "well I'll be damned".
> 
> Perhaps is just a tautological belief that someone here didn't buy
> into. Like how people keep partitioning drives into little slices
> for things because thats the preserved wisdom from early eighties.
> 
> I think constructing a non-degraded-mode two device thing and
> calling it RAID5 will surprise virtually _everyone_ on the planet.
> 
> In every other system. And I do mean _every_ other system, if I had
> two media and I put them under RAID-5 I'd be required to specify the
> third drive as some sort failed device (the block device equivalent
> of /dev/null but that returns error results for all operations
> instead of successes.) See the reserved keyword "missing" in the
> mdadm documentation etc.
> 
> That is, If I put two 1TiB disks into a RAID-5 I'd expect to get a
> 2TiB array with no actual redundancy. As in
> 
> mdadm --create md0 --level=r5 --raid-devices=3 /dev/sda missing /dev/sdc
> 
> the resulting array would be the same effective size as a stripe of
> the two drives, but when the third was added later it would just
> slot in as a replacement for the missing device and the airity-3
> thing would "reestablish" it's redundancy. (this is actually what
> mdadm does internally with a normal build, it blesses the first N-1
> drives into an array with a missing member, and adds the Nth drive
> as a "spare" and then the spare is immediately adopted as a
> replacement for the "missing" drive.)
> 
> The parity computation on a single value is just nutty waste of time
> though. "Backing it out" when the array is degraded is double-nuts.
> 
> Maybe everybody just decided it was too crazy to consider for the
> CPU time penalty...?
> 
> So yea, semantics... apparently...

-- 
Hugo Mills             | There's an infinite number of monkeys outside who
hugo@... carfax.org.uk | want to talk to us about this new script for Hamlet
http://carfax.org.uk/  | they've worked out!
PGP: 65E74AC0          |                                           Arthur Dent

--WBsA/oQW3eTA3LlM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUiu24AAoJEFheFHXiqx3k+qsP/2Vn0RLT1bjaGZr1Q6OHsFkF
j203tkwrWkZzq+2yB8/bWqXoiXFXIxEeFADRK9/Bn90SLKNQvhHEgp0/33JP1VVG
7bOPSEPcVcb0+OduKVUMQR+1h5T9wpatkfqjkolC/dCH+ZnBv5GiMElFrTytP+6s
vlZBeXUXtRJLl8bdyHKujJIhO1GxWooqA9fgQarunBkVDhhhfWJl/lnZyXpDxXnC
9Sw0tVDvb0BIo48WdjB8DwbshE9Xfy5tbIo3g97wSNT7kMqsBV2K7XRhhKKi/vA+
1NtlhfznbekaN1W6+D3QqRvX9UCmfc+1FLLIv4i5MobTFb+ksCbI/LsCpNS4XhTf
aEe/8i9SlLuACc/pLxXZztFvBRpUsQ4XV99+ykKSYjlUGXHV5+xINAoXvtXBA+zM
AFEtWEE5aCa4YvX/P3sAIYluVMWMgMB6mE6sJcnriQxY3FdYZ7y5HTzy/iMoQoJI
Gty6LxMblzxkq0JAXdqMDgQJlgk+od7+KQPxG5NYIx1CPN79HQQxpbjvQtxri0ek
d5SWcAX/oikX50abbIWF0Yeiibmq+MVNMwcKDqktLZoIC1bcYWzEcUS6eYgucsVd
02qcqKoG6O9qsudLTI4JqhlITmERrziY5i2mORmVDrIHcfCbuRcHteK6ni9P02oR
Tj+I0NiELp+2Pwzx0wJ8
=X2me
-----END PGP SIGNATURE-----

--WBsA/oQW3eTA3LlM--
