Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:42007 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaEJBFg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 May 2014 21:05:36 -0400
Date: Sat, 10 May 2014 02:05:18 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>, Chris Samuel <chris@csamuel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, bo.li.liu@oracle.com,
        jbacik@fb.com, dsterba@suse.cz, clm@fb.com
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
Message-ID: <20140510010518.GP16185@carfax.org.uk>
References: <2678329.EOSaIZaHNO@quad>
 <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
 <20140510004254.GB9276@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tZCmRiovzb4sxAVa"
In-Reply-To: <20140510004254.GB9276@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tZCmRiovzb4sxAVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 09, 2014 at 05:42:54PM -0700, Marc MERLIN wrote:
> On Sat, May 10, 2014 at 10:13:43AM +1000, Chris Samuel wrote:
> > > Right now, I do see:
> > > legolas:~# cat /proc/sys/kernel/tainted
> > > 512
> > 
> > IIUC that's an array of bit flags, and that value means you've had a previous 
> > kernel warning at that point according to:
> > 
> > https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
> 
> Yep, I meant to say that I don't have the 'G' now.

   G is actually good, I think. IIRC, it's "everything we've had to
this point has been under a license where we have the source
available". It's when you load a proprietary module that you get the P
and the G goes away.

> It's likely that vbox did 'G' even if I didn't successfully start it,
> and even if I haven't had problems with it 'till now, it's a possible
> culprit (more details below)

   I think G is actually a default state, and is "good".

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I write in C because using pointer arithmetic lets people ---    
               know that you're virile. -- Matthew Garrett               

--tZCmRiovzb4sxAVa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU217TlheFHXiqx3kAQJ8MxAAs+PBf2ENtg6MwNvDbOtgx1mVnyc3CY7j
FwHaSePRnxtMFaR4rqxyNi/Y9yy4P745bDI2V8xKppyuuZdXFDQNinB8slWjR8qa
JbeLd0IJREaTgOLYYeWzwBw6/4mEL+ZLuA9nE1sozZlRWpqZBeyWf/WLm15aHdwk
+J6/7P2N5QpkzdwBqijpiKz219vhlZ8KfnKG+Om5+NXkQ6uLnT0YQ4kR6ga6K2eE
V0YD7oA6JEE1C+2zyaMbHhGFvEmqwZORfHBfu2k1mequnUNsvBfBWb/TrwT37BCc
0D48m5GoE2Vr2ufPXH7WCiXGFwVGXVsqXHj5YoWiBrokCU2gwXn8oEZ/9tN3rrIC
Vwr4PK0P7nQ2llwUtZ5arubaNs3ySOWMXk8di/+qNudg7kSd8ZuogbMLs84t+pei
wvfxbqvugOPtMiATZXEAScra69HPgJFDgslvEqz6Oz+m1XG0XVJO/i1njwiyjGl4
ATvb90ho+x3/a8XtGqGjysOeU61TuVRZ0+NeAJN6b2Iq8oWrqCpKbxmcGy8Kt5Dy
bBqeSI+tzw0wpGhBjSRILgHx4mXNRaO0Bmptkvltnr8iEnyA8Gi7NplHJSk+heHq
PyiQeMcUqbsnjQ9src2TGqAg3jWNxOart6jeuzGcY5PMkKAXKSycaoEscdqjc2KQ
8x82gj1UCJg=
=7jI8
-----END PGP SIGNATURE-----

--tZCmRiovzb4sxAVa--
