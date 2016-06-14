Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44123 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbcFNSQL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 14:16:11 -0400
Date: Tue, 14 Jun 2016 18:16:07 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Ashish Samant <ashish.samant@oracle.com>, linux-btrfs@vger.kernel.org,
        bo.li.liu@oracle.com
Subject: Re: [PATCH] Btrfs-progs: add check-only option for balance
Message-ID: <20160614181607.GM5437@carfax.org.uk>
References: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
 <575B2760.30109@mendix.com>
 <cbd07ef0-83ba-e8af-fe6c-2ed5689965c2@inwind.it>
 <575DAFAE.10906@mendix.com>
 <580d1242-6698-a977-9008-6ac743f205e4@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
In-Reply-To: <580d1242-6698-a977-9008-6ac743f205e4@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 14, 2016 at 08:11:59PM +0200, Goffredo Baroncelli wrote:
> On 2016-06-12 20:53, Hans van Kranenburg wrote:
> > Hi!
> > 
> > On 06/12/2016 08:41 PM, Goffredo Baroncelli wrote:
> >> Hi All,
> >> 
> >> On 2016-06-10 22:47, Hans van Kranenburg wrote:
> >>>> +        if (sk->min_objectid < sk->max_objectid) + 
> >>>> sk->min_objectid += 1;
> >>> 
> >>> ...and now it's (289406977 168 19193856), which means you're 
> >>> continuing your search *after* the block group item!
> >>> 
> >>> (289406976 168 19193856) is actually (289406976 << 72) + (168 << 
> >>> 64) + 19193856, which is 1366685806470112827871857008640
> >>> 
> >>> The search is continued at 1366685811192479310741502222336,
> >>> which skips 4722366482869645213696 possible places where an
> >>> object could live in the tree.
> >> 
> >> I am not sure to follow you. The extent tree (the tree involved in 
> >> the search), contains only two kind of object:
> >> 
> >> - BLOCK_GROUP_ITEM  where the key means (logical address, 0xc0,
> >> size in bytes) - EXTENT_ITEM, where the key means (logical address,
> >> 0xa8, size in bytes)
> >> 
> >> So it seems that for each (possible) "logical address", only two 
> >> items might exist; the two item are completely identified by 
> >> (objectid, type, ). It should not possible (for the extent tree)
> >> to have two item with the same objectid,key and different offset.
> >> So, for the extent tree, it is safe to advance only the objectid
> >> field.
> >> 
> >> I am wrong ?
> > 
> > When calling the search ioctl, the caller has to provide a memory
> > buffer that the kernel is going to fill with results. For
> > BTRFS_IOC_TREE_SEARCH used here, this buffer has a fixed size of 4096
> > bytes. Without some headers etc, this leaves a bit less than 4000
> > bytes of space for the kernel to write search result objects to.
> > 
> > If I do a search that will result in far more objects to be returned
> > than possible to fit in those <4096 bytes, the kernel will just put a
> > few in there until the next one does not fit any more.
> > 
> > It's the responsibility of the caller to change the start of the
> > search to point just after the last received object and do the search
> > again, in order to retrieve a few extra results.
> 
> You are right. If the last item in the buffer is a EXTENT_ITEM, and the 
> next item in the disk is a BLOCK_GROUP_ITEM with the same object id,
> the latter would be skipped.
> 
> I was find always terrible the BTRFS_IOC_TREE_SEARCH; if the min_*
> fields was separate from the key, the use of this ioctl would
> be a lot simpler. Moreover in most case (like this one), it would be 
> reduced the context switches, because the ioctl would return
> only valid data.

   There's an argument for implementing it. However, given the way the
indexing works (concatenation of the key elements, resulting in
lexical ordering of keys), you'd still have to do exactly the same
work, only in the kernel instead. The only thing you really win is the
number of context switches.

   It would really have to be a new ioctl, too. You can't change the
behaviour of the existing one.

   Hugo.

> > 
> > So, the important line here was: "...when the extent_item just
> > manages to squeeze in as last result into the current result buffer
> > from the ioctl..."
> > 
> 
> 

-- 
Hugo Mills             | "What are we going to do tonight?"
hugo@... carfax.org.uk | "The same thing we do every night, Pinky. Try to
http://carfax.org.uk/  | take over the world!"
PGP: E2AB1DE4          |

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXYEnnAAoJEFheFHXiqx3k3KgP/RGyAby+AQ06Gu7PVkSxhvZh
7njtQs+FAQF1vnpwh0CbAAEs7zhOaWZGEN0xNKJs+Yjy0Z93u2I5HSoHv7YEkalw
2Ph87PQ/mhdTJpPAHjJX4jp5qCHzxuY+O49s7dKPcSBlLiKcWRKDsjYgEuufBBxm
DZiCf/UStmM0qEx+J927On1pk/+mfHmSrJrpIWC8PbJY+IWtS4KH67dDiIhMTtQg
v8C5n7v2hzLxVmyvugTIG7IVitraMFtySElU/fBaajDf7hieK1z1qJaGED0YS1zd
epE1JR/EIjgBbsfOFOCk4zxAylFhPFFgJ0VDWfL8xQm2vbDvAvatS0jRksUrVsdo
aN8+R/0cv3KqoOk4VMkS/LqCegdPevd/evyGnhg0MBjlezjlv7/h3/2ObOdtiVfD
mqmPmJgSTHQO99Ed3Cy3rL1dy7u/K0mYvB8PTd6HZ9wb39sN2k7wu/Tg9xgYFYCp
CMQmbf74IzeuBXgiRWlO7/u0WCwFFuruUgNnWslSvKbhIU31ZH2fpB0nt4o/40Ic
sCrtmJldzwBz+ynDa5euV8mwgqNDuADEn6z29Wvg3p1RK7cWFQMgemR0IJKSUafw
dd+yjYJ2P1K5FkCvRJdHNVdSufUJnL9cOlEqoxoWTy+dohm00tfbegdI09jW6wlN
dlThifD6a0tlgxY7bypg
=S3kc
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--
