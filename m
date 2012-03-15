From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix deadlock during allocating chunks
Date: Thu, 15 Mar 2012 16:08:03 +0100
Message-ID: <20120315150737.GE6474@pambianco.com>
References: <1331723829-25226-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1331723829-25226-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 14, 2012 at 07:17:09PM +0800, Liu Bo wrote:
> This deadlock comes from xfstests 251.
> 
> We'll hold the chunk_mutex throughout the whole of a chunk allocation.
> But if we find that we've used up system chunk space, we need to allocate a
> new system chunk, but this will lead to a recursion of chunk allocation and end
> up with a deadlock on chunk_mutex.
> So instead we need to allocate the system chunk first if we find we're in ENOSPC.

I'm using this patch without problem since you published it (compressed
/home with hourly snapshot delete/creation).

Thanks a lot for your work,
Andrea
