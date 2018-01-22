Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42934 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeAVR6U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 12:58:20 -0500
Date: Mon, 22 Jan 2018 12:58:08 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Nikolay Borisov <nborisov@suse.com>, enadolski@suse.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove spurious WARN_ON(ref->count) in
 find_parent_nodes
Message-ID: <20180122175754.7efpwtbnil73m6ay@hungrycats.org>
References: <20180121190848.7wmps6q5ng6b42ki@hungrycats.org>
 <20180122033452.GA532@fnst.localdomain>
 <9151459e-8db2-bdd1-a21e-23d730cb52a4@suse.com>
 <87ed4d9c-9af4-4425-5a35-b0ccd9305e76@cn.fujitsu.com>
 <377c6852-6617-b4e0-5e69-60a9566bd894@suse.com>
 <20180122130622.GB532@fnst.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qt6ssn6zhdtmetpa"
In-Reply-To: <20180122130622.GB532@fnst.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qt6ssn6zhdtmetpa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 22, 2018 at 09:06:23PM +0800, Lu Fengqi wrote:
> On Mon, Jan 22, 2018 at 02:38:42PM +0200, Nikolay Borisov wrote:
> >
> >
> >On 22.01.2018 14:19, Lu Fengqi wrote:
> >> On 01/22/2018 04:46 PM, Nikolay Borisov wrote:
> >>>
> >>>
> >>> On 22.01.2018 05:34, Lu Fengqi wrote:
> >>>> According to my bisect result, The frequency of the warning occurren=
ce
> >>>> increased to the detectable degree after this patch
> >>>
> >>> That sentence implies that even before Ed's patch it was possible to
> >>> trigger those warnings, is that true? Personally I've never seen such
> >>> warnings while executing btrfs/004. How do you configure the filesyst=
em
> >>> for the test runs?
> >>>
> >>=20
> >> Just only default mount option.
> >>=20
> >> =E2=9E=9C=C2=A0 xfstests-dev git:(master) for i in $(seq 1 100); do ec=
ho $i; if !
> >> sudo ./check btrfs/004; then break; fi; done
> >> 1
> >>=20
> >> FSTYP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- btrfs
> >>=20
> >> PLATFORM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- Linux/x86_64 sarch 4.15.0-rc9
> >>=20
> >> MKFS_OPTIONS=C2=A0 -- /dev/vdd1
> >>=20
> >> MOUNT_OPTIONS -- /dev/vdd1 /mnt/scratch
> >>=20
> >>=20
> >>=20
> >>=20
> >> btrfs/004 47s ... 49s
> >>=20
> >> Ran: btrfs/004
> >>=20
> >> Passed all 1 tests
> >>=20
> >>=20
> >>=20
> >>=20
> >> 2
> >>=20
> >> FSTYP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- btrfs
> >>=20
> >> PLATFORM=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -- Linux/x86_64 sarch 4.15.0-rc9
> >>=20
> >> MKFS_OPTIONS=C2=A0 -- /dev/vdd1
> >>=20
> >> MOUNT_OPTIONS -- /dev/vdd1 /mnt/scratch
> >>=20
> >>=20
> >>=20
> >>=20
> >> btrfs/004 49s ... 52s
> >>=20
> >> _check_dmesg: something found in dmesg (see
> >> /home/luke/workspace/xfstests-dev/results//btrfs/004.dmesg)
> >>=20
> >> Ran: btrfs/004
> >>=20
> >> Failures: btrfs/004
> >>=20
> >> Failed 1 of 1 tests
> >>=20
> >> The probability of this warning appearing is rather low, and I only
> >> encountered 52 warnings when I looped 1008 times btrfs/004 for 20 hours
> >> in 4.15-rc6 (IOW, the probability is nearly 5%). So you want to trigger
> >> warning also need more luck or patience.
> >
> >Thanks but is this before or after the mentioned commit below?
> >
>=20
> After this commit. The bisect condition I use to locate this commit is
> to repeat btrfs/004 20 times without warning (This may not be accurate en=
ough,
> can only be used as a reference).=20

I have been seeing this warning since at least 2015 (v3.18?),
possibly earlier.  In the past it has never been correlated to any
event I've need to take action to correct (i.e. no data corruption,
no crashes, no hangs, no filesystem damage, and no obvious functional
failures in userspace).

In v4.14 nothing seems to have changed, except the warning now appears
three orders of magnitude more often.  This spams console terminals and
kernel logs with gigabytes of stacktrace and bumps this phenomenon up
to the top of my priority list.

It looks like the warning has been there with only minor editorial changes
since Jan Schmidt's 2011 commit "Btrfs: added btrfs_find_all_roots()"
in v3.3-rc1.

> Maybe Zygo has found a finer way to reproduce
> it, so he reproduce this warning more frequently than me.

It's not really a finer way, but bees hits this warning most often,
sometimes many times per second in bursts lasting minutes at a time.

btrfs balance also hits the warning occasionally (it was the most common
trigger of that warning in 2015 before I was running bees everywhere).

The net effect of the bees worker loop looks fairly similar to btrfs/004,
basically calling LOGICAL_INO many times per second on a busy filesystem.

bees focuses its activity on active parts of the filesystem, which
means it's more likely to do backref walks against extents that are also
being affected by user activity and therefore more likely to encounter
delayed refs.

Contrast with 'btrfs balance' which spreads its effect across the entire
filesystem and is much less likely to collide with user activity.

Every duplicate extent hit in bees uses LOGICAL_INO at least once to map
a stored duplicate block bytenr back to something that can be passed to
open() and FILE_EXTENT_SAME.  The warnings do arrive in bursts at the
same time as bees hitting clusters of duplicate extents.



> >
> >>=20
> >>>> 86d5f9944252 ("btrfs: convert prelimary reference tracking to use
> >>>> rbtrees")
> >>>> is committed. I understand that this does not mean that this patch
> >>>> caused
> >>>> the problem, but maybe Edmund can give us some help, so I added him
> >>>> to the
> >>>> recipient.
> >>>
> >>>
> >>=20
> >>=20
> >
> >
>=20
> --=20
> Thanks,
> Lu
>=20
>=20

--qt6ssn6zhdtmetpa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCWmYmGQAKCRCB+YsaVrMb
nNdHAKDIOglqdSnCpd2WzM+VR1FG5ssx7QCgslEo+Tac0zAuZrV4xPBFSV1WMrQ=
=6uh+
-----END PGP SIGNATURE-----

--qt6ssn6zhdtmetpa--
