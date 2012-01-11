From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix 251's cp -axT problem
Date: Wed, 11 Jan 2012 06:45:44 -0500
Message-ID: <20120111114544.GE14423@infradead.org>
References: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	Lukas Czerner <lczerner@redhat.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326195560-4434-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 10, 2012 at 07:39:20PM +0800, Liu Bo wrote:
> When I ran xfstests, 251 got failed cause "cp -axT" did not work as wish:
> cp: cannot overwrite directory `/mnt/scratch/1' with non-directory
> 
> With this patch, 251 has passed.

Why would cp give that message with a missing /?

I'm not against putting this in, but I'd like to understand what's going
on.

Lukas, any idea?

