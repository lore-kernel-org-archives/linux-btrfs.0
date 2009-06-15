From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Always update root items for fs trees at commit time
Date: Mon, 15 Jun 2009 09:26:03 -0400
Message-ID: <20090615132603.GB4712@think>
References: <4A364B17.9030609@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A364B17.9030609@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 15, 2009 at 09:22:31PM +0800, Yan Zheng wrote:
> commit_fs_roots skips updating root items for fs trees that aren't modified.
> This is unsafe since relocation code modifies root item's last_snapshot field
> without modifying corresponding fs tree.

Thanks for working on these patches.

This could make commit pretty expensive when there are many snapshots in
place that don't get modified.  Could you please change the balance code
to mark the root to force writeout?

-chris

