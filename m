From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] Btrfs: load the key from the dir item in readdir into a fake dentry
Date: Thu, 26 May 2011 22:03:38 +0200
Message-ID: <20110526200338.GH4065@one.firstfloor.org>
References: <1306421316-1504-2-git-send-email-josef@redhat.com> <m2fwo19tzp.fsf@firstfloor.org> <4DDEA3D2.3080907@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDEA3D2.3080907@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2011 at 03:02:42PM -0400, Josef Bacik wrote:
> +	/*
> +	 * If this dentry needs lookup, don't set the referenced flag so that it
> +	 * is more likely to be cleaned up by the dcache shrinker in case of
> +	 * memory pressure.
> +	 */
> +	if (!d_need_lookup(dentry))
> +		dentry->d_flags |= DCACHE_REFERENCED;

No it doesn't at all. The allocation will just push everything else
out.

Really you cannot view this by only looking at the dcache.
You have to look at the complete VM behaviour. All the caches
and the other memory interact.
> 
> 
> > d_alloc uses a normal GFP_KERNEL, which is quite in appropiate for this.
> > 
> > It should at least reclaim and probably more, but even then it's
> > risky.
> > 
> 
> Ah yeah I guess I should have probably used GFP_KERNEL.  Sorry about that,

GFP_KERNEL is already used, but it's wrong. I'm not sure any
of the existing GFP_* flags will give you the semantics you
need in fact. The new flag Minchan added for readahead may come
near, but even that is probably not enough.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
