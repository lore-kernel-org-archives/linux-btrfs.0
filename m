Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45083 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdETAjv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 20:39:51 -0400
Date: Sat, 20 May 2017 00:37:47 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: 4.11.0: kernel BUG at fs/btrfs/ctree.h:1779!
Message-ID: <20170520003747.GO9701@carfax.org.uk>
References: <20170519041638.sf7sensley4lpxiz@merlins.org>
 <20170519190358.GC10137@lim.localdomain>
 <20170520001134.GW29894@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tpyx7gKuSYt+mjHM"
In-Reply-To: <20170520001134.GW29894@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tpyx7gKuSYt+mjHM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 19, 2017 at 05:11:34PM -0700, Marc MERLIN wrote:
> On Fri, May 19, 2017 at 12:03:58PM -0700, Liu Bo wrote:
> > Hi Marc,
> > 
> > On Thu, May 18, 2017 at 09:16:38PM -0700, Marc MERLIN wrote:
> > > Looks like all the unhelpful BUG() aren't gone yet :-/
> > > This one is really not helpful, I don't even know which one of my filesystems caused the crash :(
> > > 
> > > Why is this not remounting the filesystem read only?
> > > Really, from a user and admin perspective, this is really not helpful.
> > > 
> > > Could someone who know more than me do a pass and eradicate those? 
> > > Btrfs cannot be a production filesystem as long as those are still around IMO.
> > 
> > Looks like there's a security hole hidden in code, I don't think it's
> > a bug in code, it's more like caused by a corrupted metadata reading
> > from disk rather than a memory corruption.
> > 
> > A quick glance at the stack shows in extent-tree.c:lookup_inline_extent_backref()
> > 
> > type = btrfs_extent_inline_ref_type(leaf, iref);
> > then...
> > ptr += btrfs_extent_inline_ref_size(type);
> > 
> > I agree that a corrupted image should not corrupt the kernel, so we
> > can fix it by forcing it to readonly.
> 
> Thanks.
> Can I make another plea for just removing all those BUG/BUG_ON?
> They really have no place in production code, there is no excuse for a
> filesystem to bring down the entire and in the process not even tell you
> which of your filesystems had the issue to start with.
> 
> Could this be made part of a cleanup for this build to remove them all?

   The removal of these has been an ongoing process for at least the
last 5 years.

   I don't understand the specifics of the kernel code in question(*),
but compared to 5 years ago, btrfs has got rid of most of the
BUG_ONs(**) a few years ago. The remaining ones are probably
complicated to deal with in any way more elegant than just stopping.

   I recall seeing someone's stats on BUG_ON locations a couple of
years ago, and btrfs had managed to get the number of locations down
below XFS (but no other FS). It's a kind of success, at least...

   Hugo.

(*) I don't have the spare time to fully comprehend the process. Sorry.

(**) A good fraction went away in the first year after the decision to
get rid of them.

> Pretty please with cherry on top? :)
> 
> Marc

-- 
Hugo Mills             | IMPROVE YOUR ORGANISMS!!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                            Subject line of spam email

--tpyx7gKuSYt+mjHM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZH4/bAAoJEFheFHXiqx3kSckP/0RhwpLHzEbmnezcMcmWc2Lf
K0NZsQ8Kn4ImMQzTGCjH8sgh0JC3/eGTMWiR6OqpvTlkOZ+LnWPYz3xkKu5Sl6m2
9hxEo5XAYEV3ah9QHuoKPPwd7+RR4hu/b2oNPvFJuBI9wMBD4H0oXFe+NvFEeC+M
jF+Wfc8XPed/77l881R/lMM/D29tTPW+YbuaAkajaDEDbSU3oIWv+AGq7IQKKTX8
nNjXURXELCj+CcG4JKRzhLZTRHSJ+Xv61vyPV9EePrLFWSDsiYb15irHo/RVJAGZ
qUGQw27TqKBFhiLLSflQgkXw26XNBm5OjmvjAv6FYEP8oGiwVTuOtLOz4dVE3dfW
dA17qT5Bf6bKc+VkjJMxL2HtEMM345FgSji5V+KGCmO4j1AJoOp9TDzCYmEthofc
+XZhM/FDB844Q377M29VZD6H1eTPMTukyH6qAlF7WKttyq0by+k+GLckZJOst6LU
5Uh45Ub9ZPr4qjjSAFk1LuxlRwRITdLZWOKYPz/DWI/gTAjHZOMwN8dkkLIcEdam
sooMoZWsljZnirDeIai3RL2vCPjG0XIz7wkemHiym80VVLdQczWf8L865gsqgbjs
QuNjRyw/rWtcC9Fhig26N5VfrlIZrPQP1GcQsRJt7QJEZcZYHDkZ2/LnLJafxzPH
LzgYmETqABQb3EotzuOk
=G6K0
-----END PGP SIGNATURE-----

--tpyx7gKuSYt+mjHM--
