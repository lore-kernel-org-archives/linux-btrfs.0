Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:35963 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbKSS2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 13:28:53 -0500
Date: Thu, 19 Nov 2015 18:28:50 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs.tebulin@xoxy.net
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: Kernel 3.19 and still "disk full" even though 'btrfs fi df"
 reports enough room left?
Message-ID: <20151119182850.GE24333@carfax.org.uk>
References: <564CC90F.3060703@gmail.com>
 <20151118190857.GY24333@carfax.org.uk>
 <564E085C.3060208@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="slMCvwAS3D50yFKj"
In-Reply-To: <564E085C.3060208@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--slMCvwAS3D50yFKj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 19, 2015 at 06:35:24PM +0100, linux-btrfs.tebulin@xoxy.net wrote:
> Many thanks to everybody on the list for the awful a lot help I received. 
> I'm impressed by the amount, quality and speed of the responses I received!
> > See the FAQ[1] for how to interpret the output. ...
> Very helpful, thanks. 
>  
> > The solution is to free up some of the data allocation, using a filtered balance.
> As noted in my original post, this is already part of my "voodoo" I'm doing in these situations. 

   Sometimes it's useful to know what the voodoo is actually doing. :)

> Will newer kernel relieve me from this burden?

   Not in any current or planned kernel, to the best of my knowledge.

> FYI: On executing "btrfs fi show" the first time after I deleted many snapshots and did a filtered (-dusage) balance, it reported sth. like 
> 	devid    1 size 119.21GiB used 117.03GiB
> now (after a unfiltered balance?) it reports 
> 	devid    1 size 119.21GiB used 66.06GiB
> 
> I'm really confuzzled.

   It's just freed up lots of space. You'll probably find that your
"total" value for data in btrfs fi df is close to (but not exactly) 66
GiB now, if you've just run a full unfiltered balance. (The difference
being made up of metadata).

> > [..] Ubuntu repeatedly chooses to stabilize on exactly the wrong kernel versions.
> > ..
> > Give http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.1.13-wily/ a try.
> Could not agree more. Will give wily kernel a try.
> 
> > The output is really a little confusing. [..] should make the output more understandable. 
> +1 
> Considering that the status of a file systems should be understandable by regular users, it would be great if the btrfs tools could provide additional user hints like _"I seems your metadata space is running out of space. Please run `foo bar` to resolve this situation or consult FAQ[4] for more details"_. 

   There's a repo of "useful btrfs scripts" that David Sterba looks
after. I think there's already a script to go in your cron.daily
directory that already does the check and balances if necessary. If
there isn't, there should be (and it shouldn't be that hard to write,
either).

   David -- where is that repo?

[snip]
> I'm still a bit puzzled how to avoid my situation in the first place. 
> Should I pick "btrfs show" in favor to "btrfs fi df" to learn about an impending "disk full" situation?  

   In the general case, you need both of them to make sense of it. (Or
just btrfs fi usage) You're looking for the FS fully allocated, and
metadata usage+block reserve very close to metadata allocation.

> Will newer kernels do the balance on their own? 

   I think it's on the "projects" list on the wiki, so it may get done
eventually. As I said above, I'm not aware of anyone working on it.

   Hugo.

-- 
Hugo Mills             | 2 + 2 = 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--slMCvwAS3D50yFKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWThTiAAoJEFheFHXiqx3k3UoP/jBe0ZUk1yb7dRP2aXOHR4YM
E6kO9cpESa1lvl8ZQVh93yMoqkfYzwEJClNRrCp7NvrpvKLGH2mk+ea7KCWK+YKp
abY2BxSXn5tCut1FaRS1mU/6IdRlLXndRBIBHqK4zq6L3KlNTipo4WbiPf+6Tp+N
a8+0PRwbNFXZ1NZ7LHCSCAlNhMTL2egZeaF7ZQ8chHK/FbAMXYorXMbi0UjPUXzU
FLaRGKLz1KO6XD9ku0KP3Ja82Y3MQXop7PEHlIX95tUl6byE1PZGgZhDgB5jsmya
vpXNFsLKr/2eY3BcKTG+hOUZdNwRVwb9rWs4H9EPqmU+EOOD9Ry70/v94SpD3NMt
u3WBz2OSTBaT9JgJwT/PiPJQWxEC4XcVqVCkqqis5E7wKFrQgDObekWA09Z3A/Va
ZvKP21DRHlvmWruyshiqH4yzuMWFXkxb87rczrXXvwdL8vxuxxyo+mUDC8WFEKzM
Zh6gmypMF8ndiO2WYO89B9+/pItMYuGOodf/3cFdpN+1naAOCruj+BUEu8mxQfAV
hjbG17DDIhMt8AZKr71yS0ANVK2bGMGtkLiehztqVMFtGhxb/cXFe7C1UcD4TcY6
oMzS4mrUsAItGoulwGPoj18n4wwJwnhc5Ne5sq0hohM2kRciopXj1bhIkeddaknk
g9DOO4UeKrAjjazY2516
=f55C
-----END PGP SIGNATURE-----

--slMCvwAS3D50yFKj--
