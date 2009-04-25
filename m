From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION
Date: Sat, 25 Apr 2009 21:13:51 +0200
Message-ID: <874owclf68.fsf@basil.nowhere.org>
References: <20090417083741.GA14933@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090417083741.GA14933@lst.de> (Christoph Hellwig's message of "Fri, 17 Apr 2009 10:37:41 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> Add support for the standard attributes set via chattr and read vis
> lsattr.  Currently we store the attributes in the flags value in
> the btrfs inode, but I wonder whether we should split it into two so
> that we don't have to keep converting between the two formats.

The code would be nicer/shorter if you used tables for the flags and 
loops instead of open coding everything. 

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
