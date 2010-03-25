From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 01/18] btrfs: Remove u64 conversion for PAGE_CACHE_SIZE
Date: Thu, 25 Mar 2010 09:02:31 -0400
Message-ID: <20100325130230.GG6538@think>
References: <4BAB56AE.5040009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BAB56AE.5040009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 25, 2010 at 08:27:26PM +0800, Miao Xie wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> We don't need to convert PAGE_CACHE_SIZE to u64 in bit operation.

For code like this:

u64 size = (some number that doesn't fit in 32 bits)

if (size & (PAGE_CACHE_SIZE - 1)) {
}

The answer should be the same either way.  But if the code gets
switched:

start = size & ~(PAGE_CACHE_SIZE - 1);

Some arches are going to get the wrong answer here.  We had a few bugs
like this early on and I went through and casted everything to be
consistent.  While this patch is correct, I would rather leave the casts
to avoid subtle problems later on as the code changes.

-chris

