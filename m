From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: RAID[56] status
Date: Tue, 10 Nov 2009 12:51:06 -0700
Message-ID: <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
References: <1249553833.568.23.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	NeilBrown <neilb@suse.de>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1249553833.568.23.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 6, 2009 at 3:17 AM, David Woodhouse <dwmw2@infradead.org> w=
rote:
> If we've abandoned the idea of putting the number of redundant blocks
> into the top bits of the type bitmask (and I hope we have), then we'r=
e
> fairly much there. Current code is at:
>
> =C2=A0 git://, http://git.infradead.org/users/dwmw2/btrfs-raid56.git
> =C2=A0 git://, http://git.infradead.org/users/dwmw2/btrfs-progs-raid5=
6.git
>
> We have recovery working, as well as both full-stripe writes and a
> temporary hack to allow smaller writes to work (with the 'write hole'
> problem, of course). The main thing we need to do is ensure that we
> _always_ do full-stripe writes, and then we can ditch the partial wri=
te
> support.
>
> I want to do a few other things, but AFAICT none of that needs to del=
ay
> the merge:
>
> =C2=A0- Better rebuild support -- if we lose a disk and add a replace=
ment,
> =C2=A0 =C2=A0we want to recreate only the contents of that disk, rath=
er than
> =C2=A0 =C2=A0allocating a new chunk elsewhere and then rewriting _eve=
rything_.
>
> =C2=A0- Support for more than 2 redundant blocks per stripe (RAID[789=
] or
> =C2=A0 =C2=A0RAID6[=C2=B3=E2=81=B4=E2=81=B5] or whatever we'll call i=
t).
>
> =C2=A0- RAID[56789]0 support.
>
> =C2=A0- Clean up the discard support to do the right thing.
>

A few comments/questions from the brief look I had at this:

1/ The btrfs_multi_bio struct bears a resemblance to the md
stripe_head struct, to the point where it makes me wonder if the
generic raid functionality could be shared between md and btrfs via a
common 'libraid'.  I hope to follow up this wondering with code, but
wanted to get the question out in the open lest someone else already
determined it was a non-starter.

2/ I question why subvolumes are actively avoiding the the device
model.  They are in essence virtual block devices with different
lifetime rules specific to btrfs.  The current behavior of specifying
all members on the mount command line eliminates the ability to query,
via sysfs, if a btrfs subvolume is degraded/failed, or to assemble the
subvolume(s) prior to activating the filesystem.  One scenario that
comes to mind is handling a 4-disk btrfs filesystem with both raid10
and raid6 subvolumes.  Depending on the device discovery order the
user may be able to start all subvolumes in the filesystem in degraded
mode once the right two disks are available, or maybe it's ok to start
the raid6 subvolume early even if that means the raid10 is failed.
Basically, the current model precludes those possibilities and mimics
the dmraid "assume all members are available, auto-assemble everything
at once, and hide virtual block device details from sysfs" model.

3/ The md-raid6 recovery code assumes that there is always at least
two good blocks to perform recovery.  That makes the current minimum
number of raid6 members 4, not 3.  (small nit the btrfs code calls
members 'stripes', in md a stripe of data is a collection of blocks
from all members).

4/ A small issue, there appears to be no way to specify different
raid10/5/6 data layouts, maybe I missed it.  See the --layout option
to mdadm.  It appears the only layout option is the raid level.

Regards,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
