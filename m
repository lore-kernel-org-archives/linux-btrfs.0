From: Harik <harik.attar@gmail.com>
Subject: Re: [PATCH] btrfs: return EXDEV when linking from different subvolumes
Date: Tue, 29 Mar 2011 19:26:15 -0400
Message-ID: <AANLkTi=E2jjHicuTZMZsFk_py+RiiWFsffS9+b_=ht8f@mail.gmail.com>
References: <20110322172026.GO1703@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110322172026.GO1703@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2011 at 1:20 PM, Mark Fasheh <mfasheh@suse.com> wrote:
> btrfs_link returns EPERM if a cross-subvolume link is attempted.
>
> However, in this case I believe EXDEV to be the more appropriate value.
> From the link(2) man page:

This makes makes sense, that's the behavior link(2) normally returns.
However, ln(1) doesn't attempt
the link at all across separate filesystems - it checks fstat(...
.st_dev) on the source an destination.  On
suvolumes, that's the same.    It's a slight userspace difference and
I'm not sure it matters.

However, what stops hardlinks across subvolumes?  I understand that
when you delete a subvolume
you'll have to recurse through to decrease the link count and possibly
drop the inode, but Isn't there a
scan going on already for the CoW blocks created by snapshot?   What's
the difference between a hardlink
made across subvolumes and a hardlink cloned when a snapshot is made?

I ask because I hit that when sorting 10 years of downloads/camera
offloads/documents etc and I wanted
to not duplicate the enormous amount of storage into the new volume.
I ended up just biting the bullet and
duplicating 250gb - I've got an unfortunate "filesystem as it was"
backup subvolume which will retain the blocks
even if the current /home is cleaned up.   As a workaround I could
find huge files and delete them on the backup, but
it would seem that using link(2) to tell btrfs that these blocks will
be the same makes it trivial to do from userspace.


Addendum:  BTRFS subvolumes:
/sorted
/home-as-it-was
/home (pruned lost but valuable files)
(daily snapshots of /sorted and /home)

home-as-it-was was made by using rsync on /home to /home-as-it-was,
/home was a snapshot, and /sorted was created as it's own subvolume.
