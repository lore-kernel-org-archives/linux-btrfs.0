Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57219 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaEGOXY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 10:23:24 -0400
Date: Wed, 7 May 2014 15:23:01 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Brendan Hide <brendan@swiftspirit.co.za>,
        Marc MERLIN <marc@merlins.org>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>, linux-btrfs@vger.kernel.org
Subject: Smallest-n balance filter (was Re: Please review and comment,
 dealing with btrfs full issues)
Message-ID: <20140507142300.GB19199@carfax.org.uk>
References: <20140506121937.GD10159@merlins.org>
 <53690E27.6090101@swiftspirit.co.za>
 <20140506164324.GC24298@carfax.org.uk>
 <20140507140927.GW5988@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
In-Reply-To: <20140507140927.GW5988@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 04:09:27PM +0200, David Sterba wrote:
> On Tue, May 06, 2014 at 05:43:24PM +0100, Hugo Mills wrote:
> > > >So in my case when I hit that case, I had to use dusage=0 to recover.
> > > >Anything above that just didn't work.
> > > 
> > > I suspect when using more than zero the first chunk it wanted to balance
> > > wasn't empty - and it had nowhere to put it. Then when you did dusage=0, it
> > > didn't need a destination for the data. That is actually an interesting
> > > workaround for that case.
> > 
> >    I've actually looked into implementing a "smallest=n" filter that
> > would taken only the n least-full chunks (by fraction) and balance
> > those. However, it's not entirely trivial to do efficiently with the
> > current filtering code.
> 
> I've prototyped something similar, to limit the number of balanced
> chunks by a number. To achieve "n least-full chunks" would be an
> iterative process of increasing the usage filter and limiting the number
> of chunks until the desired N is reached.
> 
> N=n
> F=0
> while (N > 0) {
> 	balance -dusage=F,limit=N
> 	N -= <number of balanced chunks>
> 	F++
> }
> 
> The patch is in branch dev/balance-limit in my git repos.
> 
> We can then implement the n-least-full as a synthetic filter from
> userspace.

   This is inefficient, because we've got an O(m) pass through all the
chunks for every call. If we reduce the number of calls by increasing
the increment of F (F+=3, say), then we risk overbalancing, or missing
out on smaller chunks we could have balanced earlier. From a practical
point of view, it may make little difference, but the computer
scientist in me is going "ewwwww".

   The other method, for small n only, would be to construct the list
first, an O(m log n) operation for a filesystem of size m, requiring
O(n) storage, and then iterate over just those chunks. The problem
with that is the storage requirements, and keeping track of the state
of the list for restart purposes. [actually, there's probably an O(m)
algorithm to get the n smallest items, but those are a bit
complicated]

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- A diverse working environment:  Di longer you vork here, di ---   
                             verse it gets.                              

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2pBxFheFHXiqx3kAQJV1A/+JF2cnRFkYB7HsF20PVnzQWcn/mv8cSHR
WPF9y4reXOw3idrKVb3wbzTGaS4dHYumeuPOUgwOMX1u08Tx+TonbioaMPx9Mq+K
0Kqnud3CRAJv4ktsBWroQu/gypx2AhP2J8WlKp539juJB0T49qrjf4UZYFVz6pG+
r53+b7/vOIKTC3eFO5lK9Ccq39vZKG9tBkGtlFxklKUWioUW+DpuTzkVO4WSM215
yHU15qEfAU9wne7JxVYt/TWKD+/4yP+I5Dt2U+pheL3EDogGCIXv+IoymDEqlcw5
oKQEbi5v5rG3kITjB7JYUMDJi/HkiyhmwmRLb7tcJNliZSNoiz8VXhFQNGAk0nMH
41Bu3FvoqHwJqFWrVnnm93qL9na052x/XaqPC7TX7JX9rCV/0TmL9nCwCHpB4eni
OWVBcigXGMvas1djXQk7ps+ylBHL/aqobx/cIKZnuSC0RoBoZTc8yN9X60Ocp5JV
7DIyX5TUFS8kdc/Nv9VZaWn7z2MDcShDFAYaWjQOLwFFgXJ7djHMcNpgLyDmORfD
oc+aEiqxb6hnVjoUE3752cmYDrltVL3o3CYQHKu6ZWFTSzDEapLTAdiqx40v1OzN
3Jt5BSsQUdNprCDq0Zfyh77AZENi1UAkRm5sTOW/r1K3vcnTY3JhiNoCbXPc/eev
hH4HzIkL0rc=
=5v1D
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
