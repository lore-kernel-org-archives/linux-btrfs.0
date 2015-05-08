Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36619 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbEHWhZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 18:37:25 -0400
Date: Fri, 8 May 2015 22:37:23 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Anthony Plack <anthony@plack.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel Dump scanning directory
Message-ID: <20150508223723.GO18480@carfax.org.uk>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
 <4B045A3B-60E2-4151-86E7-029E79585886@plack.net>
 <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
 <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net>
 <20150508211850.GN18480@carfax.org.uk>
 <A54EAF29-BF4C-4CCA-BFBF-FEDFF2A01C73@plack.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZQ/M1iA+qg8otEW"
In-Reply-To: <A54EAF29-BF4C-4CCA-BFBF-FEDFF2A01C73@plack.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4ZQ/M1iA+qg8otEW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 08, 2015 at 04:49:19PM -0500, Anthony Plack wrote:
> 
> > On May 8, 2015, at 4:18 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > 
> > On Fri, May 08, 2015 at 11:44:39AM -0500, Anthony Plack wrote:
> >> Once again btrfsck --repair /dev/sdm ended with
> >> 
> >> parent transid verify failed on 94238015488 wanted 150690 found 150691
> >> Ignoring transid failure
> >> 
> >> no attempt to actually repair the volume.  No indication from the tools why.
> > 
> >   A transid failure means that the superblock has been written out to
> > disk *before* a part of the metadata that forms that transaction, and
> > then the machine has crashed in some way that prevented the
> > late-arriving metadata from hitting the disk. There are two ways that
> > this can happen: it's a bug in the kernel, or the hardware lies about
> > having written data. Both are possible, but the former is more likely.
> 
> Also good to know.  I agree to the bug in the kernel.  I think you just hit on the issue here.  Since this COW, we should be able to assume that the superblock is then still "empty."  Or do I misunderstand?

   No, if the superblock didn't have anything in it, the FS wouldn't
be mountable.

   The CoW design works by making all writes to currently-unused
locations. At some point (a transaction boundary, every 30 seconds by
default), the FS ensures that everything written to date is consistent
-- that everything has been flushed to permanent storage -- and only
when all of that data has hit the disk does it write out the updated
superblock(s) that point to the new data structures. Since superblock
writes are atomic, the FS remains consistent at all times: either the
superblock refers to the old data or the new data, but cannot refer to
any partial state in between.

   It doesn't matter what order the data is written out in, *provided*
that there's a guarantee that it's *all* written out before the
superblock is sent.

   Now, where things go wrong, and results in a transid failure, is
where the metadata structures are written or modified *after* the
superblock is written, and then the machine crashes partway through
the sequence of writes. The intended design of the FS is such that
this should never happen -- however, there's a class of bug that means
it *can* happen, which is probably what's gone on here. I don't know
enough about the block layer to be able to characterise in more detail
what the problem looks like.

> >   Once this failure has happened, the FS is corrupt in a way that's
> > hard to repair reliably. I did raise this question with Chris a while
> > ago, and my understanding from the conversation was that he didn't
> > think that it was possible to fix transid failures in btrfsck.
> 
> I guess I don't understand how that could be designed that way.
> 
> >   Once again: zeroing the log won't help. It doesn't fix everything.
> > In fact, it rarely fixes anything.
> 
> >   The reason there's no documentation on fixing transid failures is
> > because there's no good fix for them.
> 
> Then what is the point of the transactions?  Why do we care about
> transid mismatch?  Why keep something, that if it fails, breaks the
> whole thing?

   A transaction is simply what you get when you write out a new
superblock. It's an atomic change to the FS state. In an ideal world,
the transactions would be fine-grained, and would match the POSIX
filesystem semantics. In practice, the overhead of CoWing all the
metadata for a change at that scale is (relatively) huge. As a result,
the FS collects together larger chunks of writes into a single
transaction.

   Now, there's a further difficulty, which is that if you make
transactions long-lived, you have two choices about the FS behaviour
towards applications: either you wait until the end of the
transaction, and then report success to the writer, in which case
performance is appalling; or you can report to the application that
the write succeeded as soon as you've accepted it.

   Btrfs uses the latter method for performance reasons. But... if you
do that and the machine crashes before the end of the transaction, the
FS state is still the old one, so the app thinks it's written data
successfully to disk, but there's no record of it in the FS. The log
tree fixes _this_ problem by keeping a minimal record of the writes
made so far in the current transaction, so that when the FS resumes
after a crash or power loss, the log can be examined and used to find
the outstanding writes that have been confirmed to userspace. From
that, the partial transaction can be completed.

   In the past, there have been a few bugs where the log tree has been
written out with bad data in it, and this has led to non-mountable
filesystems (because it tries replaying the log tree and crashes).
This is the *only* case where btrfs-zero-log helps.

   I hope all that helps explain what all the moving parts and for,
and why they're there.

   Hugo.

-- 
Hugo Mills             | To an Englishman, 100 miles is a long way; to an
hugo@... carfax.org.uk | American, 100 years is a long time.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        Earle Hitchner

--4ZQ/M1iA+qg8otEW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVTTqiAAoJEFheFHXiqx3k8awP/RjSZeUce4t82W1HAa2JBRUR
oTkB/IJ619bwQscpPp0t7N9OXLp7z4/gRUWGGHD8SgwFBiMvs9B4o6mI++HNztNN
dmCtZ025qJM/F76KrF2PRMwSdc+YfHXSRHK3P6CbuzoTYh5uHGenYdzjlHS71+Y5
H+x8kkUqPIEqnXuDdMJd/2gF9DGinwR0dIcyCZn01jdB2PCDaR6OENLKws+WP7Dg
tIvQVQ/NCX43z16VZERGliO9tBi//u/QVr3T59ZgW6imk6LIXDLmYluxLy1Mwx0i
WHHXwt4kKOtRT68+YMUEif2/dRu/UeDJbkLJ6eeggZ8ELUki+sTkTGmtJ1Nw3hoo
lPKHrPTyDwXKs0paGlmx72q7pGbeZPQFi2+5oZEwiGxtz3cYYsc5Lg9G5PoukU76
dVdh9DVqpo4Ucyst4OU2tm4DEUJMUIq8cBMUTycq2D/qmTddqlZiR7WvFNmCRfgC
4TFR4nL2zIEa6Y5NkmkIj9zhf3eCD67O12vY5bQtEpWeqk0IHA0XWpQfIm0Ro11v
IdaweO2xx9qSVImTzMlNhZkX3kxaaeNxY2T3fHoPuSMdU5x2lHNVb7HkzmgSSerh
S/RlOFoIaWMypgNPPQxmIJj0Uk0SYzHtBwGR5FPrlxGK1xFj8d7ajJDH5pgucX5r
gOs5VoK1RzF2oDEsF8Hf
=FUSJ
-----END PGP SIGNATURE-----

--4ZQ/M1iA+qg8otEW--
