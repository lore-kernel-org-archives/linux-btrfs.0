From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC PATCH 0/4] Add readonly support to replace BUG_ON phrase
Date: Mon, 29 Nov 2010 16:22:05 -0500
Message-ID: <20101129212204.GD2618@localhost.localdomain>
References: <4CEE31EF.1020102@cn.fujitsu.com> <20101129201017.GB2618@localhost.localdomain> <AANLkTinZtB3o5QXQdwW8-qO6YhJDTLOotrHXD5E2Booo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, Miao Xie <miaox@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinZtB3o5QXQdwW8-qO6YhJDTLOotrHXD5E2Booo@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 01:12:17PM -0800, Mike Fedyk wrote:
> On Mon, Nov 29, 2010 at 12:10 PM, Josef Bacik <josef@redhat.com> wrot=
e:
> > On Thu, Nov 25, 2010 at 05:52:47PM +0800, Miao Xie wrote:
> >> Btrfs has a number of BUG_ON()s, which may lead btrfs to unpleasan=
t panic.
> >> Meanwhile, they are very ugly and should be handled more propriate=
ly.
> >>
> >> There are mainly two ways to deal with these BUG_ON()s.
> >>
> >> 1. For those errors which can be handled well by callers, we just =
return their
> >> error number to callers.
> >>
> >> 2. For others, We can force the filesystem readonly when it hits e=
rrors, which
> >> =A0is what this patchset has done. Replaced BUG_ON() with the inte=
rface provided
> >> =A0in this patchset, we will get error infomation via dmesg. Since=
 btrfs is now
> >> readonly, we can save our data safely and umount it, then a btrfsc=
k is
> >> recommended.
> >>
> >> By these ways, we can protect our filesystem from panic caused by =
those
> >> BUG_ONs.
> >>
> >> ---
> >> =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 21 ++++++++++
> >> =A0fs/btrfs/disk-io.c =A0 =A0 | =A0 23 +++++++++++
> >> =A0fs/btrfs/super.c =A0 =A0 =A0 | =A0100 +++++++++++++++++++++++++=
+++++++++++++++++++++-
> >> =A0fs/btrfs/transaction.c | =A0 =A07 +++
> >> =A04 files changed, 148 insertions(+), 3 deletions(-)
> >>
> >
> > Overall seems sane, but what about kernels that don't make these ch=
ecks? =A0I'm ok
> > with "well sucks for them" as an answer, just want to make sure we'=
ve at least
> > though about it.
> >
> > Also I'm not sure marking the fs as broken is the right move here. =
=A0Ext3/4 don't
> > do this, they just mount read-only, as long as you can still unmoun=
t the
> > filesystem everything comes out ok. =A0Think of the case where we j=
ust get a
> > spurious EIO, the fs should be fine the next time around, there's r=
eason to
> > force the user to run fsck in this case.
> >
>=20
> Did you mean "there's no reason to"?
>

Right yes, thank you.
=20
> Also I guess you mean this in the case when there is no redundancy
> (single and raid0) as the other cases should recover from spurious EI=
O
> at run time.

Right, I'm speaking of transient errors that don't really mean anything
catastrophic.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
