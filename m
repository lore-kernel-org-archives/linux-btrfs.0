From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix race between allocate and release extent
 buffer.
Date: Thu, 4 Feb 2010 07:23:59 -0500
Message-ID: <20100204122359.GA14622@think>
References: <4B6A8980.206@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B6A8980.206@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 04, 2010 at 04:46:56PM +0800, Yan, Zheng wrote:
> Increase extent buffer's reference count while holding the lock.
> Otherwise it can race with try_release_extent_buffer.

Thanks, I'll get this in for today's pull.

-chris
