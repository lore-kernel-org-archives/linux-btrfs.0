From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 20 Jan 2009 08:28:29 -0500
Message-ID: <20090120132829.GA27429@infradead.org>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sesterhenn <snakebyte@gmx.de>, Pavel Machek <pavel@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090120125944.GC10158@disturbed>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2009 at 11:59:44PM +1100, Dave Chinner wrote:
> > So far the responses from xfs folks have been disappointing, if you are
> > interested in bugreports i can send you some.
> 
> Sure I am.  It would be good if you could start testing XFS along
> with all the other filesystems and report anything you find.

I think that was the issue with the debug builds.  If you do this
testing always do it without CONFIG_XFS_DEBUG set as with that option
we intentionally panic on detected disk corruptions.

