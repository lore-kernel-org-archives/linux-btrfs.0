From: Theodore Tso <tytso@mit.edu>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Fri, 12 Jun 2009 19:19:03 -0400
Message-ID: <20090612231903.GE24336@mit.edu>
References: <20090611204456.GA3834@think> <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0906121450530.3237@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2009 at 02:55:33PM -0700, Linus Torvalds wrote:
> On Thu, 11 Jun 2009, Chris Mason wrote:
> > 
> > Existing filesystems will be upgraded to the new format on the first
> > mount.  All of your old data will still be there and still work
> > properly, but I strongly recommend a full backup before going to the new
> > code.
> 
> Auugh.
> 
> This is horrible. I just screwed up my system by booting a kernel on this: 
> it worked beatifully, but due to other reasons I then wanted to bisect a 
> totally unrelated issue. While having _totally_ forgotten about this 
> issue, even if I was technically aware of it.
> 
> .. so I installed a new kernel, and now it won't boot due to "couldn't 
> mount because of unsupported optional features (1)". In fact, I have no 
> kernel available on that system that will boot, since my normal "safe" 
> fall-back kernels are all distro kernels that can't boot this either.

We learned this lesson the hard way with ext3, a long time ago,
although occasionally we've had to relearn it along the way.  The
normal failure mode is that some user is still using some ancient
distribution, (say, Red Hat 8), and for some reason they boot using a
Fedora Rescue CD, and are really annoyed when the filesystem is no
longer mountable using the 2.4 kernel that comes with their ancient
distribution.

So my policy at least with ext4 is to *never* add any new patches were
the kernel automatically adds some new feature to the compatibility
bitmasks.  The user should have to explicitly and manually use a
userspace program (i.e., tune2fs) to add some new feature.  At least
initially we had some cases where ext4 would automatically add some
new feature flag thanks to a mount option, but I believe we've gotten
rid of all of those cases.

I'd suggest that btrfs follow the same strategy; yeah, it means you
have to keep more backwards compatibility code for longer, but as
btrfs matures, it'll definitely be a Good Thing.

					- Ted
