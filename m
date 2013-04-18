Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:41678 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936351Ab3DRToh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 15:44:37 -0400
Date: Thu, 18 Apr 2013 20:44:31 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID device nomination (Feature request)
Message-ID: <20130418194431.GM7639@carfax.org.uk>
References: <kkotdg$o1e$1@ger.gmane.org>
 <20130418140604.GL7639@carfax.org.uk>
 <kkp70i$cq6$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Do4IU1xF/9sod/r6"
In-Reply-To: <kkp70i$cq6$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Do4IU1xF/9sod/r6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 18, 2013 at 05:29:10PM +0100, Martin wrote:
> On 18/04/13 15:06, Hugo Mills wrote:
> > On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
> >> Dear Devs,
> >> 
> >> I have a number of esata disk packs holding 4 physical disks each
> >> where I wish to use the disk packs aggregated for 16TB and up to
> >> 64TB backups...
> >> 
> >> Can btrfs...?
> >> 
> >> 1:
> >> 
> >> Mirror data such that there is a copy of data on each *disk pack*
> >> ?
> >> 
> >> Note that esata shows just the disks as individual physical
> >> disks, 4 per disk pack. Can physical disks be grouped together to
> >> force the RAID data to be mirrored across all the nominated
> >> groups?
> > 
> > Interesting you should ask this: I realised quite recently that 
> > this could probably be done fairly easily with a modification to
> > the chunk allocator.
> 
> Hey, that sounds good. And easy? ;-)
> 
> Possible?...

   We'll see... I'm a bit busy for the next week or so, but I'll see
what I can do.

> >> 2:
> >> 
> >> Similarly for a mix of different storage technologies such as 
> >> manufacturer or type (SSD/HDD), can the disks be grouped to
> >> ensure a copy of the data is replicated across all the groups?
> >> 
> >> For example, I deliberately buy HDDs from different 
> >> batches/manufacturers to try to avoid common mode or similarly
> >> timed failures. Can btrfs be guided to safely spread the RAID
> >> data across the *different* hardware types/batches?
> > 
> > From the kernel point of view, this is the same question as the 
> > previous one.
> 
> Indeed so.
> 
> The question is how the groups of disks are determined:
> 
> Manually by the user for mkfs.btrfs and/or specified when disks are
> added/replaced;
> 
> Or somehow automatically detected (but with a user override).
> 
> 
> Have a "disk group" UUID for a group of disks similar to that done for
> md-raid?

   I was planning on simply having userspace assign a (small) integer
to each device. Devices with the same integer are in the same group,
and won't have more than one copy of any given piece of data assigned
to them. Note that there's already an unused "disk group" item which
is a 32-bit integer in the device structure, which looks like it can
be repurposed for this; there's no spare space in the device
structure, so anything more than that will involve some kind of disk
format change.

> >> 3:
> >> 
> >> Also, for different speeds of disks, can btrfs tune itself to
> >> balance the read/writes accordingly?
> > 
> > Not that I'm aware of.
> 
> A 'nice to have' would be some sort of read-access load balancing with
> options to balance latency or queue depth... Could btrfs do that
> independently (complimentary with) of the block layer schedulers?

   All things are possible... :) Whether it's something that someone
will actually do or not, I don't know. There's an argument for getting
some policy into that allocation decision for other purposes (e.g.
trying to ensure that if a disk dies from a filesystem with "single"
allocation, you lose the fewest number of files).

   On the other hand, this is probably going to be one of those things
that could have really nasty performance effects. It's also somewhat
beyond my knowledge right now, so someone else will have to look at
it. :)

> >> 4:
> >> 
> >> Further thought: For SSDs, is the "minimise heads movement"
> >> 'staircase' code bypassed so as to speed up allocation for the
> >> "don't care" addressing (near zero seek time) of SSDs?
> > 
> > I think this is more to do with the behaviour of the block layer 
> > than the FS. There are alternative elevators that can be used, but
> > I don't know how to configure them (or whether they need
> > configuring at all).
> 
> Regardless of the block level io schedulers, does not btrfs determine
> the LBA allocation?...
> 
> For example, if for an SSD, the next free space allocation for
> whatever is to be newly written could become more like a log based
> round-robin allocation across the entire SSD (NILFS-like?) rather than
> trying to localise data to minimise the physical head movement as for
> a HDD.
> 
> Or is there no useful gain with that over simply using the same one
> lump of allocator code as for HDDs?

   No idea. It's going to need someone to write the code and benchmark
the options, I suspect.

> > On the other hand, it's entirely possible that something else will 
> > go wrong and things will blow up. My guess is that unless you have
> [...]
> 
> My worry for moving up to spreading a filesystem across multiple disk
> packs is for when the disk pack hardware itself fails taking out all
> four disks...
> 
> (And there's always the worry of the esata lead getting yanked to take
> out all four disks...)

   As I said, I've done the latter myself. The array *should* go into
read-only mode, preventing any damage. You will then need to unmount
the whole thing, ensure that the original disks are all back in place
and detected again, and remount the FS. In theory, that should then be
able to continue working from where it left off (because of the
consistency guarantees of the FS).

   If a controller fails, then assuming it fails hard (i.e. doesn't
continue to acknowledge writes when it's not actually making them),
that should be equivalent to the situation above.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                     --- O tempura! O moresushi! ---                     

--Do4IU1xF/9sod/r6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUXBNH1heFHXiqx3kAQLwGBAAitD94UqLgvW2UcD1nIcUAcB1xXVS6Moh
ZOnqO4PziQodBkLemNGqWcoOtIOOYfwH7rPtFDd69P6zDxzHkNxlo2e2s+vQCj+q
okcaFdPMx8WFsbAemJQ2ySBr6xByghzMHgGpuHsLWISPmX24t9bbJqfn8k4PThvX
ioTEX8fDSsPOX4FJFhh7hf5Bfpo6ACCtFyeEYuJmu1ZJy/kI4vRYV1LuNa4GGYzo
jehgq49lRra7icbSg8sQ3MIujIwu5IkyXWZVWD74nvpq29MamjJ1x0CNng+St1lG
322VSc3m3NocNIJSxUbN86ii2MV374mFb08WLD5cJ9J7w0dxcnKXXq5+DpUmCoCa
dqJpG1CDecP8NxopVZq4g4s9v6gvXPqkG7mblyO8lc8biOcV8aIoz/itaXtJMNb+
BrLtF+Fu80VerDinVuZ/G/eQB48kd12GN+1U1yRsz5uzoK9y5couAJhrlWA9vgtj
d2WjhCsXl1PMcALwQ6+AV6XYUsHl7MwiAI948zTNhxKIRm0X7LdPvU4/Df+wDbYG
uJjV3oWp0HeAP2EHcBeTM10sn7fkiY9WudP+sRW39DOHzgrlxglF7DXBq2dDMlF7
ZXzKHWwY5TNQGjJYo43qnQitzXgwnaNmOTS1yuc3Kmh17exKUEINJBRj8NaH/uZU
7oDRChN8SFo=
=Fpe7
-----END PGP SIGNATURE-----

--Do4IU1xF/9sod/r6--
