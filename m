Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46909 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaJVTyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 15:54:09 -0400
Date: Wed, 22 Oct 2014 19:54:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Uh, 1COW?... what happens when someone does this...
Message-ID: <20141022195406.GB18164@carfax.org.uk>
References: <54480856.9020604@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
In-Reply-To: <54480856.9020604@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2014 at 12:41:10PM -0700, Robert White wrote:
> So I've been considering some NOCOW files (for VM disk images), but
> some questions arose. IS there a "1COW" (copy on write only once)
> flag or are the following operations dangerous or undefined?
> 
> (1) The page https://btrfs.wiki.kernel.org/index.php/FAQ (section
> "Can copy-on-write be turned off for data blocks?") says "COW may
> still happen if a snapshot is taken." Is that a "may" or a "will",
> e.g. if I take a snapshot and then start the VM will the file in the
> snapshot still be frozen or will it update as I alter the VM? Does
> the read-only-or-not status of the snapshot matter in this outcome?
> 
> e.g. what does "may" mean in that section?

   If you take a snapshot of something, then any write to that (the
original or the copy) will cause it to be CoWed once. Subsequent
writes to the same area of the same file will go back to nodatacow.

> (2) If you copy a file using "cp --reflink" and the destination is
> in a directory marked NOCOW, what happens? How about when the
> resultant file is modified in place?

   Same thing as above.

> (3) when using a watever.qcow2 virtual machine image that does
> copy-on-write in the VM (such as QEMU) is it better, worse, or a
> no-op to have the NOCOW flag set on the file? All the advice on this
> matter I can find in Google seems to be "VM images bad, but will be
> addressed soon" and its old enough that I don't know if "soon" has
> come to pass.
> 
> It seems like there is a 1COW flag implicit somewhere.

   I wouldn't put it in those words, but yes, a single CoW operation
occurs on writes to data with nodatacow set.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- "There's a Martian war machine outside -- they want to talk ---   
                to you about a cure for the common cold."                

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUSAteAAoJEFheFHXiqx3kDiEP/3kqVIrJdWt9OlO1ymxd+Occ
IqVa2H2Om+jCs56OlLV/YkKRSXjBPnvL7U50lyRG183ZwkjJ7CySvWaJMjmdtr7B
ABLr2CiglNIXM8bviYPxyVhYet5VwYcLk0KDAD+oba4gxPRNcN8340nq3BKnOu7z
ZqCQ1LUuURHucyhbLxvXawKSpcP7G4vbtR/KJZEO4nFkhkAF6Qtp7cMG5yWhk1zM
rUWTmChtbswvChOnH6hzIs4YRliXGTfYt0LJE5/fR8ruR0WE6ElItvujOJNdJ7rF
hVGrvu8+yva90cuhIasXr0UXSrg8V+r1Wc3atmLBCTNPlSYzJUtSvBOVrrsqJh9Z
Zv/iiIcPbPDIKTWIu5UV2d48PA/P8adD2Q3esdD84Z5wN0blStERYqOT9ust///n
dESX/LCDnzthNTehv+/VCd/RzNsqDe9pq0CuvJXnjiTXIeffnRbeklHx+ul738ND
HNPkJeGirXoDprvXPQ4YOgP6oqBH9BoJkKeM51Ls1C4ktvZvl+P8uPTcDtZg2TEj
84RcmaDHun3P88aPqrVDZE0jzUqtgmGrCFT1tC4QZfsl5jIUnMlp9c2hGDZmseiO
k0nwR/diqjmHZ1a+j0YkWtUpdY5BvmP616uzxIU0dxIY6ZIPBFB6vd04XehEkK8K
UW4Vf2PhIm4Y/ZqjBkE2
=B/VU
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
