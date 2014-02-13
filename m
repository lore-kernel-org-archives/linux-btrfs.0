Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43931 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBMUwu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 15:52:50 -0500
Date: Thu, 13 Feb 2014 20:52:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: kreijack@inwind.it
Cc: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
Message-ID: <20140213205227.GZ6490@carfax.org.uk>
References: <52FCEF46.3070306@jrs-s.net>
 <52FD296F.8050308@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p+/4B2pcxE3X6xU6"
In-Reply-To: <52FD296F.8050308@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--p+/4B2pcxE3X6xU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 09:22:07PM +0100, Goffredo Baroncelli wrote:
> Hi Jim,
> On 02/13/2014 05:13 PM, Jim Salter wrote:
> > Let's say you have five disks, and you arbitrarily want to define a
> > stripe length of four data blocks plus one parity block per "stripe".
> 
> I what it is different from a raid5 setup (which is supported by btrfs)?

   With what's above, yes, that's the current RAID-5 code.

> > Right now, what you're looking at effectively amounts to a RAID3
> > array, like FreeBSD used to use.  But, what if we add two more disks?
> > Or three more disks? Or ten more?  Is there any reason we can't keep
> > our stripe length of four blocks + one parity block, and just
> > distribute them relatively ad-hoc in the same way btrfs-raid1
> > distributes redundant data blocks across an ad-hoc array of disks?
> > 
> > This could be a pretty powerful setup IMO - if you implemented
> > something like this, you'd be able to arbitrarily define your storage
> > efficiency (percentage of parity blocks / data blocks) and your
> > fault-tolerance level (how many drives you can afford to lose before
> > failure) WITHOUT tying it directly to your underlying disks
> 
> May be that it is a good idea, but which would be the advantage to 
> use less drives that the available ones for a RAID ?

   Performance, plus the ability to handle different sized drives.
Hmm... maybe I should do an "optimise" option for the space planner...

> Regarding the fault tolerance level, few weeks ago there was a 
> posting about a kernel library which would provide a generic
> RAID framework capable of several degree of fault tolerance 
> (raid 5,6,7...) [give a look to 
> "[RFC v4 2/3] fs: btrfs: Extends btrfs/raid56 to 
> support up to six parities" 2014/1/25]. This definitely would be a
> big leap forward.
> 
> BTW, the raid5/raid6 support in BTRFS is only for testing purpose. 
> However Chris Mason, told few week ago that he will work on these
> issues.
> 
> [...]
> > necessarily needing to rebalance as you add more disks to the array.
> > This would be a heck of a lot more flexible than ZFS' approach of
> > adding more immutable vdevs.
> 
> There is no needing to re-balance if you add more drives. The next 
> chunk allocation will span all the available drives anyway. It is only 
> required when you want to spans all data already written on all the drives.

   The balance opens up more usable space, unless the new device is
(some nasty function of) the remaining free space on the other drives.
It's not necessarily about spanning the data, although that's an
effect, too.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- It used to take a lot of talent and a certain type of ---      
        upbringing to be perfectly polite and have filthy manners        
            at the same time. Now all it needs is a computer.            

--p+/4B2pcxE3X6xU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUv0wilheFHXiqx3kAQLAwxAAjBNzeP+nzcT0NWyFCBZcKgMjO0c6ghn+
1rUxh0FzYPs5L/mwGYU+76RcNS46eSQyXDvBSPMzPcgEbGGgb+buQPSxNUKue85A
+Mv2NoNHplXc2AIJn7oSD5qrG3+oNlHwqXzGZf91BrzvRsFmP29UJlsZ9lp6xkyQ
lZVcKhpCmc0xyl1y2XqnwxHTbPPR7+BUAfMQCiMiRzuPl8PuOCa2zqNszMwOAODs
AXLCjBvrEm4huuUc2+t0qJt7lD1FLTjrF3YgO2pndHJ/U/P0F+slWJHGRPqIgGqT
+adZL/g2UWax1a4nxBsloKEg7jyGK2A8dfmHhvienOC46DJYJPm7356x1wV6abkq
4xZsX7We6XKjrjqCeFYOUFr3dVVKOCQ4JTxhxkuvSs0ZP6kPfVrpfVHojGywDdRs
/iit/4jCd0kPc+wPgnQwUVh2UtOjhVINqZ9LLXtUPoY5mqblPP/ELnpHQ1vCqM/N
XYFJZg8CjCHQ2xSY8zM9iIMpsnE15Zek17SttXtDfZYtXjolZ4jMCHtBdAg7ls2d
8WNXEQXf4p1Td/9WznWbBlxh12R8U73X6Xu/3wwu8vETpVlAUejvS4fnFx4e46tn
qG8CZubEuv5oEihJ1vqyrsvCYiZz/xaIuVN+8rr8z+5xTmPQN2+2fTgFZdZb7EFe
wkBdMCroT1A=
=xCbz
-----END PGP SIGNATURE-----

--p+/4B2pcxE3X6xU6--
