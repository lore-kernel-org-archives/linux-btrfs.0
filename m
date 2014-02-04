Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45354 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaBDQkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 11:40:25 -0500
Date: Tue, 4 Feb 2014 16:40:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs crash with a corrupted(?) filesystem
Message-ID: <20140204164003.GD6490@carfax.org.uk>
References: <20140204222310.65c4a468@natsu>
 <20140204163235.GC6490@carfax.org.uk>
 <20140204223506.569626c1@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Pql8miugIZX0722"
In-Reply-To: <20140204223506.569626c1@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--3Pql8miugIZX0722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 10:35:06PM +0600, Roman Mamedov wrote:
> On Tue, 4 Feb 2014 16:32:35 +0000
> Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Tue, Feb 04, 2014 at 10:23:10PM +0600, Roman Mamedov wrote:
> > > Hello,
> > > 
> > > My server had a period of instability (PSU-related issues), some lockups,
> > > some strange crashes, and some files became corrupted, and perhaps parts of
> > > a filesystem too. One BTRFS partition now fails with the following errors.
> > > 
> > > On an attempt to make a snapshot:
> > > 
> > > [   48.035664] btrfs: corrupt leaf, bad key order: block=193529446400,root=1, slot=9
> > [snip]
> > 
> >    Bad key order is pretty much always down to hardware corrupting
> > data at some point -- which would go well with your list of hardware
> > problems above.
> > 
> > > Currently I have it mounted read-only, and all data seems to be accessible.
> > > Short of copying everything away and recreating the FS, how can I bring it to
> > > a working order. Is btrfsck a good option here?
> > 
> >    The first investigation to do would be to look at the block in
> > question and see if it's got an obvious problem with it. If you post
> > the output of "btrfs-debug-tree -b 193529446400 /dev/whatever", we can
> > take a look at the indexing.
> 
> Thanks; here it is:
> 
> # btrfs-debug-tree -b 193529446400 /dev/md4 
> leaf 193529446400 items 81 free space 46 generation 565572 owner 7
> fs uuid dd12de99-bbe5-45cf-b869-6313c1f58431
> chunk uuid b61f845a-ada5-4bcf-b995-7c5e1affa63d
> 	item 0 key (EXTENT_CSUM EXTENT_CSUM 4278808576) itemoff 3955 itemsize 40
> 		extent csum item
> 	item 1 key (EXTENT_CSUM EXTENT_CSUM 4278853632) itemoff 3895 itemsize 60
> 		extent csum item
> 	item 2 key (EXTENT_CSUM EXTENT_CSUM 4278919168) itemoff 3883 itemsize 12
> 		extent csum item
> 	item 3 key (EXTENT_CSUM EXTENT_CSUM 4278931456) itemoff 3843 itemsize 40
> 		extent csum item
> 	item 4 key (EXTENT_CSUM EXTENT_CSUM 4278976512) itemoff 3819 itemsize 24
> 		extent csum item
> 	item 5 key (EXTENT_CSUM EXTENT_CSUM 4279001088) itemoff 3815 itemsize 4
> 		extent csum item
> 	item 6 key (EXTENT_CSUM EXTENT_CSUM 4279005184) itemoff 3787 itemsize 28
> 		extent csum item
> 	item 7 key (EXTENT_CSUM EXTENT_CSUM 4279033856) itemoff 3715 itemsize 72
> 		extent csum item
> 	item 8 key (EXTENT_CSUM EXTENT_CSUM 4279107584) itemoff 3619 itemsize 96
> 		extent csum item
> 	item 9 key (EXTENT_CSUM EXTENT_CSUM 72998785024) itemoff 3599 itemsize 20
> 		extent csum item

   ^^^ Here it is.

The previous key (item 8):
>>> hex(4279107584)
'0xff0e0000L'

This key (item 9):
>>> hex(72998785024)
'0x10ff111000L'

   So it looks likely that you've got a single bit flip in the key.
Josef had a patch for fsck some time before Christmas that would deal
with (some of) these cases, but I'm not sure if this is one of them.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
            --- You're never alone with a rubber duck... ---             

--3Pql8miugIZX0722
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvEX41heFHXiqx3kAQLwfg/+KQTQfsnmfLHsYA0rU7pd3DsMnXESPUiy
Yuqql0jnUAgycs5UqVHBclNb4TOr+oh8mSgTNCk8MTYrD+We/gHl9aVHEAqvqFdL
RQQE30a0DwylN2N4GcXcn6xywjYmpzrGfGvFO7WGPGh2MVQMfoVe0Ya8JWutDhJW
OKpV5wiT+ztvEpzSln5xIcPNlbeCBqrDxLq6nwvBBZ+PjuIB8rUYgCJX2NXMt8z2
8fs1vzZysInoLWZIJ2/O2wEKeR7+iFxGMi2zBkGQHyB9Edf5ZXbthPD2XP64L8qv
QXQ52qhK0Q9qYUMOxhgcnz4kKZO5vzM8KNw1aeDOapsGx4QAI7Day5RzKrIAg2tr
ezNPmbkhvw0vMGjdN/l3LiX+sHjaYG/4IWxMr6wqDfCqdcFoZ1hca9+pvgD0JuAp
AFZw4h/gSuvdFxfImm3ucWwKauuGSnNrWtLJXRDYN0kq0BDj1unRfcAS9+piRkXO
9Uh0rn6LPd2b8zJfSAKMLfXRKyGdVlaRjzVqvdwcgR4GOly+MYc3rUShuSMuHexe
F153LOpXfvzQWHIgkKrHlWVnXvvoQokj8qc/VULsGStbdbP9pdt5+toi40mXfJgc
7/mC7Vp3NOoF3eBTjYyEZ2WAwqxxD4+xumpfLlCJA4yQBc5K8k+HbHu7MtlUyBh9
Kh2TRBO2sRQ=
=gndW
-----END PGP SIGNATURE-----

--3Pql8miugIZX0722--
