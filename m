Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:36579 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751603AbbDMVpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 17:45:23 -0400
Date: Mon, 13 Apr 2015 17:45:18 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Gian-Carlo Pascutto <gcp@sjeng.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Big disk space usage difference, even after defrag, on identical
 data
Message-ID: <20150413214518.GA13004@hungrycats.org>
References: <55297D36.8090808@sjeng.org>
 <pan$f11f0$7ca65f9$58551aba$5ec77500@cox.net>
 <552BCD6F.6080509@sjeng.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
In-Reply-To: <552BCD6F.6080509@sjeng.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2015 at 04:06:39PM +0200, Gian-Carlo Pascutto wrote:
> On 13-04-15 07:06, Duncan wrote:
>=20
> >> So what can explain this? Where did the 66G go?
> >=20
> > Out of curiosity, does a balance on the actively used btrfs help?
> >=20
> > You mentioned defrag -v -r -clzo, but didn't use the -f (flush) or -t=
=20
> > (minimum size file) options.  Does adding -f -t1 help?
>=20
> Unfortunately I can no longer try this, see the other reply why. But the
> problem turned out to be some 1G-sized files, written using 3-5 extents,
> that for whatever reason defrag was not touching.

There are several corner cases that defrag won't touch by default.
It's designed to be conservative and favor speed over size.

Also when the kernel decides you're not getting enough compression, it
seems to disable compression on the file _forever_ even if future writes
are compressible again.  mount -o compress-force works around that.

> > You aren't doing btrfs snapshots of either subvolume, are you?
>=20
> No :-) I should've mentioned that.

read-only snapshots:  yet another thing defrag won't touch.

> > While initial usage will  be higher due to the lack of compression,
> > as you've discovered, over time, on an actively updated database,
> > compression isn't all that effective anyway.
>=20
> I don't see why. If you're referring to the additional overhead of
> continuously compressing and decompressing everything - yes, of course.
> But in my case I have a mostly-append workload to a huge amount of
> fairly compressible data that's on magnetic storage, so compression is a
> win in disk space and perhaps even in performance.

Short writes won't compress--not just well, but at all--because btrfs
won't look at adjacent already-written blocks.  If you write a file
at less than 4K/minute, there will be no compression, as each new extent
(or replacement extent for overwritten data) is already minimum-sized.

If you write in bursts of 128K or more, consecutively, then you can
get compression benefit.

There has been talk of teaching autodefrag to roll up the last few dozen
extents of files that grow slowly so they can be compressed.

> It turns out that if your dataset isn't update heavy (so it doesn't
> fragment to begin with), or has to be queried via indexed access (i.e.
> mostly via random seeks), the fragmentation doesn't matter much anyway.
> Conversely, btrfs appears to have better sync performance with multiple
> threads, and allows one to disable part of the partial-page-write
> protection logic in the database (full_page_writes=3Doff for PostgreSQL),
> because btrfs is already doing the COW to ensure those can't actually
> happen [1].
>=20
> The net result is a *boost* from about 40 tps (ext4) to 55 tps (btrfs),
> which certainly is contrary to popular wisdom. Maybe btrfs would fall
> off eventually as fragementation does set in gradually, but given that
> there's an offline defragmentation tool that can run in the background,
> I don't care.

I've found the performance of PostgreSQL to be wildly variable on btrfs.
It may be OK at first, but watch it for a week or two to admire the
full four-orders-of-magnitude swing (100 tps to 0.01 tps).  :-O

> [1] I wouldn't be too surprised if database COW, which consists of
> journal-writing a copy of the data out of band, then rewriting it again
> in the original place, is actually functionally equivalent do disabling
> COW in the database and running btrfs + defrag. Obviously you shouldn't
> keep COW enabled in btrfs *AND* the DB, requiring all data to be copied
> around at least 3 times...which I'm afraid almost everyone does because
> it's the default...

Journalling writes all the data twice:  once to the journal, once to
update the origin page after the journal (though PostgreSQL will omit
some of those duplicate writes in cases where there is no origin page
to overwrite).

COW writes all the new and updated data only once.

In the event of a crash, if the log tree is not recoverable (and it's
a rich source of btrfs bugs, so it's often not), you lose everything
that happened to the database in the last 30 seconds.  If you were
already using async commit in PostgreSQL anyway then that's not much
of a concern (and not having to call fsync 100 times a second _really_
helps performance!)  but if you really need sync commit then btrfs is
not the filesystem for you.

> --=20
> GCP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUsOO4ACgkQgfmLGlazG5xkjwCfUSOs6CCqXfHfimn6GuYVJoOC
k0IAoNTv2T5JGOJU/CHtCXEqx6LCsU7M
=76zA
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
