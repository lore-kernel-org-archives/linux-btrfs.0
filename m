From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New experimental btrfs branch ready for testing
Date: Wed, 3 Jun 2009 13:08:36 -0400
Message-ID: <20090603170836.GE13945@think>
References: <20090601210447.GC3890@think> <20090602132830.GA3914@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090602132830.GA3914@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 02, 2009 at 09:28:30AM -0400, Chris Mason wrote:
> On Mon, Jun 01, 2009 at 05:04:47PM -0400, Chris Mason wrote:
> > Hello everyone,
> > 
> > Yan Zheng has been doing some major surgery to the back references and
> > extent allocation code, tackling bottlenecks in the code that tracks
> > extents.  It scales better with many snapshots and performs better in
> > the common case of no snapshots at all.
> > 
> > THE NEW CODE IS A FORWARD ROLLING DISK FORMAT CHANGE.  This means it is
> > compatible with the current btrfs disk format, but once you mount a
> > filesystem with the new code, it WILL NO LONGER BE MOUNTABLE FROM OLD
> > KERNELS.  Old kernels spit out an error message when you try them on new
> > format filesystems.
> 
> Just a quick note that I'm having some issues with the backward
> compatibility code on 32 bit kernels.  It can still read all the old
> items but it is having problems with creating new backrefs.
> 
> 32bit is working fine on an entirely new format FS, and my 64 bit box
> can read and write the old format FS just fine.  I'm hoping to track
> this one down today, but it would be a good idea to wait if you want to
> try the new code on old filesystems on 32 bit machines.
> 
> If you do hit crashes, please don't immediately reformat your FS if you
> can avoid it.  We should be able to fix most problems people hit.

Looks like Yan Zheng tracked this down yesterday, Jens Axboe bravely
tested out 32bit old format compat again with his laptop.  At this point
I think the new format code is looking pretty stable and it is generally
ready for more testing.

I've rebased the newformat kernel tree to fold in the corruption fixes.
This way if anyone does a git bisect they won't end up on a commit that
can corrupt their FS by accident.  If you've already pulled the
newformat tree, the new commits will conflict with the old.

So, something like this will fix things if you have already pulled the
newformat branch:

git reset --hard v2.6.30-rc7
git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git newformat

If you've made your own commits or pulls other than just btrfs,
different steps will be required.

The btrfs-progs unstable tree was also rebased.

Use git reset --hard ed20f5fc905145a0673097b539442d2a59491e77 on the
progs tree if you've already pulled down the newformat branch.

Happy testing everyone

-chris

