From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix leaf reference cache miss
Date: Wed, 08 Oct 2008 08:59:32 -0400
Message-ID: <1223470772.7014.4.camel@think.oraclecorp.com>
References: <48EC6285.604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48EC6285.604@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-08 at 15:34 +0800, Yan Zheng wrote:
> Due to the optimization for truncate, tree leaves only contain
> checksum can be deleted without being COW'ed first. This causes
> reference cache misses. The way to fix the miss is create cache
> entries for tree leaves only contain checksum.
> 
> This patch also fixes a -EEXIST issue in shared reference cache.
> 
Whoops! thanks Yan.

-chris


