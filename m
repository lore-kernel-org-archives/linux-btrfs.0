Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54475 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3BPRpu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 12:45:50 -0500
Date: Sat, 16 Feb 2013 17:45:44 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Hemanth Kumar <hemanthkumar51@gmail.com>, linux-btrfs@vger.kernel.org,
        skjmca51@gmail.com, ganeshkumar14@gmail.com, kirantpatil@gmail.com,
        praneethu.u@gmail.com, chethan.casey@gmail.com, sensille@gmx.net,
        bo.li.liu@oracle.com, sandeen@redhat.com
Subject: Re: [btrfs-progs] testing btrfs hierarchical quotas
Message-ID: <20130216174544.GJ28997@carfax.org.uk>
References: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
 <20130215205906.GI28997@carfax.org.uk>
 <20130216075509.GW26694@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
In-Reply-To: <20130216075509.GW26694@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2013 at 06:55:09PM +1100, Dave Chinner wrote:
> On Fri, Feb 15, 2013 at 08:59:06PM +0000, Hugo Mills wrote:
> >    Hi, Hemanth,
> > 
> >    Here's a question -- what are you testing? (Not just here, but in
> > general, with your test infrastructure)
> > 
> >    There are (at least) three classes of tests you could be doing:
> > 
> > 1) Unit tests, which test individual functions within the code and
> >    ensure they do what they're meant to do.
> > 
> > 2) Integration tests, which test the full end-to-end system.
> > 
> > 3) Partial integration tests, which exercise the kernel
> >    filesystem code.
> > 
> > 4) Partial integration tests, which exercise the userspace tools code.
> > 
> > 
> >    Now, clearly you're not doing (1) here. It's going to be hard to
> > separate (2) from (3) and (4), but it's possible to write your tests
> > to do more of one or of the other. (*)
> > 
> >    xfstests clearly is much more geared to (3), and stresses the
> > kernel filesystem implementation rather than the userspace tools. If
> 
> Definitely not. There are lots of userspace tools tests in xfstests
> for stuff like mkfs.xfs, xfs_repair, xfs_dump/restore,
> xfs_quota, xfs_metadump/restore, xfs_copy, etc.

   OK, this is my mistake. I guess I've basically seen so many
kernel-side things fail from xfstests, I'd assumed that was
exclusively what it was testing. Thanks for the correction.

> > you want to test the implementation of qgroups, it belongs in
> > xfstests. If you want to test the userspace code, you need to make
> > sure that (over all your tests) you cover every command-line option,
> > and every different way of using the tool, and ensure that it does the
> > right things.
> 
> Yup, that's why there are are so many xfs specific tests. :) e.g.
> there are 31 tests that use xfsdump/restore in lots of different
> ways, including exercising dumping to tape devices if you have the
> hardware...

[snip]

> Seriously, guys, just write new tests for xfstests. Everything you
> need to run btrfs-progs tests is already there. Don't try to
> re-invent the wheel simply because you don't understand how the
> current wheels we have are made....

   As long as xfstests already has tests for userspace tools in it,
then I'm quite happy to see it all go there.

   My point about being clear exactly which bit of the end-to-end
system the test is there to exercise still stands, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- He's playing Schubert.  I think Schubert is losing. ---       

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUR/FyL9z9OVl50rAAQKJXg//S7hHFgtSPM9l1R2sc/7xQxFqADGhLw6M
+4OqADPx/O8atTkg73GRVNwEjQdZwZ+JH19jJOjRaZcwVnglJZ+JRC+PVcyWxbug
5bvMhC8YDce05a1SCDt4V7K+S1DRWO6dL1RBDV+NdEHtnNfIc8gNSGW4kRLJ2zJc
SFBSxmv+GI3V/ShrZT++x9iHCwj0jBWlXBdxFlhjzc+sT1KPUwNpjgeUStsu9bfv
Caqyqpac9wdiiiwWfgXuevIZmUFolWOjtewx1npbTc6jMRTLyQ8LWP3VkK19srkY
lkCVD4xSCI1gbY8wQXI5nflymgc2mY6DMzAqkTPERsDS9o/bVnF64Njkrm6Ar7c1
DRp/2JjzDwalCefqdXJKgD6RyBzJxvhrrbtIMt3F24UgxWGrFOpa4rV6Xl7CIs1D
VAY+PCXOhyy9k1EU3AAOssItnfCtUCLHJIe9XQct3re/IUvQbW1GJUIaewqInatL
9rJ5FiTP/yO/aKeop1cxFsDiEx3uZTz8TeRYjqmy3naCqAp73iLCFqkR7bSfD15b
eQhmtq+R2HsZGx+wDKwsU6aO2fOfbpqyaNpzHtJVx6c8uuGyEC+617idT1DCSb3p
Wjj8kPtrUDuwech0phjU28qIbHnMNxto7Nq6v0dB37V8h78nhEenyo8xh2Uy0lMg
F0SJKGU5/qw=
=PhLu
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--
