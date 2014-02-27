Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58285 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaB0HtY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 02:49:24 -0500
Date: Thu, 27 Feb 2014 07:48:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcus Sundman <sundman@iki.fi>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Jim Salter <jim@jrs-s.net>
Subject: Re: No space left on device (again)
Message-ID: <20140227074857.GD13899@carfax.org.uk>
References: <530CC9B0.1080703@iki.fi>
 <530CDB7F.9020807@jrs-s.net>
 <20140225201921.GB13899@carfax.org.uk>
 <530CFCCE.5060707@iki.fi>
 <530CFD66.7060006@fb.com>
 <530E83C7.5080101@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zI0WCX1RcnW9Hbu"
In-Reply-To: <530E83C7.5080101@iki.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4zI0WCX1RcnW9Hbu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 02:16:07AM +0200, Marcus Sundman wrote:
> On 25.02.2014 22:30, Josef Bacik wrote:
> >On 02/25/2014 03:27 PM, Marcus Sundman wrote:
> >>On 25.02.2014 22:19, Hugo Mills wrote:
> >>>On Tue, Feb 25, 2014 at 01:05:51PM -0500, Jim Salter wrote:
> >>>>370GB of 410GB used isn't really "fine", it's over 90% usage.
> >>>>
> >>>>That said, I'd be interested to know why btrfs fi show
> >>>>/dev/sda3 shows 412.54G used, but btrfs fi df /home shows 379G
> >>>>used...
> >>>This is an FAQ...
> >>>
> >>>btrfs fi show tells you how much is allocated out of the
> >>>available pool on each disk. btrfs fi df then shows how much of
> >>>that allocated space (in each category) is used.
> >>What is the difference between the "used 371.11GB" and the "used
> >>412.54GB" displayed by "btrfs fi show"?
> >>
> >>>The problem here is also in the FAQ: the metadata is close to
> >>>full -- typically something like 500-750 MiB of headroom is
> >>>needed in metadata. The FS can't allocate more metadata because
> >>>it's allocated everything already (total=used in btrfs fi show),
> >>>so the solution is to do a filtered balance:
> >>>
> >>>btrfs balance start -dusage=5 /mountpoint
> >>Of course that was the first thing I tried, and it didn't help *at*
> >>*all*:
> >>
> >The -dusage=<number> is a means to an end, so if that doesn't work try
> >a larger number, up to 100.  Really once you pass 50 and it's not
> >working then it's time to just do a balance.  The next thing is to use
> >compression (too late for this option really) or add another disk.
> 
> So it relocates some chunks. What will that do? Does it mean I can
> now use the remaining 45 GB? Or will it run out of "disk space"
> again after using a gig or two?

   What it's done is moved some of the data around. One effect of this
process is that when a balance operation balances a chunk, it
deallocates that space. Therefore you should now see that the "used"
value for the device in btrfs fi show is lower than the "total" value.
Also, the "total" value for data in btrfs fi df should now be lower
than it was before.

   This means that the next time the FS needs some metadata space
(probably real soon now, because it was running out of it earlier), it
now has uncommitted space to allocate to metadata.

> If it's the allocated metadata space that is the problem then how
> can I pre-allocate more of it so it won't run out of it?

   It's possible that when filling up the remaining 45 GiB of space
the metadata will need to expand again, and you will need to run a
balance to do the same job again. Unless you have lots and lots of
small files or small fragments (or lots more snapshots than you've
been making to date), I'd say it's probably unlikely, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Well, sir, the floor is yours.  But remember, the ---        
                              roof is ours!                              

--4zI0WCX1RcnW9Hbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUw7t6VheFHXiqx3kAQJbpA/+Lp9dMMAFscKAwbyX/I0KuOIhULLo8fzm
Re4U4B6iWk1TT5JORusRwM2AJ9Sq4CAEwYtSI2taj6X6SuDlf8asefQb8nKkA3jb
ujC0vxJfx7O/SWYueX3ebLaI4sbTgjDWb/29Sa6j5GT/iUMy7WrPL+ccdNirneHZ
mdK3ppy8CAkSCB3L3DEtcx75ATF4aLm6Jg0+74dzr2jVeGvmdE2gto7IqIISX0h1
DzUcDVqkcGlH/AA7di0sysC+N8jhYHYqISefhZhH2AJyRrKW8ISFW3/2qiVq3n8S
Jjh3+CRIuwdKHhIAUUnVNjWlss8rdJj9RNV8DbEBinuN2T2QO2srIxbVM05J13/S
C6GjgTzXzM2etYkpg1RaLodFhwC2zBJj0a9dYxiKYJvwKqrNwpdiFtnLa2hCP9K7
cENNtO1s03RKU+eyWJ7qoBrLb0lYQEbmBMH/+CDy2JVc5HvqaKHwokaE2l8a02vj
1VK4D/yGu/s6SqwEZqTy7kzmiaJQWwSNt1O/alA8UclINiGyzb29qJcMi9pErlZ+
0kGtqBDFC0RPEf+prZPjAUMbi2UQi/7AIv/SXgvbTDGVkbX1ALG0FdK7nl9rT3zH
Ptg5E8rGx+8Mm3DfXCk33EtQFiDQo793WLk9pfFuxOFjT5ukleUTcMe8jR/N44MB
Qb4NaptAqEI=
=p3tJ
-----END PGP SIGNATURE-----

--4zI0WCX1RcnW9Hbu--
