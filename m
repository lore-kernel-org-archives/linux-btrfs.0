From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] Btrfs: load the key from the dir item in readdir into a fake dentry
Date: Thu, 26 May 2011 14:45:32 -0600
Message-ID: <F08E6AE7-4C97-49AB-A99C-FE22D099FA05@dilger.ca>
References: <1306421316-1504-2-git-send-email-josef@redhat.com> <m2fwo19tzp.fsf@firstfloor.org> <4DDEA3D2.3080907@redhat.com> <20110526200338.GH4065@one.firstfloor.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110526200338.GH4065@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On May 26, 2011, at 14:03, Andi Kleen wrote:
> On Thu, May 26, 2011 at 03:02:42PM -0400, Josef Bacik wrote:
>> +	/*
>> +	 * If this dentry needs lookup, don't set the referenced flag so that it
>> +	 * is more likely to be cleaned up by the dcache shrinker in case of
>> +	 * memory pressure.
>> +	 */
>> +	if (!d_need_lookup(dentry))
>> +		dentry->d_flags |= DCACHE_REFERENCED;
> 
> No it doesn't at all. The allocation will just push everything else
> out.
> 
> Really you cannot view this by only looking at the dcache.
> You have to look at the complete VM behaviour. All the caches
> and the other memory interact.

Even without this patch, if you are doing "find /" there will be considerable memory pressure from all of the pages that are accessed by readdir(), and to a lesser extent the directory dentry/inode entries.  I'm not sure whether the issue you raise is going to be significant in the end or not.


Taking this development a bit further, I've long thought it would be quite interesting if these dcache entries could be linked into a readdir-ordered linked list, and then discard the actual directory pages from cache entirely.  This would potentially allow later readdir operations to work just by walking the readdir-ordered linked list and not touching the page cache at all.

Since normal operations like "ls -l" currently instantiate both a pagecache for readdir, and a dentry for each dirent, it could potentially even reduce memory if there was no a need to keep the directory pages in cache anymore.

>>> d_alloc uses a normal GFP_KERNEL, which is quite in appropiate for this.
>>> 
>>> It should at least reclaim and probably more, but even then it's
>>> risky.
>>> 
>> 
>> Ah yeah I guess I should have probably used GFP_KERNEL.  Sorry about that,
> 
> GFP_KERNEL is already used, but it's wrong. I'm not sure any
> of the existing GFP_* flags will give you the semantics you
> need in fact. The new flag Minchan added for readahead may come
> near, but even that is probably not enough.
> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





