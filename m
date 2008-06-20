From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 09:58:12 -0400
Message-ID: <20080620135812.GB3224@unused.rdu.redhat.com>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com> <485BB852.4060202@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zach Brown <zach.brown@oracle.com>, Mingming <cmm@us.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485BB852.4060202@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 20, 2008 at 08:01:54AM -0600, Joe Peterson wrote:
> Zach Brown wrote:
> > Hmm.  Do we really want 4 different ioctl commands to turn 2 features on
> > and off?  Surely we could have 1 ioctl which updates a bitfield?  Or a
> > ioctl that takes an explicit feature enum argument and a boolean which
> > indicates that it should be enabled or not?
> > 
> > (And is ioctl the right interface for this?  maybe it should be xattr
> > ops in some defined btrfs string namespace?  I'm just making this up.  I
> > feel the the lack of a single comment in the patch, while in keeping
> > with the existing precedent in btrfs, leaves a lot of room for wild
> > speculation :))
> 
> Beyond that, is it really desirable to be able to turn off
> checksumming/COW per file?  Or even to be able to do it so easily?
>

Database apps that do their own complicated stuff to make sure everything makes
it to the disk properly who dont want the extra overhead of checksumming.
 
> I feel that checksumming is an extremely important feature, and it
> scares me even to be able to disable it at all (what if someone
> mistakenly does it, and then all of the data is unintentionally
> vulnerable?).  But at least if it is only a mount option, the mistake
> would have to be at as system level and would be harder to do by accident.
> 

What if somebody logs in as root and does an rm -rf?  I'm not thinking that
running the command to disable checksumming on a file will be something that
gets run often by accident, but even if it does the mantra of linux in general
has never been "dont let users do something because some idiot could screw it
all up."

> If someone were to turn off checksumming and then turn it back on, I
> assume they would lose any continuity of protection that exists if it
> stays on, so it would have to be a major and important decision in an
> existing filesystem.
>

I don't really understand the above objection.  Checksumming doesn't make
everything magically protected, just makes it easier to catch when problems are
happening.  I don't see how having it off then turning it on would cause any
sorts of issues.

Josef
