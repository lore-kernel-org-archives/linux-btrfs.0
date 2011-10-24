From: Josef Bacik <josef@redhat.com>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Mon, 24 Oct 2011 15:51:47 -0400
Message-ID: <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net> <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com> <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Brunner <chb@muc.de>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2011 at 10:06:49AM -0700, Sage Weil wrote:
> [adding linux-btrfs to cc]
> 
> Josef, Chris, any ideas on the below issues?
> 
> On Mon, 24 Oct 2011, Christian Brunner wrote:
> > Thanks for explaining this. I don't have any objections against btrfs
> > as a osd filesystem. Even the fact that there is no btrfs-fsck doesn't
> > scare me, since I can use the ceph replication to recover a lost
> > btrfs-filesystem. The only problem I have is, that btrfs is not stable
> > on our side and I wonder what you are doing to make it work. (Maybe
> > it's related to the load pattern of using ceph as a backend store for
> > qemu).
> > 
> > Here is a list of the btrfs problems I'm having:
> > 
> > - When I run ceph with the default configuration (btrfs snaps enabled)
> > I can see a rapid increase in Disk-I/O after a few hours of uptime.
> > Btrfs-cleaner is using more and more time in
> > btrfs_clean_old_snapshots().
> 
> In theory, there shouldn't be any significant difference between taking a 
> snapshot and removing it a few commits later, and the prior root refs that 
> btrfs holds on to internally until the new commit is complete.  That's 
> clearly not quite the case, though.
> 
> In any case, we're going to try to reproduce this issue in our 
> environment.
> 

I've noticed this problem too, clean_old_snapshots is taking quite a while in
cases where it really shouldn't.  I will see if I can come up with a reproducer
that doesn't require setting up ceph ;).

> > - When I run ceph with btrfs snaps disabled, the situation is getting
> > slightly better. I can run an OSD for about 3 days without problems,
> > but then again the load increases. This time, I can see that the
> > ceph-osd (blkdev_issue_flush) and btrfs-endio-wri are doing more work
> > than usual.
> 
> FYI in this scenario you're exposed to the same journal replay issues that 
> ext4 and XFS are.  The btrfs workload that ceph is generating will also 
> not be all that special, though, so this problem shouldn't be unique to 
> ceph.
> 

Can you get sysrq+w when this happens?  I'd like to see what btrfs-endio-write
is up to.

> > Another thing is that I'm seeing a WARNING: at fs/btrfs/inode.c:2114
> > from time to time. Maybe it's related to the performance issues, but
> > seems to be able to verify this.
> 
> I haven't seen this yet with the latest stuff from Josef, but others have.  
> Josef, is there any information we can provide to help track it down?
>

Actually this would show up in 2 cases, I fixed the one most people hit with my
earlier stuff and then fixed the other one more recently, hopefully it will be
fixed in 3.2.  A full backtrace would be nice so I can figure out which one it
is you are hitting.
 
> > It's really sad to see, that ceph performance and stability is
> > suffering that much from the underlying filesystems and that this
> > hasn't changed over the last months.
> 
> We don't have anyone internally working on btrfs at the moment, and are 
> still struggling to hire experienced kernel/fs people.  Josef has been 
> very helpful with tracking these issues down, but he hass responsibilities 
> beyond just the Ceph related issues.  Progress is slow, but we are 
> working on it!

I'm open to offers ;).  These things are being hit by people all over the place,
but it's hard for me to reproduce, especially since most of the reports are "run
X server for Y days and wait for it to start sucking."  I will try and get a box
setup that I can let stress.sh run on for a few days to see if I can make some
of this stuff come out to play with me, but unfortunately I end up having to
debug these kind of things over email, which means they get a whole lot of
nowhere.  Thanks,

Josef
