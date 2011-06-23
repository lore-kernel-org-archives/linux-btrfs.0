From: Gerhard Kulzer <gerhard@kulzer.net>
Subject: Re: btrfs: failed to load free space cache for block group on  =?utf-8?b?cnN5bmPCtGluZw==?= to =?utf-8?b?c3BhY2VfY2FjaGU=?= BTRFS with subvolume
Date: Thu, 23 Jun 2011 20:42:02 +0000 (UTC)
Message-ID: <loom.20110623T223707-409@post.gmane.org>
References: <201106231937.12848.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald <Martin <at> lichtvoll.de> writes:

>=20
> Hi!
>=20
> Short summary: I suspect that rsync=C2=B4ing files to a newly created=
 BTRFS=20
> partition with a subvolume *and* enabled space_cache triggers the err=
or=20
> mentioned in the subject line of this mail. I reported this also as:
>=20
> Bug 38112 -  btrfs: failed to load free space cache for block group o=
n=20
> rsync=C2=B4ing to space_cache BTRFS with subvolume
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D38112
>=20

Same happens to me when I use Ubuntu kernel 3.0.1, after a short time l=
ike 20
seconds into the desktop I get the same error message. This happens on =
a btrfs
system that is already 2 years old and never had that problem (mount=3D=
ssd,
compress=3Dlzo,noatime, space_cache).

When I boot with 2.6.38-10 I never get this error. So I assume that the=
 problem
is with the newer code of 3.0.1

Gerhard





--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
