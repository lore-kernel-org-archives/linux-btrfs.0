From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Wed, 21 Jan 2009 15:00:42 +1100
Message-ID: <20090121040042.GI10158@disturbed>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090120222019.GB2320@elf.ucw.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2009 at 11:20:19PM +0100, Pavel Machek wrote:
> On Tue 2009-01-20 08:28:29, Christoph Hellwig wrote:
> > On Tue, Jan 20, 2009 at 11:59:44PM +1100, Dave Chinner wrote:
> > > > So far the responses from xfs folks have been disappointing, if you are
> > > > interested in bugreports i can send you some.
> > > 
> > > Sure I am.  It would be good if you could start testing XFS along
> > > with all the other filesystems and report anything you find.
> > 
> > I think that was the issue with the debug builds.  If you do this
> > testing always do it without CONFIG_XFS_DEBUG set as with that option
> > we intentionally panic on detected disk corruptions.
> 
> Uhuh, *_DEBUG options are not supposed to make kernel less
> stable/robust. Should that crashing functionality be guarded with
> command line option or something? ext2 has errors=panic mount
> option...

No, it's a debugging option that is described as:

	"Say N unless you are an XFS developer, or you play one on TV."

Seriously, if you aren't trying to develop XFS stuff then *don't turn it
on*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
