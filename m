From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags V2
Date: Thu, 26 May 2011 11:35:14 +0100
Message-ID: <20110526103514.GC11521@ZenIV.linux.org.uk>
References: <1305913471-3150-1-git-send-email-josef@redhat.com>
 <20110522021130.GI19987@ZenIV.linux.org.uk>
 <4DDA8793.3010906@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, hch@lst.de
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDA8793.3010906@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 23, 2011 at 12:13:07PM -0400, Josef Bacik wrote:
> On 05/21/2011 10:11 PM, Al Viro wrote:
> > On Fri, May 20, 2011 at 01:44:30PM -0400, Josef Bacik wrote:
> >> +		if (unlikely(d_need_lookup(dentry))) {
> >> +			if (nameidata_dentry_drop_rcu(nd, dentry))
> >> +				return -ECHILD;
> >> +			dput(dentry);
> >> +			dentry = NULL;
> >> +			goto retry;
> > 
> > Yecchhh...  How about simple goto unlazy; here instead and doing the rest
> > there?  Especially since you have the same kind of thing elsewhere in the
> > same sucker.  It had been bloody painful to untangle that thing; let's not
> > add to the rat's nest that still remains...
> 
> This is where I was a little confused, which is why I added this code.  It
> seems that having goto unlazy; will mean that we will come down to this
> section
> 
> if (unlikely(status  <= 0 )) {
> 	if (status < 0) {
> 		dput(dentry);
> 		return status;
> 	}
>         if (!d_invalidate(dentry)) {
> 		dput(dentry);
> 		dentry = NULL;
> 		need_reval = 1;
> 		goto retry;
> 	}
> }
> 
> and d_invalidate will unhash us so we won't find our new dentry in the cache
> which makes this whole exercise useless.  Is there a different way you'd
> like
> this cleaned up?  Thanks,

Not *into* the loop; just before the beginning of that loop.  IOW, put
	if (dentry && unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP)) {
		dput(dentry);
		dentry = NULL;
	}
just before retry: instead of doing it in non-lazy branch.  Voila - your
code in the lazy branch becomes
	if (unlikely(dentry->d_flags & DCACHE_NEED_LOOKUP))
		goto unlazy;
and that's it.  Can you resend it with such modifications?

ObMemoryPressureIssues: I really hoped to get Dave's patch (per-sb shrinkers)
in that cycle, but it'll probably have to wait for the next one...
