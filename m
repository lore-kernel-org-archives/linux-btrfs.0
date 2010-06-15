From: Ed Tomlinson <edt@aei.ca>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.35
Date: Tue, 15 Jun 2010 07:17:19 -0400
Message-ID: <201006150717.19886.edt@aei.ca>
References: <20100611193731.GA3018@think> <201006141524.20752.edt@aei.ca> <20100615004735.GR18266@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100615004735.GR18266@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 14 June 2010 20:47:35 Chris Mason wrote:
> On Mon, Jun 14, 2010 at 03:24:19PM -0400, Ed Tomlinson wrote:
> > On Friday 11 June 2010 15:37:31 Chris Mason wrote:
> > > Hello everyone,
> > > 
> > > The master branch of the btrfs-unstable tree is a collection of fixes
> > > and cleanups, including two btrfs regressions from rc1:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master
> > > 
> > > One is an freeing blocks on an FS converted from ext34 to btrfs,
> > > and the other is a fallocate fix.
> > > 
> > > The rest are the usual small bug fixes.
> > 
> > Looks like this still misses any fix for the oops I reported May 8th in thread:
> > "[OPPS] btrfs on 33-3 with latest from btrfs-unstable.git master"
> > 
> > Any chance this could be looked into?  I've kept the fs just in case.
> 
> The oops shows a crc failure and then we were not able to read the tree
> block.  Yan Zheng is working on an fsck that can repair things now.
> Until then the best I can do is help copy things off.
> 
> Would you rather save the FS to test fsck?

I can hang on to the FS for a while longer.  One interesting point.  The FS
has both both meta-data and data mirroring enabled.  I gather the oops is
implying that both versions are corrupt.  Btw the fs problem occured after
heavy vm activity caused by running too many kvm(s).

Thanks
Ed
