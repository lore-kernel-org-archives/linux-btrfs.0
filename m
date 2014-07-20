Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56560 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbaGTKWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 06:22:50 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MVN0w-1X2qM2251y-00Yki6 for
 <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 12:22:48 +0200
Date: Sun, 20 Jul 2014 12:22:33 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC errors during balance
Message-ID: <20140720122233.4ef06751@marcec>
In-Reply-To: <pan$c685d$4bb40507$f2be4604$15619074@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PyxIiS0y3sD_rtHbI0C=6Up"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/PyxIiS0y3sD_rtHbI0C=6Up
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Am Sun, 20 Jul 2014 02:39:27 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> Chris Murphy posted on Sat, 19 Jul 2014 11:38:08 -0600 as excerpted:
>=20
> > I'm not sure of the reason for the "BTRFS info (device sdg2): 2 enospc
> > errors during balance" but it seems informational rather than either a
> > warning or problem. I'd treat ext4->btrfs converted file systems to be
> > something of an odd duck, in that it's uncommon, therefore isn't getting
> > as much testing and extra caution is a good idea. Make frequent backups.
>=20
> Expanding on that a bit...
>=20
> Balance simply rewrites chunks, combining where possible and possibly=20
> converting to a different layout (single/dup/raid0/1/10/5/6[1]) in the=20
> process.  The most common reason for enospc during balance is of course=20
> all space allocated to chunks, with various workarounds for that if it=20
> happens, but that doesn't seem to be what was happening to you
> (Mark J./OP).
>=20
> Based on very similar issues reported by another ext4 -> btrfs converter=
=20
> and the discussion on that thread, here's what I think happened:
>=20
> First a critical question for you as it's a critical piece of this=20
> scenario that you didn't mention in your summary.  The wiki page on
> ext4 -> btrfs conversion suggests deleting the ext2_saved subvolume and=20
> then doing a full defrag and rebalance.  You're attempting a full=20
> rebalance, but have you yet deleted ext2_saved and did you do the defrag=
=20
> before attempting the rebalance?
>=20
> I'm guessing not, as was the case with the other user that reported this=
=20
> issue.  Here's what apparently happened in his case and how we fixed it:

Ah, I actually did, in fact.  I only implicitly said it, though.  Here's wh=
at I
wrote:

"After converting the backup partition about a week ago, following the wiki
entry on ext4 conversion, I eventually ran a full balance [...]"

The wiki says to run a full balance (and defragment before that, but that w=
as
sloooooooow, so I didn't do it), *after* deleting the ext4 file system imag=
e.
So the full balance was right after doing that :) .

> The problem is that btrfs data chunks are 1 GiB each.  Thus, the maximum=
=20
> size of a btrfs extent is 1 GiB.  But ext4 doesn't have an arbitrary=20
> limitation on extent size, and for files over a GiB in size, ext4 extents=
=20
> can /also/ be over a GiB in size.
>=20
> That results in two potential issues at balance time.  First, btrfs=20
> treats the ext2_saved subvolume as a read-only snapshot and won't touch=20
> it, thus keeping the ext* data intact in case the user wishes to rollback=
=20
> to ext*.  I don't think btrfs touches that data during a balance either,=
=20
> as it really couldn't do so /safely/ without incorporating all of the=20
> ext* code into btrfs.  I'm not sure how it expresses that situation, but=
=20
> it's quite possible that btrfs treats it as enospc.
>=20
> Second, for files that had ext4 extents greater than a GiB, balance will=
=20
> naturally enospc, because even the biggest possible btrfs extent, a full=
=20
> 1 GiB data chunk, is too small to hold the existing file extent.  Of=20
> course this only happens on filesystems converted from ext*, because=20
> natively btrfs has no way to make an extent larger than a GiB, so it=20
> won't run into the problem if it was created natively instead of=20
> converted from ext*.
>=20
> Once the ext2_saved subvolume/snapshot is deleted, defragging should cure=
=20
> the problem as it rewrites those files to btrfs-native chunks, normally=20
> defragging but in this case fragging to the 1 GiB btrfs-native data-chunk-
> size extent size.

Hmm, well, I didn't defragment because it would have taken *forever* to go
through all those hardlinks, plus my experience is that ext* doesn't fragme=
nt
much at all, so I skipped that step.  But I certainly have files over 1GB in
size.

On the other hand, the wiki [0] says that defragmentation (and balancing) is
optional, and the only reason stated for doing either is because they "will=
 have
impact on performance".

> Alternatively, and this is what the other guy did, one can find all the=20
> files from the original ext*fs over a GiB in size, and move them off-
> filesystem and back AFAIK he had several gigs of spare RAM and no files=20
> larger than that, so he used tmpfs as the temporary storage location,=20
> which is memory so the only I/O is that on the btrfs in question.  By=20
> doing that he deleted the existing files on btrfs and recreated them,=20
> naturally splitting the extents on data-chunk-boundaries as btrfs=20
> normally does, in the recreation.
>=20
> If you had deleted the ext2_saved subvolume/snapshot and done the defrag=
=20
> already, that explanation doesn't work as-is, but I'd still consider it=20
> an artifact from the conversion, and try the alternative move-off-
> filesystem-temporarily method.

I'll try this and see, but I think I have more files >1GB than would account
for this error (which comes towards the end of the balance when only a few
chunks are left).  I'll see what "find /mnt -type f -size +1G" finds :) .

> If you don't have any files over a GiB in size, then I don't know...=20
> perhaps it's some other bug.
>=20
> ---
> [1] Raid5/6 support not yet complete.  Operational code is there but=20
> recovery code is still incomplete.

[0] https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

Thanks
--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/PyxIiS0y3sD_rtHbI0C=6Up
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTy5h2AAoJEL/Q5oYsiHj0lwwQAIVPtznLcmS+bIW+BQLbbjR8
RjFg38PlXSrm+AARO5I7gY2OjkFicJZZCJ8C1ebwmTFYI1TshgrBrFtvjlPNkGcG
Jm+/hU/VGMOdpuPORxy7Oot+jIzqglVkDlG71hP6WloI5lRR7AyZWwVrzHzw5ceC
mBoL7K9U5PRUSM0/CvVdolssxc7M6jRboPPXfyXFbjr3tqPiurjtoj9F7VRqtypa
VO+G25XZE6cxiH83Zepk8x/EKJHeAR5euOeo0pD7MfsaBuWTEafcoBoTvLvCKBv2
bc7BbUbaZaMVOsX6PZ0pqAgLkg8muE8RI7yyDetKgY/lWP2ZBK3GJqV5EJjexzJc
9Bc9w28MsSsF4Xv9lbu4A5VBbm1uwEtmcDtIwxadOCvCKosGwmAUx2hCy2xLsQi3
F3RPgJGhVPkHZ9Nu0N7IIbK0HcMcjgpa/fKOQYBY+xTVCQ2I06Cd2jEdmTJ9vtrn
qeYcZaYcQdC01HINCVR/1RQYckH+yBHg2PSPAl6A0HFRFY0jIF/5hrEepB+rpu6b
EOwq7z+96vNULnw5lktxjzqkvFxXhchZC7jTA2/y9VV5/JlpbsI79trAVFKmyV05
PhtWG4DZc18y7PJxd+kSbxniiBbjK1rvms0PPOkl06WZy0zlrxDi3xGZP1n+NjP3
aUKbN82tEateC/H3N+OZ
=3sFd
-----END PGP SIGNATURE-----

--Sig_/PyxIiS0y3sD_rtHbI0C=6Up--
