Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39218 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775AbaDXSp6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 14:45:58 -0400
Date: Thu, 24 Apr 2014 19:45:52 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send receive, clone
Message-ID: <20140424184552.GI2391@carfax.org.uk>
References: <35B44B63-D139-4E0E-AD6F-2320B79D19B1@colorremedies.com>
 <20140424155510.GG2391@carfax.org.uk>
 <5FFF69A6-A3E0-439C-8DAE-9DB45441CB26@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jQIvE3yXcK9X9HBh"
In-Reply-To: <5FFF69A6-A3E0-439C-8DAE-9DB45441CB26@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jQIvE3yXcK9X9HBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 11:22:40AM -0600, Chris Murphy wrote:
> 
> On Apr 24, 2014, at 9:55 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Thu, Apr 24, 2014 at 09:23:28AM -0600, Chris Murphy wrote:
> >> 
> >> 
> >> I don't understand the btrfs send -c <clone-src> man page text, or really even the use case. In part this is what it says:
> >> 
> >>> You must not specify clone sources unless you
> >>> guarantee that these snapshots are exactly in the same state on both
> >>> sides, the sender and the receiver.
> >> 
> >> If the snapshots are the same on both sides, then why would I be using clone in the first place?
> > 
> >   To copy over another snapshot which shares data with them.
> > 
> >>> -c <clone-src> Use this snapshot as a clone source for an 
> >>> incremental send (multiple allowed)
> >> 
> >> Incremental send implies the sender and receiver are not in the same state now, but will be after the command is executed. Is one, or both, snapshots rw for -c?
> >> 
> >> Anyway, I'm lost on the specifics, but clearly I'm even lost when it comes to the basic difference between -p and -c.
> > 
> > (Note: I've not actually tried the second case in what follows, but
> > it's what I think is going on. This may be subject to corrections.)
> > 
> >   OK, call the sending system "S" and the receiving system "R". Let's
> > say we've got three subvolumes on S:
> > 
> > S:A2, the current /home (say)
> > S:A1, a snapshot of an earlier version of S:A2
> > S:B, a separate subvolume that's had some CoW copies of files in both
> >     S:A1 and S:A2 made into it.
> > 
> >   If we send S:A1 to R, then we'll have to send the whole thing,
> > because R doesn't have any subvolumes yet.
> > 
> >   If we now want to send S:A2 to R, then we can use -p S:A1, and it
> > will send just the differences between those two. This means that the
> > send stream can potentially ignore a load of the metadata as well as
> > the data. It's effectively saying, "you can clone R:A1, then do these
> > things to it to get R:A2".
> > 
> >   If we now want to send S:B to R, then we can use -c S:A1 -c S:A2.
> 
> OK this makes sense now, thanks.
> 
> Does the use of -c always require at least two -c instances? Is there an example where -c is used once? From the man page I'm not groking that there must be at least two -c's.

   No, my understanding is that you could have any number (0 or more).
It just allows the sending side to tell the receiving side that
there's some shared data in use that it's already got the data for,
and it just needs to hook up the extents. The reason I used two -cs
above was because there's data that S:B shares with those two
subvolumes (because that's the example scenario I picked). If S:B only
shared with one subvolume, you would use only one -c.

> >   I'm trying to think of a case where -c is useful that doesn't
> > involve someone having done cp --reflink=always between subvolumes,
> > but I can't.
> 
> OK.
> 
> 
> > So, I think the summary is:
> > 
> > * Use -p to deal with parent-child reflinks through snapshots
> > * Use -c to specify other subvolumes (present on both sides) that
> >   might contain reflinked data
> 
> I think the key is that -c implies a minimum of five subvolumes: two subvolumes on the source, which have (identical) counterparts on the destination (that's four subvolumes), and then one additional somehow related subvolume B on the source that I want on the destination.

   No, -c implies three subvolumes that exist: the one provided to the
-c, which must exist on both sides as a data source, and the one being
sent, which exists on the sending side, and will be recreated on the
receiving side, with any shared extents replicated.

> Whereas -p implies three subvolumes (one on the source which is the parent, its counterpart on the destination, and a child on the source which I want on the destination). I necessarily must understand the relationship among them in order to get the desired incremental result on the destination.

   I don't think you have to know that the subvol being sent is the
"child" of the subvol provided with -p. I suspect that the operation
would work just as well round the other way (i.e., if you've already
sent the latest snapshot, you could do a cheaper copy of older
snapshots by sending them with -p <latest_subvol>). Remember, there's
not really any deep FS-level concept of parent/child with snapshots.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Sometimes, when I'm alone, I Google myself. ---           

--jQIvE3yXcK9X9HBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU1lb31heFHXiqx3kAQIN8w/+OzCKTsK5XBmHQ8wdu3EecNjESv+vWpuq
MebW4h82jb1bYuMN8I8l06nqMWGmeBmXWIsi/YFhP/vFUhiMVZWSvfJ9HyUtk9IS
ver2YKkboqCMnCn7UcWN1kW0WFZo2deLE/hJW+61scfKxInks/TgZACBze9DQEX5
2Pw3GrIyuwkOuI1SRZTjUIm9otV7v/Cjaid2n95X239yWZ1S7LLhAXZPmjVke+kr
GU8maLAiBg19jVCt38rw0T8pCs8WAj64F+oHxkHvdxQPqwAEE92CrE2/+SRUOZP3
kdH7QnRwnOc6YJXcxQ0eXNBMz1JnoQ2KjhRfTfBtFEgK4RKkkgbD2XaSAk5nSQ1S
JIiCCvRIT+94ki+HhEFguyRAvmfBvvnXq3YnpZeqgJ8Xtsiadj4QqYrQnXYrJ7dz
xBHgHtoZcWFf8mdb8SchjG6QnVQt4t6mTwXKN/APm7z+9W/E3EsU4zThuCCiASoR
epF+IABaDvwq8CWqIshcWOpBYjFdS+VZHEdh2Sy1sYKMrRjkCnWu8jNWydshxAFO
CdQ9g9GdsYh/V8ie6p3U8fPdzVp7/jKC0w0zIhgfBfutjF4ktmgnG0YuigmaJrO4
KYor7LghJVbOLS8gYoJYSWwBu7n2t0GzN1baEb+qJMMtOUD2hLRVWtSOlcfHlK4S
ACy+8Tzpcd8=
=1ErY
-----END PGP SIGNATURE-----

--jQIvE3yXcK9X9HBh--
