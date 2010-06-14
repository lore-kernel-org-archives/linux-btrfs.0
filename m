From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 11/11] btrfs: The file argument for fsync() is never null
Date: Mon, 14 Jun 2010 22:58:49 +0200
Message-ID: <20100614205849.GA26828@lst.de>
References: <20100529094907.GL5483@bicker> <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <error27@gmail.com>, linux-btrfs@vger.kernel.org,
	Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 14, 2010 at 10:07:23PM +0200, Johannes Hirte wrote:
> I think you're wrong here. I've run into a kernel null pointer dereference at 
> this point with a NFS exported btrfs filesystem:

Looks like you've applied the patch to a far too old kernel.  It can't
be NULL for quite a while already.

If you're testing patches posted to the mailinglists always make sure
you have a recent enough kernel.

