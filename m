From: Dan Carpenter <error27@gmail.com>
Subject: Re: [patch 11/11] btrfs: The file argument for fsync() is never
	null
Date: Mon, 14 Jun 2010 22:49:59 +0200
Message-ID: <20100614204959.GA5483@bicker>
References: <20100529094907.GL5483@bicker> <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006142207.25930.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> addr2line showed me exact this change you made.
> 
> It happend with a linux-2.6.34 with the latest btrfs-changes on top.
> 

Yes.  It used to be possible in 2.6.34 to get have file be null but in
2.6.35 it's not.  Did you pull in 7ea8085910e: "drop unused dentry 
argument to ->fsync"?  That introduces a dereference at the start of the
function.

Sorry about this.  I didn't take back porting into consideration.

regards,
dan carpenter

