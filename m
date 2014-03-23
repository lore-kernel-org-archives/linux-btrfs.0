Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59479 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaCWQ22 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 12:28:28 -0400
Date: Sun, 23 Mar 2014 16:28:25 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: error during balancing '.' - No space left on device
Message-ID: <20140323162825.GF25400@carfax.org.uk>
References: <pan$a5998$152d4a82$370a3453$dc1d788e@cox.net>
 <20140323114712.GC25400@carfax.org.uk>
 <20140323162000.GK12833@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
In-Reply-To: <20140323162000.GK12833@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 23, 2014 at 09:20:00AM -0700, Marc MERLIN wrote:
> Both
> legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=5 /mnt/btrfs_pool2
> legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=0 /mnt/btrfs_pool2
> failed unfortunately.
> 
> On Sun, Mar 23, 2014 at 12:26:32PM +0000, Duncan wrote:
> > When it rains, it pours.  What you're missing is that this is now the 
> > third thread in three days with exactly the same out-of-space-when-there-
> > appears-to-be-plenty problem, which is well explained and a solution 
> > presented, along with further discussion, on those threads.
> > 
> > Evidently you haven't read the others, but rather than rewrite a similar 
> > reply here with exactly the same explanation and fix, I'll just refer you 
> > to them.
> 
> Thanks. Indeed, while I spent most of yesterday dealing with 3 btrfs
> filesystems, the one here that was hanging my laptop, the raid5 one that
> was hanging repeatedly during balance, and then my main server were one
> FS is so slow that it takes 8H to do an reflink copy or delete a backup
> with 1 million inodes, I got behind on reading the list :)
> 
> Thanks for the pointers
> 
> > btrfs balance start -dusage=5 `pwd`
> > 
> > Tweak the N in usage=N as needed.
> 
> I had actually tried this, but it failed too:
> legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=5 /mnt/btrfs_pool2
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=5
> ERROR: error during balancing '/mnt/btrfs_pool2' - No space left on device
> 
> But I now just found
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters
> and tried -dusage=0
>  
> On Sun, Mar 23, 2014 at 11:47:12AM +0000, Hugo Mills wrote:
> >    I think you probably shouldn't be doing a full balance, but a
> > filtered one:
> > 
> > # btrfs balance start -dusage=5 /mnt/btrfs_pool
> > 
> > which should only try to clean up chunks which have little usage (so
> > it's much faster to run).
> 
> Thanks for the other answer Hugo.
> 
> So, now I'm down to 
> legolas:/mnt/btrfs_pool2# btrfs balance start -v -dusage=0 /mnt/btrfs_pool2
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=0
> ERROR: error during balancing '/mnt/btrfs_pool2' - No space left on device
> 
> Looks like there is no good way out of this, so I'll start deleting
> snapshots.

   Before you do this, can you take a btrfs-image of your metadata,
and add a report to bugzilla.kernel.org? You're not the only person
who's had this problem recently, and I suspect there's something
still lurking in there that needs attention.

> Hopefully this will be handled better in later code.

   With the info you can provide from a btrfs-image... let's hope so. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---    
                       course,  in a state of sin.                       

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUy8LqVheFHXiqx3kAQKmOA/+MrlxNdkThRsYrsPxqNYEuIOYfv/ilCRR
ppKCUst6Fabni4HENcHFOfiFHbF4Bye3A5/1LYY5m8bHcRFoqwo+f94hh5KG8h4L
sFNBwaEdVjbcbDPLlD8rZCyUHBpOC33Baax9qGVd1d0ZXIhbQdL1/vMX674L07CF
rYw6AQVLbWei7sJ6jpAeE+cBcv4uoiDq+uMzlb1oInw51afAeZOmPXdZueniLoWb
7n2FvyES7lNaQ3/0Ecg9yzEvMSvRspKr5OzEiTQCSsUv07FFP8vr+WsFl3Xt82ue
Vs3/fC4fEI9NyVBXfaeeJoXSvxFp2SumvCXjCj/Q7J0PI1XObuoqNJoFnbP3i+4N
hpkOJxLU+Qx0zXh6TwvWx7kT/QpBTixNt3Ndu5AKbh6RN6pHqcCcBjJBgRRy3HJW
zJ1exX3TV+5asZX0qoPFJ+6ZGHxxITbwy7q32Xk31Raa/eGf3OpYlJf91J4XpNYa
Pc/Nv1DIROE6Z77wWY+1XoFVu4yrjnCpv7XqLjyYVGDTGfW5dLz0OR2WFGRewIr0
D/SFBQk2OUUk5vkmUVnD262QEVonwO2tQTVgMaMFxvgigebWywMEXMX+XcpWQ8pM
gYMOi9VLWrufcysM8XD5M/K81aQM9W/MlZ2wCLYL3jTtAqYEdeUod5mL82Zn71Q7
gyub3y/klCU=
=yEu8
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
