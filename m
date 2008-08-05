From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] nodatacow fix
Date: Tue, 05 Aug 2008 10:19:50 -0400
Message-ID: <1217945990.7611.72.camel@think.oraclecorp.com>
References: <48986070.9010900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48986070.9010900@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-08-05 at 22:15 +0800, Yan Zheng wrote:
> Hello,
> 
> This patch adapts nodatacow code for the new data ordered code. Ordered
> extents are used in all cases. It avoid writepage_start_hook kicking off
> nodatacow IO contiguously. This patch also makes btrfs wait for ordered
> extents before creating snapshots. It's important for nodatcow IO since
> creating snapshots invalidates the results of reference checking.
> 

Thanks Yan!  Can you please change this to make it only wait for
nodatacow ordered extents?

-chris


