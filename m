From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Prevent btrfsck to run on mounted filesystems
Date: Fri, 30 Oct 2009 09:05:10 -0400
Message-ID: <20091030130510.GD2750@think>
References: <200910292152.15564.lists-receive@programmierforen.de>
 <20091030050243.GA17714@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Drebes <lists-receive@programmierforen.de>,
	linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091030050243.GA17714@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2009 at 01:02:44AM -0400, Christoph Hellwig wrote:
> On Thu, Oct 29, 2009 at 09:52:15PM +0100, Andi Drebes wrote:
> > As recently discussed on the list, btrfsck should only be run on unmounted filesystems. This patch adds a short check for the mount status at the beginning of btrfsck. If the FS is mounted, the program aborts showing an error message.
> 
> Just open the nodes with O_EXCL and you'll get all the checking for
> free.  Also make sure that for a pure, read-only checks instead of a
> repair to allow running on at least a read-only mounted filesystem.
> 

Thanks for working on this patch Andi.

In this case O_EXCL is going to be more accurate just because the
mounted check doesn't cover every disk in the FS.  For now btrfsck
doesn't really give consistent results even readonly on a mounted
filesystem.  We should prevent it with a message just to prevent
confusion.

-chris

