From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] btrfs: prevent heap corruption in
	btrfs_ioctl_space_info()
Date: Wed, 9 Feb 2011 10:51:33 -0500
Message-ID: <20110209155130.GA2564@localhost.localdomain>
References: <1297260766.2327.40.camel@dan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, security@kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
To: Dan Rosenberg <drosenberg@vsecurity.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297260766.2327.40.camel@dan>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 09, 2011 at 09:12:46AM -0500, Dan Rosenberg wrote:
> Commit bf5fc093c5b625e4259203f1cee7ca73488a5620 refactored
> btrfs_ioctl_space_info() and introduced several security issues.
> 
> space_args.space_slots is an unsigned 64-bit type controlled by a
> possibly unprivileged caller.  The comparison as a signed int type
> allows providing values that are treated as negative and cause the
> subsequent allocation size calculation to wrap, or be truncated to 0.
> By providing a size that's truncated to 0, kmalloc() will return
> ZERO_SIZE_PTR.  It's also possible to provide a value smaller than the
> slot count.  The subsequent loop ignores the allocation size when
> copying data in, resulting in a heap overflow or write to ZERO_SIZE_PTR.
> 
> The fix changes the slot count type and comparison typecast to u64,
> which prevents truncation or signedness errors, and also ensures that we
> don't copy more data than we've allocated in the subsequent loop.  Note
> that zero-size allocations are no longer possible since there is already
> an explicit check for space_args.space_slots being 0 and truncation of
> this value is no longer an issue.
> 
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
