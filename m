Return-Path: <SRS0=swP/=RU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A91FC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 02:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F43421871
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Mar 2019 02:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfCQCyy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 22:54:54 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:41202 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfCQCyx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 22:54:53 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 06C44266E9F; Sat, 16 Mar 2019 22:54:50 -0400 (EDT)
Date:   Sat, 16 Mar 2019 22:54:50 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190317025450.GB16664@hungrycats.org>
References: <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
 <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
 <20190215054031.GC9995@hungrycats.org>
 <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
 <20190307200712.GG23918@hungrycats.org>
 <beebed47702d783e00d3478f217ffc646d47bb92.camel@scientia.net>
 <20190315052827.GH23918@hungrycats.org>
 <303507e634c36af048ac36c7233c3b2af8311b46.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <303507e634c36af048ac36c7233c3b2af8311b46.camel@scientia.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2019 at 11:11:10PM +0100, Christoph Anton Mitterer wrote:
> On Fri, 2019-03-15 at 01:28 -0400, Zygo Blaxell wrote:
> > But maybe there should be something like a btrfs-announce list,
> > > i.e. a
> > > low volume mailing list, in which (interested) users are informed
> > > about
> > > more grave issues.
> > > =E2=80=A6
> > I don't know if it would be a low-volume list...every kernel release
> > includes fixes for _some_ exotic corner case.
>=20
> Well this one *may* be exotic for many users, but we have at least the
> use case of qemu which seems to be not that exotic at all.
>=20
> And the ones you outline below seem even more common?
>=20
> Also the other means for end-users to know whether something is stable
> or not like https://btrfs.wiki.kernel.org/index.php/Status don't seem
> to really work out.

It's hard to separate the signal from the noise.  I first detected
the 2018 bug in 2016, but didn't know it was a distinct bug until
after eliminating all the other corruption causes that occurred during
that time.  I am still tracking issue(s) in btrfs that bring servers
down multiple times a week, so I'm not in a hurry to declare any part
of btrfs stable yet.

When could we ever confidently say btrfs is stable?  Some filesystems
are 30 years old and still fixing bugs.  See you in 2037?

Now, that specific wiki page should probably be updated, since at least
one outstanding bug is now known.

> There is a known silent data corruption bug which seems so far only
> fixed in 5.1rc* ... and the page still says stable since 4.14.
> Even know with the fix, one should probably need to wait a year or so
> until one could mark it stable again if nothing had been found by then.

I sometimes use "it has been $N days since the last bug fix in $Y" as a
crude metric of how trustworthy code is.  adfs is 2913 days and counting!
ext2 is only 106 days.  btrfs and xfs seem to be competing for the lowest
value of N, never rising above a few dozen except around holidays and
conferences, with ext4 not far behind.

> So... if btrfs allows for direct IO... and if this isn't stable in some
> situations,... what can one do about it? I mean there doesn't seem to
> be an option to disallow it...=20

Sure, but O_DIRECT is a performance/risk tradeoff.  If you ask someone who
uses csums or snapshots, they'll tell you btrfs should always put correct
data and checksums on disk, even if the application does something weird
and undefined like O_DIRECT.  If you ask someone who wants the O_DIRECT
performance, they'll tell you O_DIRECT should not waste time computing,
verifying, reading, or writing csums, nor should users expect correct
behavior from applications that don't follow the filesystem-specific
rules correctly (for some implied definition of how correct applications
should behave, because O_DIRECT is not a concrete specification), and that
includes permitting undetected data corruption to be persisted on disk.

> and any program can do O_DIRECT (without even knowing btrfs is below).

Most filesystems permit silent data corruption all of the time, so btrfs
is weird for disallowing silent data corruption some of the time.

> Guess I have to go deeper down the rabbit hole now for the other
> compressions bugs...
>=20
>=20
> > I found the 2017 compression bug in a lot of digital photographs.
>=20
> Is there any way (apart from having correct checksums) to find out
> whether a file was affected by the 2017-bug?
> Like, I don't know,.. looking for large chunks of zeros?

You need to have an inline extent in the first 4096 bytes of the file
and data starting at 4096 bytes.  Normally that never happens, but it
is possible to construct files that way with the right sequences of
write(), seek(), and fsync().  They occur naturally in about one out
of every 100,000 'rsync -S' files which triggers a similar sequence of
operations internally in the kernel.

The symptom is that the corrupted file has uninitialized kernel memory in
the last bytes of the first 4096 byte block, when the correct file has
0 bytes there.  It turns out that uninitialized kernel memory is often
full of zeros anyway, so even "corrupted" files come out unchanged most
of the time.

If you don't know what is supposed to be in those bytes (either from
the file format, an uncorrupted copy of the file, or unexpected behavior
when the file is used) then there's no way to know they're wrong.

> And is there any more detailed information available on the 2017-bug,
> in the sense under which occasions it occurred?

The kernel commit message for the fix is quite detailed.

> Like also only on reads (which would mean again that I'd be mostly
> safe, because my checksums should mostly catch this)?

Only reads, and only files with a specific structure, and only at a
single specific location in the file.

> Or just on dedupe or hole punching? Or did it only affect sparse files
> (and there only the holes (blocks of zeros) as in your camera JPG
> example)?

You can't get the 2017 bug with dedupe--inline extents are not dedupable.
You do need a sparse file.

I didn't find the 2017 bug because of bees--I found it because of
rsync -S.

> > It turns out that several popular cameras (including some of the ones
> > I
> > own) put a big chunk of zeros near the beginnings of JPG files, and
> > when
> > rsync copies those it will insert a hole instead of copying the
> > zeros.
>=20
> Many other types of files may have such bigger chunks of zeros to...
> basically everything that leaves place for meta-data.

Only contiguous chunks of 0 that end at byte 4096 can be affected.
0 anywhere else in the file is the domain of the 2018 bug.  Also 2017
replaces 0 with invalid data, while 2018 replaces valid data with 0.

> AFAIU, both cp and rsync (--sparse) don't create spares files actively
> per default,... cp (per default) only creates sparse files when it
> detects the source file to be already sparse.
> Same seems to be the case for tar, which only stores a file sparse
> (inside the archive) when --sparse is used.
>=20
> So would one be safe from the 2017 bug if one haven't had sparse files
> and not activated the sparse in any of these tools?

Probably.  Even "unsafe" is less than a 1 in 100,000 event, so you're
often safe even when using triggering tools (especially if the system
is lightly loaded).  Lots of tools make sparse files.

> >   Most photo tools ignore this data completely,
> > so when garbage appears there, nobody notices.
>=20
> So the 2017-bug meant that areas that should be zero were filled with
> garbage but everything als was preserved correclty

Yep.

> > I don't think I found an application that cared about the 2017 bug at
> > all.
>=20
> Well for me it would be still helpful to know how to find out whether I
> might have been affected or not... I do have some really old backups so
> recovery would be possible in many cases.

You could compare those backups to current copies before discarding them.
Or build a SHA table and keep a copy of it on online media for verification.

> > The 2018 bug is a different story--when it hits, it's obvious, and
> > ordinary application things break
>=20
> Which one to you mean now? The one recently fixed on
> reads+holepunching/dedupe/clone? Cause I thought that one was not not
> that obvious as it was silent...

Many applications will squawk if you delete 32K of data randomly from
the middle of their data files.  There are crashes, garbage output,
error messages, corrupted VM filesystem images (i.e. the guest's fsck
complains).  A lot of issues magically disappear after applying the
"2018" fix.

> Anything still known about the even older compression related
> corruption bugs that Filipe mentioned, in the sense when they occurred
> and how to find out whether one was affected?

Kernels from 2015 and earlier had assorted problems with compressed data.
It's difficult to distinguish between them, or isolate specific syndomes
to specific bug fixes.  Not all of them were silent--there was a bug
in 2014 that returned EIO instead of data when reading files affected
by the 2017 bug (that change in behavior was a good clue about where
to look for the 2017 fix).  One of the bugs eventually manifests itself
as a broken filesystem or a kernel panic when you write to an affected
area of a file.

It's more practical to just assume anything stored on btrfs with
compression on a kernel prior to 2015 is suspect until proven otherwise.
In 2014 and earlier, you have to start suspecting uncompressed data too.
Kernels between 2012 and 2014 crashed so often it was difficult to run
data integrity verification tests with a significant corpus size.

>=20
> Thanks,
> Chris.
>=20
>=20

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXI22+AAKCRCB+YsaVrMb
nNc5AJ9zkkNz3QdiN75IflXaV0Wdvw7axACg6RwtaIiIK8egQLHIvzKv7h66Tww=
=/Wja
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
