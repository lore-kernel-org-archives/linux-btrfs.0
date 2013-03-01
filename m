Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:40423 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CASF2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2013 13:05:28 -0500
Date: Fri, 1 Mar 2013 18:05:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: usage should match what is coded
Message-ID: <20130301180521.GO14283@carfax.org.uk>
References: <1362132602-29501-1-git-send-email-anand.jain@oracle.com>
 <1362132602-29501-2-git-send-email-anand.jain@oracle.com>
 <5130E9C6.6000704@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6o78gXsyQHm68LY/"
In-Reply-To: <5130E9C6.6000704@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--6o78gXsyQHm68LY/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 01, 2013 at 11:47:50AM -0600, Eric Sandeen wrote:
> On 3/1/13 4:10 AM, Anand Jain wrote:
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Revieed-by: Eric Sandeen <sandeen@redhat.com>
> 
> But the curious side of me wonders how it got this way.
> 
> commit e43cc461550130494194201037590a2b1f0f6880
> Author: Ian Kumlien <pomac@demius.net>
> Date:   Fri Feb 8 01:37:02 2013 +0100
> 
>     Btrfs-progs: add restore command to btrfs
> 
> added the usage text below, but didn't change the getopt
> or add code to handle them.
> 
> No idea where it came from, it wasn't in the standalone
> restore either.  *shrug*  I guess nothing got lost.

   -m was definitely a thing at some point, as I recall using it. I
think the code was in josef's progs tree. I suspect the other options
were part of that, too. (And -m was definitely really useful for me).

   Hugo.

> -Eric
> 
> > ---
> >  cmds-restore.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/cmds-restore.c b/cmds-restore.c
> > index 9385042..4a14f93 100644
> > --- a/cmds-restore.c
> > +++ b/cmds-restore.c
> > @@ -763,10 +763,6 @@ const char * const cmd_restore_usage[] = {
> >  	"-f <offset>     filesystem location",
> >  	"-u <block>      super mirror",
> >  	"-d              find dir",
> > -	"-r <num>        root objectid",
> > -	"-c              ignore case in regular expression",
> > -	"-m <regexp>     regular expression to match",
> > -	"-l              list roots",
> >  	NULL
> >  };
> >  
> > 
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--6o78gXsyQHm68LY/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUTDt4L9z9OVl50rAAQJFXQ//caGa6S1kYWCLS5qzcKUeAbxCrpZ9ebCd
QZYFwtDqFrdp2e84fXCAx0MMG36NKkMkLn36xh+zHVcYe951Kkpq7UaLclnMK2pC
oyWkqxbwFv3RarvppLmWFWajm3ZYuV6HAjmnZ//YwlYCd9u9b3DxoKSdLYuYGGkP
MVX3l928DKa+J1QJTAL61aeRUwgNaITuRAUp2Ir72d2X3yTrrZUGCK+Tct9vhJrC
uDLdOcdZTHkBuQUvF1fNLe/l1l597TTbxqeZZe9030kcgFjf9yfAU3dZG4+aobpb
T74sbSN30GMnQcEfisO5O2sUkKLsOrZwNt6UdSLApuWIkYkd91wMlbqhvDTJI85j
nUKviK/nfOGE/PoMbQW+uQxcbDtk2cyLpUy/ArxpRss4XFiYKIhSIXRVoieq+n1q
9NtsQoQmgkrCOkuWiPivqnWlHldCFOzVNL34e8Fa9zh9Wgs1XDm3mhHwoKZfDYZc
00HypiFjRCXQ80jF2MNgznHBu0n4P6HPYKpGQvk3cUZUfPolg0KPPsdudFjaVHF6
Q8QeqRH4EXZO0kxrLez8hZbHdTAu0563NlJS+nGrT2zkmLqDwVpz7QhJOq3zcBZu
YnObT2BbtDGfdkZ6iUJHdGyD5wZ0rGHwmZ2UQDkK3rI80MF+guINmuFkO/MV5GxG
VcN9G2NX7Lg=
=6EDM
-----END PGP SIGNATURE-----

--6o78gXsyQHm68LY/--
