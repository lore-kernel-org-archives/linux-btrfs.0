Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45015 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBJRGc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 12:06:32 -0500
Date: Mon, 10 Feb 2014 17:06:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: "lin >> \"linux-btrfs@vger.kernel.org\""
	<linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
Message-ID: <20140210170606.GK6490@carfax.org.uk>
References: <52F9014F.6070901@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBYU9MM4gf8jKg2V"
In-Reply-To: <52F9014F.6070901@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gBYU9MM4gf8jKg2V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tl;dr: Yes to proposed df changes. Keep btrfs fi df as-is.

On Mon, Feb 10, 2014 at 11:41:51AM -0500, Josef Bacik wrote:
[snip]
> =====  What to do moving forward =====
> 
> Flip what both of these do.  Do not multiply for normal df, and
> multiply for btrfs fi df.
> 
> ===== New and improved df =====
> 
> Since this is the lowest common denominator we should just spit out
> how much space is used based on the block groups and then divide the
> remaining space that hasn't been allocated yet by the raid
> multiplier.
> 
> This is going to be kind of tricky once we do per-subvolume RAID
> levels, but this falls under the b_avail voodoo which is just a
> guess anyway, so for this we will probably take the biggest
> multiplier and use that to show how much available space you have.

   Biggest multiplier leads to the pessimistic estimate, which is what
I'd prefer to see here, so that's good. Agree with this.

> This way with RAID1 it shows you have 1tb of total space and you've
> used 1tb of space.
> 
> ===== New and improved btrfs fi df =====
> 
> Since people using this tool are already going to be better informed
> and since we are already given the block group flags we can go ahead
> and do the raid multiplier in btrfs-progs and spit out the adjusted
> numbers rather than the raw numbers we get from the ioctl.  This
> will just be a progs thing and that way we can possibly add an
> option to not apply the multipliers and just get the raw output.

   Keep this unchanged, IMO.

(a) I quite like the non-multiplied version as it is, as it gives you
    the quantities of real, actual data stored -- the value you
    generally care about anyway ("how much stuff do I have on here?").

(b) Using the non-multiplied version here as well as above would then
    give >gasp< comparable values for btrfs fi df and Plain Old df.
    Less confusion all round, I think.

(c) The difficulty with using multiplied values is the behaviour of
    parity RAID on filesystems with different sized devices: there
    isn't a single multiplier that will give an accurate answer at
    all. (Detailed arguments available on application ;) )

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- "Can I offer you anything? Tea? Seedcake? ---            
                         Glass of Amontillado?"                          

--gBYU9MM4gf8jKg2V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvkG/lheFHXiqx3kAQLDOw//TfNNos6WfTdXbCSgjumoWJfVWUCAmgcU
vlq4EpWVxIW2mmGTrrPmDDujv4nqUMhZi0ayVordGS0mKp8gTgbUyJMc/q/9traL
4RdBt6qXkZl0k0Xl5HlikWD3838fnS78mP5xm7MjwmM/eJcYeAZ0KBbkQmMOieVV
M7WjymuUKfXngpQiL1oyjbqx57VYELvJxan5gLBsr4nmGTOsdOLHli2azxezocnE
QfxmCjj1EoRAl1LqEGxb+epV0AWNb0V35gTthfMVC+BNVHt3f6y+gcOVHbT19cLm
+q9rjTEzY+YFQgsugN+SBnDLsMyVlgDCxQkKuiwd1QL0QzWSFKe2bqEJxBRs3eHg
+CTRxlJE1zYWw4j4ZGgAmr5ZxG5aRc/fZgcFgp6O6RQBwPqv1Nb0bLq24iT+d0lJ
unPIq6PDfurb5yg3qPooBDZZOBKd6yRvdEMWrJFG2xVbxz4WhsazP5WaKf4LE18X
LvorrC0F26whpjbjaLtA+sZd2r3mn8UBMLbRJNGk1wKhYYplOeFO7PU+wD5b00Q5
ExZFoVHbSv+gXL9vuQuQ22RH9VjQ8EvVzNxyuTIiqkrZMlYVyPvBoW3A6KCj4thM
qqvCa0w5+jA/J2Lm/6teF5JPwOk47/1LXdejORitToANfX99CUavvu7mkcZMm+Fw
W4FPJO3J9No=
=UKGK
-----END PGP SIGNATURE-----

--gBYU9MM4gf8jKg2V--
