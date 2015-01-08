Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44747 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753578AbbAHP4N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Jan 2015 10:56:13 -0500
Date: Thu, 8 Jan 2015 10:56:11 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: price to pay for nocow file bit?
Message-ID: <20150108155610.GA12859@hungrycats.org>
References: <20150107174315.GA21865@gardel-login>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
In-Reply-To: <20150107174315.GA21865@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 06:43:15PM +0100, Lennart Poettering wrote:
> Heya!
>=20
> Currently, systemd-journald's disk access patterns (appending to the
> end of files, then updating a few pointers in the front) result in
> awfully fragmented journal files on btrfs, which has a pretty
> negative effect on performance when accessing them.
>=20
> Now, to improve things a bit, I yesterday made a change to journald,
> to issue the btrfs defrag ioctl when a journal file is rotated,
> i.e. when we know that no further writes will be ever done on the
> file.=20
>=20
> However, I wonder now if I should go one step further even, and use
> the equivalent of "chattr -C" (i.e. nocow) on all journal files. I am
> wondering what price I would precisely have to pay for
> that. Judging by this earlier thread:
>=20
>         http://www.spinics.net/lists/linux-btrfs/msg33134.html
>=20
> it's mostly about data integrity, which is something I can live with,
> given the conservative write patterns of journald, and the fact that
> we do our own checksumming and careful data validation. I mean, if
> btrfs in this mode provides no worse data integrity semantics than
> ext4 I am fully fine with losing this feature for these files.

This sounds to me like a job for fallocate with FALLOC_FL_KEEP_SIZE.
This would work on ext4, xfs, and others, and provide the same benefit
(or even better) without filesystem-specific code.  journald would
preallocate a contiguous chunk past the end of the file for appends, and
on btrfs the first write to each block will not be COWed or compressed
(I'm hand-waving away some details here related to small writes, file
tails, and inline storage, but the end result is the same).  If there's a
configured target size for journals then allocate that amount; otherwise,
double the allocated size each time the visible file size reaches a power
of two so that the number of fragments is logarithmic over file size.

This should get you what you want without all the dangerous messing around
with data integrity controls and defragmentation.  Defragmentation has a
number of negative side-effects of its own:  it searches for free space
aggressively and holds locks that can block writes for a long time (I've
learned the hard way that this can be over 20 minutes for a 1GB file, long
enough to trigger hardware watchdog resets).  There are some other good
reasons to never defragment, but they don't arise in journald's use cases.

I, for one, use btrfs scrub to detect data corruption that occurs during
early stages of disk failure.  I'd object strongly to applications
randomly turning off data integrity features without being explicitly
configured to do so, especially those that do most of the writing.
It would create areas of the disk that are blind spots when testing for
storage corruption errors, and in journald's case those blind spots would
be among the most significant sources of data about storage corruption.

I don't really care if applications can survive corrupted data--as the
owner of the storage, I need to be aware that storage-level corruption is
happening.  I don't want to have to test different areas of the filesystem
with a dozen different application-specific tools.  That particular
insanity is one of the reasons why I now use btrfs and not ext4.

> Hence I am mostly interested in what else is lost if this flag is
> turned on by default for all journal files journald creates:=20
>=20
> Does this have any effect on functionality? As I understood snapshots
> still work fine for files marked like that, and so do
> reflinks. Any drawback functionality-wise? Apparently file compression
> support is lost if the bit is set? (which I can live with too, journal
> files are internally compressed anyway)
>=20
> What about performance? Do any operations get substantially slower by
> setting this bit? For example, what happens if I take a snapshot of
> files with this bit set and then modify the file, does this result in
> a full (and hence slow) copy of the file on that occasion?=20
>=20
> I am trying to understand the pros and cons of turning this bit on,
> before I can make this change. So far I see one big pro, but I wonder
> if there's any major con I should think about?
>=20
> Thanks,
>=20
> Lennart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSuqJkACgkQgfmLGlazG5yXBgCeIsIfIxdmyhQocXaCp08MsMnD
B7gAn32XY/B2zD44cci6uayUkOuXp7q2
=dmC+
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
