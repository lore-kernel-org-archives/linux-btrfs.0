Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:55070 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2E2NX7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 09:23:59 -0400
Date: Tue, 29 May 2012 14:23:55 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Will big metadata blocks fix # of hardlinks?
Message-ID: <20120529132355.GN31037@carfax.org.uk>
References: <20120526182211.GA16059@sli.dy.fi>
 <jq2hpf$c6r$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jdM5ZcN/ZcXXVwZs"
In-Reply-To: <jq2hpf$c6r$1@dough.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jdM5ZcN/ZcXXVwZs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 29, 2012 at 02:09:03PM +0100, Martin wrote:
> Thanks for noting this one. That is one very surprising and unexpected
> limit!... And a killer for some not completely rare applications...

   There have been substantially-complete patches posted to this list
which fix the problem (see "extended inode refs" patches by Mark
Fasheh in the archives). I don't think they're quite ready for
inclusion yet, but work is ongoing to fix the issue.

> On 26/05/12 19:22, Sami Liedes wrote:
> > Hi!
> > 
> > I see that Linux 3.4 supports bigger metadata blocks for btrfs.
> > 
> > Will using them allow a bigger number of hardlinks on a single file
> > (i.e. the bug that has bitten at least git users on Debian[1,2], and
> > BackupPC[3])? As far as I understand correctly, the problem has been
> > that the hard links are stored in the same metadata block with some
> > other metadata, so the size of the block is an inherent limitation?
> > 
> > If so, I think it would be worth for me to try Btrfs again :)
> > 
> > 	Sami
> > 
> > 
> > [1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/13603
> > [2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642603
> > [3] https://bugzilla.kernel.org/show_bug.cgi?id=15762
> 
> One example fail case is just 13 hard links. Even x4 that (16k blocks)
> only gives 52 links for that example fail case.
> 
> 
> The brief summary for those are:
> 
> * It's a rare corner case that needs a format change to fix, so "won't-fix";

   Definitely not "won't-fix" (see above).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---      

--jdM5ZcN/ZcXXVwZs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPxM3rIKyzvlFcI40RAowPAKDGdK+J3/PXvdpM0qBqa9RmGy/vBgCdHFj9
lsUyK+YITyTzSCtZ9DBSE8M=
=3mAJ
-----END PGP SIGNATURE-----

--jdM5ZcN/ZcXXVwZs--
