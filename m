From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do more checks in btrfsck
Date: Wed, 07 Jan 2009 15:13:46 -0500
Message-ID: <1231359226.5016.7.camel@think.oraclecorp.com>
References: <4964C5E7.2090205@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4964C5E7.2090205@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 23:10 +0800, Yan Zheng wrote:
> Hello,
> 
> This patch makes btrfsck check more things, including
> directory items, file extents, checksumming, inode link
> counts etc.
> 

This is great work, thanks!  I've pushed it out to the unstable tree.

-chris


