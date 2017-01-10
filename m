Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37850 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdAJBv4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jan 2017 20:51:56 -0500
Date: Mon, 9 Jan 2017 17:46:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Omar Sandoval <osandov@osandov.com>, Eric Sandeen <sandeen@redhat.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [RFC] Converging userspace and kernel code
Message-ID: <20170110014633.GA14032@birch.djwong.org>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <65341974-d15f-408c-abad-98c2a5bb8743@cn.fujitsu.com>
 <4d1d233a-1002-169e-ec9b-14df3b1af86c@redhat.com>
 <20170109213405.GB29762@vader.DHCP.thefacebook.com>
 <a6acab91-9c87-a579-4070-fb603ef3542d@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a6acab91-9c87-a579-4070-fb603ef3542d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2017 at 04:38:22PM -0500, Jeff Mahoney wrote:
> On 1/9/17 4:34 PM, Omar Sandoval wrote:
> > On Mon, Jan 09, 2017 at 09:31:39AM -0600, Eric Sandeen wrote:
> >> On 1/8/17 8:11 PM, Qu Wenruo wrote:
> >>>
> >>>
> >>> At 01/08/2017 09:16 PM, Goldwyn Rodrigues wrote:
> >>>>
> >>>> 1. Motivation
> >>>> While fixing user space tools for btrfs-progs, I found a couple of bugs
> >>>> which are already solved in kernel space but were not ported to user
> >>>> space. User space is a little ignored when it comes to fixing bugs in
> >>>> the core functionality. XFS developers have already performed this and
> >>>> the userspace and kernel code walks in lockstep for libxfs.

Eh, I've wrangled the two other FSes mentioned, so I guess I can
reiterate for a while too. :P

Yes, it's very nice to be able to apply kernel patches of core libxfs
code onto xfsprogs and have it work.  It's /annoying/ to have to it sort
of work but with a lot of fuzz and somewhere midway through the apply
loop the whole thing crashes and burns due to some minor merge conflict.

(It's not so bad for libext2fs since at least it's a totally different
implementation.  But I'll get to that later.)

The core XFS algorithms (btrees, space management, inodes, directories,
attributes, on-disk formats, and some of the log stuff) live in
libxfs/xfs_*.[ch].   The stuff that sits between those algorithms and
the kernel all live in fs/xfs/*.[ch], and the stuff between the
algorithms and the C library live in libxfs/ and include/ in files that
don't start with "xfs_".  As I understand it, the dividing line is that
core algorithms are in libxfs, and everything else isn't.

> >>> Personally speaking, I'm not a fan of re-using kernel code in
> >>> btrfs-progs.
> >>
> >> But it already does re-use kernel code, it's just that the re-use is
> >> extremely stale, with unfixed bugs in both directions as a result
> >> (at least last time I looked.)
> >>
> >>> In fact, in btrfs-progs, we don't need a lot of kernel facilities,
> >>> like page/VFS/lock(btrfs-progs works in single thread under most
> >>> case).
> >>>
> >>> And that should make btrfs-progs easier to maintain.

The way I look at it is that there's core algorithms and on-disk format
stuff that can be the same wherever it is, and this code ought to be
kept in sync so that bugfixes and features end up the same in both.
The 'core algorithms' library can talk to the same interfaces in the
kernel and userspace, even though the implementations are different, or,
as Eric points out, even #define'd away.

> >> But as Goldwyn already pointed out, many bugs have gone un-fixed
> >> in userspace, in code which was forked long ago from kernelspace.

Ick.

> >> For things like locking it's trivial to define that away.
> >>
> >> xfsprogs does i.e. -
> >>
> >> /* miscellaneous kernel routines not in user space */
> >> #define down_read(a)            ((void) 0)
> >> #define up_read(a)              ((void) 0)
> >> #define spin_lock_init(a)       ((void) 0)
> >> #define spin_lock(a)            ((void) 0)
> >> #define spin_unlock(a)          ((void) 0)
> >> #define likely(x)               (x)
> >> #define unlikely(x)             (x)
> >> #define rcu_read_lock()         ((void) 0)
> >> #define rcu_read_unlock()       ((void) 0)
> >> #define WARN_ON_ONCE(expr)      ((void) 0)
> >>
> >>
> >>> Furthermore, there are cases while kernel is doing things wrong while
> >>> btrfs-progs does it right.
> >>
> >> All the more reason to sync it up, fixes should always be in both
> >> places, right?
> >>
> >> I had looked at this a few years ago, and started trying to sync things
> >> up, but got daunted and busy and never completed anything.  :(  I sent
> >> a few fixups back in April 2013 to get things /slightly/ closer.
> >>
> >> The libxfs sync in xfs has borne fruit; I'm of the opinion that similar
> >> work would help btrfs too, though it can be a long road.
> >>
> >> (e2fsprogs has gone the other way, and has a completely separate
> >> re-implementation in userspace; it works, I guess, but I have to say
> >> that I really like the code commonality in xfs.)

Having worked on ext* also I will say that as far as finding and
resolving ambiguities in the on-disk specification, having two
independent and maintained implementations of ext4 is wonderful.

Unfortunately, it's /really/ expensive to engineer both, and there are
plenty of small behavioral discrepancies between the two.  In your free
time, run xfstests against fuse2fs and regular ext4. ;)

> > Yup, I also think we should be going in the XFS direction. It's a big
> > maintenance burden to have to worry about the code in two places. (E.g.,
> > the biggest reason I haven't gotten around to implementing full free
> > space tree support in btrfs-progs is that it's such a pain in the ass to
> > port new kernel code to the outdated progs code.)

Yeah.  That sucked for the (very) few times I had to do that for
xfsprogs.

> Another advantage is that we will be able to at least write test cases
> for the shared code that can be run entirely in userspace.  That
> obviously doesn't address a huge class of potential problems, but it's
> better than what we have now.
> 
> > As far as I know, the only reason it hasn't happened yet is that no one
> > has agreed to do it, and we're all just hoping someone else will take
> > care of it.
> 
> Yeah, I think that's exactly it.  Having one shared source base is going
> to be easier to maintain for everyone.  The longer we wait to do it, the
> more it will diverge.  This is a topic we've been discussing in our
> team's weekly call for the past few weeks.  I think Goldwyn is granting
> that last wish. :)

I hope you succeed.

--D

> 
> -Jeff
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> 



