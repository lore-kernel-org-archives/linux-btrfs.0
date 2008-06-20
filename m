From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: [PATCH] COW and checksumming ioctls
Date: Fri, 20 Jun 2008 08:01:54 -0600
Message-ID: <485BB852.4060202@gentoo.org>
References: <1213921608.27507.152.camel@BVR-FS.beaverton.ibm.com> <485B3EC5.8090006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mingming <cmm@us.ibm.com>, linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <485B3EC5.8090006@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Zach Brown wrote:
> Hmm.  Do we really want 4 different ioctl commands to turn 2 features on
> and off?  Surely we could have 1 ioctl which updates a bitfield?  Or a
> ioctl that takes an explicit feature enum argument and a boolean which
> indicates that it should be enabled or not?
> 
> (And is ioctl the right interface for this?  maybe it should be xattr
> ops in some defined btrfs string namespace?  I'm just making this up.  I
> feel the the lack of a single comment in the patch, while in keeping
> with the existing precedent in btrfs, leaves a lot of room for wild
> speculation :))

Beyond that, is it really desirable to be able to turn off
checksumming/COW per file?  Or even to be able to do it so easily?

I feel that checksumming is an extremely important feature, and it
scares me even to be able to disable it at all (what if someone
mistakenly does it, and then all of the data is unintentionally
vulnerable?).  But at least if it is only a mount option, the mistake
would have to be at as system level and would be harder to do by accident.

If someone were to turn off checksumming and then turn it back on, I
assume they would lose any continuity of protection that exists if it
stays on, so it would have to be a major and important decision in an
existing filesystem.

						-Joe
