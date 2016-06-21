Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43593 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751628AbcFUB4C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 21:56:02 -0400
Date: Mon, 20 Jun 2016 21:55:59 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Adventures in btrfs raid5 disk recovery
Message-ID: <20160621015559.GM15597@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
 <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org>
 <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org>
 <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bgLLobvf7eP6VP5c"
In-Reply-To: <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bgLLobvf7eP6VP5c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2016 at 03:27:03PM -0600, Chris Murphy wrote:
> On Mon, Jun 20, 2016 at 2:40 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > On Mon, Jun 20, 2016 at 01:30:11PM -0600, Chris Murphy wrote:
>=20
> >> For me the critical question is what does "some corrupted sectors" mea=
n?
> >
> > On other raid5 arrays, I would observe a small amount of corruption eve=
ry
> > time there was a system crash (some of which were triggered by disk
> > failures, some not).
>=20
> What test are you using to determine there is corruption, and how much
> data is corrupted? Is this on every disk? Non-deterministically fewer
> than all disks? Have you identified this as a torn write or
> misdirected write or is it just garbage at some sectors? And what's
> the size? Partial sector? Partial md chunk (or fs block?)

In earlier cases, scrub, read(), and btrfs dev stat all reported the
incidents differently.  Scrub would attribute errors randomly to disks
(error counts spread randomly across all the disks in the 'btrfs scrub
status -d' output).  'dev stat' would correctly increment counts on only
those disks which had individually had an event (e.g. media error or
SATA bus reset).

Before deploying raid5, I tested these by intentionally corrupting
one disk in an otherwise healthy raid5 array and watching the result.
When scrub identified an inode and offset in the kernel log, the csum
failure log message matched the offsets producing EIO on read(), but
the statistics reported by scrub about which disk had been corrupted
were mostly wrong.  In such cases a scrub could repair the data.

A different thing happens if there is a crash.  In that case, scrub cannot
repair the errors.  Every btrfs raid5 filesystem I've deployed so far
behaves this way when disks turn bad.  I had assumed it was a software bug
in the comparatively new raid5 support that would get fixed eventually.

In this current case, I'm getting things like this:

[12008.243867] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4105596028 wanted 787343232 mirror 0
[12008.243876] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1689373462 wanted 787343232 mirror 0
[12008.243885] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3621611229 wanted 787343232 mirror 0
[12008.243893] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 113993114 wanted 787343232 mirror 0
[12008.243902] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1464956834 wanted 787343232 mirror 0
[12008.243911] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 2545274038 wanted 787343232 mirror 0
[12008.243942] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4090153227 wanted 787343232 mirror 0
[12008.243952] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4129844199 wanted 787343232 mirror 0
[12008.243961] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4129844199 wanted 787343232 mirror 0
[12008.243976] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 172651968 wanted 787343232 mirror 0
[12008.246158] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4129844199 wanted 787343232 mirror 1
[12008.247557] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1374425809 wanted 787343232 mirror 1
[12008.403493] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1567917468 wanted 787343232 mirror 1
[12008.409809] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 2881359629 wanted 787343232 mirror 0
[12008.411165] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3021442070 wanted 787343232 mirror 0
[12008.411180] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3984314874 wanted 787343232 mirror 0
[12008.411189] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 599192427 wanted 787343232 mirror 0
[12008.411199] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 2887010053 wanted 787343232 mirror 0
[12008.411208] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1314141634 wanted 787343232 mirror 0
[12008.411217] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3156167613 wanted 787343232 mirror 0
[12008.411227] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 565550942 wanted 787343232 mirror 0
[12008.411236] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 4068631390 wanted 787343232 mirror 0
[12008.411245] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 531263990 wanted 787343232 mirror 0
[12008.411255] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1992044858 wanted 787343232 mirror 0
[12008.411264] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 1516200640 wanted 787343232 mirror 0
[12008.411273] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3762784693 wanted 787343232 mirror 0
[12008.411282] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 42246361 wanted 787343232 mirror 0
[12008.411291] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825306624 csum 3989363071 wanted 787343232 mirror 0
[12008.422079] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 983444376 wanted 931479324 mirror 0
[12008.422402] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3757815310 wanted 913327053 mirror 2
[12008.542715] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 425031800 wanted 931479324 mirror 0
[12008.542722] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 1254202754 wanted 931479324 mirror 0
[12008.542749] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 4281398184 wanted 931479324 mirror 0
[12008.543730] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 1016285311 wanted 931479324 mirror 0
[12008.545174] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3122785442 wanted 931479324 mirror 0
[12008.549530] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 2691681328 wanted 931479324 mirror 0
[12008.556722] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 1956690651 wanted 931479324 mirror 0
[12008.556744] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 857176374 wanted 931479324 mirror 0
[12008.556756] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 2858632553 wanted 931479324 mirror 0
[12008.557901] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3245431096 wanted 913327053 mirror 2
[12008.557907] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.557935] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.557938] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.557952] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.557954] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3251056521 wanted 931479324 mirror 0
[12008.558054] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3711050593 wanted 931479324 mirror 0
[12008.561564] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3540653895 wanted 931479324 mirror 0
[12008.568799] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 876087402 wanted 931479324 mirror 0
[12008.568817] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 809865123 wanted 931479324 mirror 0
[12008.568827] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 884024971 wanted 931479324 mirror 0
[12008.568839] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 2677615947 wanted 931479324 mirror 0
[12008.572122] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3536357904 wanted 931479324 mirror 1
[12008.572907] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3763483742 wanted 931479324 mirror 2
[12008.572964] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3157651551 wanted 931479324 mirror 2
[12008.572994] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 824699142 wanted 931479324 mirror 2
[12008.573066] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.573097] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.573126] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.573155] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.573187] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3536357904 wanted 931479324 mirror 2
[12008.573209] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 2691681328 wanted 931479324 mirror 2
[12008.573239] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3757815310 wanted 913327053 mirror 2
[12008.573529] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3536357904 wanted 931479324 mirror 0
[12008.574222] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825368064 csum 3757815310 wanted 913327053 mirror 2
[12008.577201] BTRFS info (device vdc): csum failed ino 4420604 extent 1541=
295742976 csum 3536357904 wanted 931479324 mirror 0
[12008.595253] BTRFS info (device vdc): csum failed ino 4420604 extent 2680=
5825372160 csum 3757815310 wanted 913327053 mirror 2

The "wanted" field looks suspicious--this filesystem does not have large
areas filled with blocks of constant value, much less multiple different
constant values, and certainly not in the affected files. =20

The other other weird thing here is that I can't find an example in the
logs of an extent with an EIO that isn't compressed.  I've been looking
up a random sample of the extent numbers, matching them up to filefrag
output, and finding e.g. the one compressed extent in the middle of an
otherwise uncompressed git pack file.  That's...odd.  Maybe there's a
problem with compressed extents in particular?  I'll see if I can
script something to check all the logs at once...

> >  It looked like any writes in progress at the time
> > of the failure would be damaged.  In the past I would just mop up the
> > corrupt files (they were always the last extents written, easy to find
> > with find-new or scrub) and have no further problems.
>=20
> This is on Btrfs? This isn't supposed to be possible. Even a literal
> overwrite of a file is not an overwrite on Btrfs unless the file is
> nodatacow. Data extents get written, then the metadata is updated to
> point to those new blocks. There should be flush or fua requests to
> make sure the order is such that the fs points to either the old or
> new file, in either case uncorrupted. That's why I'm curious about the
> nature of this corruption. It sounds like your hardware is not exactly
> honoring flush requests.

That's true when all the writes are ordered within a single device, but
possibly not when writes must be synchronized across multiple devices.
It could be possible to corrupt existing data if:

	- btrfs puts multiple extents in the same RAID5 stripe

	- writes two of the extents in different transactions

	- the array is degraded so the RAID5 write hole applies

	- writes stop (crash, powerfail, etc) after updating some of
	the blocks in the stripe but not others in the second transaction.

This corrupts the data written in the first transaction, unless there's
something in btrfs that explicitly prevents this from happening (e.g.
the allocator prevents the second step, which would seem to burn up a
lot of space).

The filesystem would continue to work afterwards with raid1 metadata
because every disk in raid1 updates its blocks in the same order,
and there are no interdependencies between blocks on different disks
(not like a raid5 stripe, anyway).

Excluding the current event, this only happened to me when the disks
were doing other questionable things, like SATA link resets or dropping
off the SATA bus, so there could have been an additional hardware issue.

This does happen on _every_ raid5 deployment I've run so far, though,
and they don't share any common hardware or firmware components.

> I've had perhaps a hundred power off during write with Btrfs and SSD
> and I don't ever see corrupt files. It's definitely not normal to see
> this with Btrfs.

These are spinning rust.  They are probably quite vulnerable to RAID
write hole issues when writing in degraded mode due to the comparatively
large write latency variation between disks.

> > Now that I did a little deeper into this, I do see one fairly significa=
nt
> > piece of data:
> >
> >         root@host:~# btrfs dev stat /data | grep -v ' 0$'
> >         [/dev/vdc].corruption_errs 16774
> >         [/dev/vde].write_io_errs   121
> >         [/dev/vde].read_io_errs    4
> >         [devid:8].read_io_errs    16
> >
> > Prior to the failure of devid:8, vde had 121 write errors and 4 read
> > errors (these counter values are months old and the errors were long
> > since repaired by scrub).  The 16774 corruption errors on vdc are all
> > new since the devid:8 failure, though.
>=20
> On md RAID 5 and 6, if the array gets parity mismatch counts above 0
> doing a scrub (check > md/sync_action) there's a hardware problem.
> It's entirely possible you've found a bug, but it must be extremely
> obscure to basically not have hit everyone trying Btrfs raid56. I

I've met many btrfs users on IRC but never one with a successful raid56
recovery story.  Give me a shout on IRC if you have one.  ;)

(I'm excluding my own recovery success stories--those were 16GB test
filesystems running on kvm, and they recovered *perfectly*).

> think you need to track down the source of this corruption and stop it
>  however possible; whether that's changing hardware, or making sure
> the system isn't crashing.

It's been a few hours, there have been plenty of EIOs on reads, but the
dev stat counters haven't changed from the values above.

I'm inclined to blame software for the EIOs:

	- the dev stat counters aren't changing, but there are dozens
	of read() EIOs going by.

	- the checksums of long block runs are all identical and not zero.
	Not one or two examples, all the logs going back several days
	look like this.

	- with the patches, I'm executing code on the far side of BUG_ONs.
	Most btrfs users aren't testing that code, they would have
	crashed first.  It still could be my fault for walking past the
	DANGER signs...

Probably something goes wrong earlier on, and the corruption is just a
symptom of the same failure that lead to the original BUG_ONs.

> --=20
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bgLLobvf7eP6VP5c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldonq8ACgkQgfmLGlazG5wrYQCcCpS9+g2srATIcmO2yIjNQAmq
ycgAmgLe4ryDyqMhZQ+SHn4sE2Kd6Z12
=2yxw
-----END PGP SIGNATURE-----

--bgLLobvf7eP6VP5c--
