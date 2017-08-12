Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49632 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751624AbdHLMNG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 08:13:06 -0400
Date: Sat, 12 Aug 2017 12:12:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <20170812121257.GZ7140@carfax.org.uk>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org>
 <1502538706.3996.1.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BxgRixwWt/z/BIGD"
In-Reply-To: <1502538706.3996.1.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BxgRixwWt/z/BIGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 12, 2017 at 01:51:46PM +0200, Christoph Anton Mitterer wrote:
> On Sat, 2017-08-12 at 00:42 -0700, Christoph Hellwig wrote:
> > And how are you going to write your data and checksum atomically when
> > doing in-place updates?
> 
> Maybe I misunderstand something, but what's the big deal with not doing
> it atomically (I assume you mean in terms of actually writing to the
> pyhsical medium)? Isn't that anyway already a problem in case of a
> crash?

   With normal CoW operations, the atomicity is achieved by
constructing a completely new metadata tree containing both changes
(references to the data, and the csum metadata), and then atomically
changing the superblock to point to the new tree, so it really is
atomic.

   With nodatacow, that approach doesn't work, because the new data
replaces the old on the physical medium, so you'd have to make the
data write atomic with the superblock write -- which can't be done,
because it's (at least) two distinct writes.

> And isn't that the case also with all forms of e.g. software RAID (when
> not having a journal)?
> 
> And as I've said, what's the worst thing that can happen? Either the
> data would not have been completely written - with or without
> checksumming. Then what's the difference to try the checksumming (and
> do it successfully in all non crash cases)?
> My understanding was (but that may be wrong of course, I'm not a
> filesystem expert at all), that worst that can happen is that data an
> csum aren't *both* fully written (in all possible combinations), so
> we'd have four cases in total:
> 
> data=good csum=good => fine
> data=bad  csum=bad  => doesn't matter whether csum or not and whether atomic or not
> data=bad  csum=good => the csum will tell us, that the data is bad
> data=
> good csum=bad  => the only real problem, data would be actually
>         
>               good, but csum is not

   I don't think this is a particularly good description of the
problem. I'd say it's more like this:

   If you write data and metadata separately (which you have to do in
the nodatacow case), and the system halts between the two writes, then
you either have the new data with the old csum, or the old csum with
the new data. Both data and csum are "good", but good from different
states of the FS. In both cases (data first or metadata first), the
csum doesn't match the data, and so you now have an I/O error reported
when trying to read that data.

   You can't easily fix this, because when the data and csum don't
match, you need to know the _reason_ they don't match -- is it because
the machine was interrupted during write (in which case you can fix
it), or is it because the hard disk has had someone write data to it
directly, and the data is now toast (in which case you shouldn't fix
the I/O error)?

   Basically, nodatacow bypasses the very mechanisms that are meant to
provide consistency in the filesystem.

   Hugo.

-- 
Hugo Mills             | vi vi vi: the Editor of the Beast.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--BxgRixwWt/z/BIGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZjvDJAAoJEFheFHXiqx3kOb8P/2QTplPIKUL+uuvLRzt/RxO/
KRwP2AIXQ+ljJ8ReSIi8GB1iu+DU2RtMkJExJAPG0OGEP3YgWImbevLSLnzTzMEk
qORDYvGhMIr3qnwkcpqok9dOj2T5ChjkCiIGGjk54MsRp3ZyKMZA2jLBiegqPgUi
YdI4obZ4SfAx44q1+c/aId6ZhTrsdlfwKJ/JZeajDFjSxaPro6RUopa/iWhWTDFQ
vNwgFI2/xFvBnYFGaplPS7sCun6cT3S+IvyKTgGy8anURnbXYvy7XkVphuLrt0fL
WOKgvG4AE19wBuaAmDIQtbymJ9AbdQPSDfaviexKeShpGlZC31DaSoC/51nPHIXd
doRfBEIHL1UuHpUB5ioGORDncHdRWu+zqe/G2eeFSwEO5NXbUYj6WWJeISioiJZP
MCsWvpubSQdXN5LZbXR4SurJ1D7JxnrMAqk+4NifYhlmaZF2K5FNChjGsglNWy3a
4ZxGEiodUjd/IKS5OL/m9kdLbPi6J62HmQ08qvU+PbrynMoJmwz14F+I8GcHhquH
jNDa33LGAxprnKE4MzIRRYqgWCCYx/JdYGR4Uq56OLIaUJU0Ey0BfBydfHsqrgPh
4GWcaL2yZ1nOCsmjJk18ziT9rGgrztQUrFIJ38syixi5q2BgQvKP95LOL8MZ9nkL
BpG7tr3gfmzwBZ19haIc
=QFih
-----END PGP SIGNATURE-----

--BxgRixwWt/z/BIGD--
