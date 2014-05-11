Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46847 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEKJKq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 05:10:46 -0400
Date: Sun, 11 May 2014 10:10:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: known UUID and metadata consistency
Message-ID: <20140511091041.GA23212@carfax.org.uk>
References: <201405111416.28012.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
In-Reply-To: <201405111416.28012.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 11, 2014 at 02:16:27PM +1000, Russell Coker wrote:
> One of the problems with ReiserFS was that a fsck --rebuild-tree would look 
> through all the disk contents for blocks that appeared to be metadata. A 
> hostile user could create a file in their home directory (or /tmp or anywhere 
> else) that contained ReiserFS metadata which would be linked into the 
> filesystem on a --rebuild-tree, by doing that I created a SUID root file as 
> non-root on a ReiserFS system. Also ReiserFS was inherently unsuitable for 
> storing filesystem images as that could mess up the filesystem.
> 
> I believe that BTRFS uses a UUID for each filesystem that is included in every 
> metadata block which will make it very unlikely that two runs of mkfs.btrfs 
> will result in the same UUID.  Therefore there should be no risk of a 
> filesystem image stored in a file messing up a filesystem.
> 
> Is it possible for a hostile user to create a file that could get linked in to 
> a filesystem by btrfsck?  /dev/disk/by-uuid/ is world readable so the UUID of 
> the filesystem is not secret.  Apart from the fact that a correct tree (which 
> can be verified by checksums) won't link to data blocks as metadata what 
> assurance do we have that hostile or corrupt data blocks can't be treated as 
> metadata?

   "Possible, but very difficult to accomplish in an undetectable
way."

   I think there's two cases here:

a) The chunk tree is whole and consistent
b) We need to (or have been asked to) rebuild the chunk tree from scratch

   In the first case, btrfsck has all the pointers to the chunk tree
block(s) from the superblock, and therefore knows which areas of the
disk(s) are meant to be metadata and which are meant to be data. In
order for a data block to end up being considered by btrfsck, it would
have to be turned into metadata. This is difficult, but not impossible
-- it can happen if it's written as data, the FS is balanced so the
data chunk is moved elsewhere, a metadata chunk is written in place,
and none of the metadata blocks moved into that chunk overwrites the
evil block. _Then_ btrfsck would have to be scanning metadata for tree
blocks, which it generally doesn't do, I think.

   In order for this to be dangerous, we would then need to have
something pointing at this evil block (which in a good filesystem it
wouldn't), or to have some detailed scan pick it up and attempt to
incorporate it. This means that it's going to have to have things like
the correct (or nearly-correct) transid, and it's got to have good
pointers to other metadata blocks -- a task complicated by the fact
that in order to get to this point, we've just balanced the FS which
has moved *everything* around to new addresses.

   In the second case, it's a much simpler case for an attacker -- you
could potentially construct a whole new chunk tree (typically only a
few blocks in size) with a higher transid than the original FS. If the
chunk tree is sufficiently badly-broken that it can't be read, then a
full disk scan (e.g. btrfs-find-root) would turn up the fake as well,
I think. You'd probably have to construct a whole new load of metadata
as well (at least some of the other trees), and ensure that it all
linked together with the right addresses.

   So I think, yes, you can make fake metadata blocks, but you have to
rely on either (a) your fake data being written to exactly the right
place and not overwritten by a balance, or (b) having the chunk tree
broken and the admin looking for a usable set of metadata with
btrfs-find-root and choosing your fake (with enough plausible complex
data in it to fool them).

   I've probably missed loads of points here, but I think this is a
good start for the conversation. :)

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Anyone who claims their cryptographic protocol is secure is ---   
         either a genius or a fool.  Given the genius/fool ratio         
                 for our species,  the odds aren't good.                 

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU28+kFheFHXiqx3kAQIZ8BAAsqzvLPZZshCKzwPjpQiWyjion2nBks8w
TonDIvdmOISYQ9Opi9yUXWElGu+vdtZgPSh7PgoPSdx0JujyHCVSMVcEilw7vJeP
swDR92Zn6W+MRmTncGJj4J4Y0pvNxULWMdAiHkd+HodRw0Z5TUq1yWShwCyCD1zf
pemuzJ0KcygByyWtp6pGSdJ7ulVB4KT+TLhqVHOTr8qB9qMLXpgLLMNv+TCuS4u1
9FGVlWpTfO+dpioLmm5dxMKFXqrX+m6QfaSMYJhAnoOI7nHOgUk7jV2DkyWa+dBH
QLwLVb6bml+Dr/6NwenmchCIJjyJt8y9wFErXq/7ktDH+Cr7lzWVr6S/aRgiPrxb
bZM/nyPwM8iMwJKjtN9iq3Z/CsvzGE4BHY5zUf4Xr/WDf+of0uVdLLQnU48MK/SC
9XWLNCUbn5rmMlxxQ2IG+WSXH28wYQ6wlJrDdg4IwmWuvlJ29wnvUvDm2itt+opH
Q66TruRfWNlppa3imyi3Tebb/epXoNNS4YJTrk1Ho92IkDCDXNcBKqHrjnuBn85R
sAHTBYCCZRNgBbz9OJMhX3W0zOITPbL8gux11XcYo7aGB0wXQGjBTdvB2mOuCOQ2
wsETbOw1ZhEX2dyFBl/HKFYYEgfVECsSSNBqe6BMWp23GpXKsqr5OnDGAZen5dI1
4VUHXlHXZIE=
=Pf14
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
