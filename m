From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Add ioctl to set per file 'compress' flag
Date: Mon, 15 Jun 2009 09:24:25 -0400
Message-ID: <20090615132424.GA8621@infradead.org>
References: <4A3305B9.30700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	"gud@ksu.edu" <gud@ksu.edu>
To: Amit Gud <amitgud@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A3305B9.30700@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2009 at 06:49:45PM -0700, Amit Gud wrote:
> 
> An ioctl is needed to set compress flag (i.e. clear
> BTRFS_INODE_NOCOMPRESS flag) on per file basis. This patch adds that.
> 
> Introduces a generic function to be used by subsequent patches.

It's probably a better idea to fit these into the existing per-inode
flags.  This will need some coordination with Ted on how to re-use
the existing compression flags if at all and where to fit the new
flags in the numerical namespaces.

