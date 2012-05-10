From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
Date: Thu, 10 May 2012 10:23:28 +0200
Message-ID: <4FAB7B00.4090302@jan-o-sch.net>
References: <1333656543-4843-1-git-send-email-mfasheh@suse.de> <1333656543-4843-4-git-send-email-mfasheh@suse.de> <4F871808.3050309@jan-o-sch.net> <20120508225739.GW17950@wotan.suse.de> <20120509170228.GA4025@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509170228.GA4025@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2012 at 19:02 (+0200), Chris Mason wrote:
>>>> +
>>>> +	while (1) {
>>>> +		ret = btrfs_find_one_extref(fs_root, inum, offset, path, &iref2,
>>>> +					    &offset);
>>>> +		if (ret < 0)
>>>> +			break;
>>>> +		if (ret) {
>>>> +			ret = found ? 0 : -ENOENT;
>>>> +			break;
>>>> +		}
>>>> +		++found;
>>>> +
>>>> +		slot = path->slots[0];
>>>> +		eb = path->nodes[0];
>>>> +		/* make sure we can use eb after releasing the path */
>>>> +		atomic_inc(&eb->refs);
>>>
>>> You need a blocking read lock here, too. Grab it before releasing the path.
> 
> If you're calling btrfs_search_slot, it will give you a blocking lock
> on the leaf.  If you set path->leave_spinning before the call, you'll
> have a spinning lock on the leaf.
> 
> If you unlock a block that you got from a path (like eb =
> path->nodes[0]), the path structure has a flag for each level that
> indicates if that block was locked or not.  See btrfs_release_path().
> So, don't fiddle the locks without fiddling the paths.
> 
> You can switch from spinning to/from blocking without touching the path, it
> figures that out.

Note that we're releasing the path shortly after. My suggestion was to
grab an *additional* read lock after atomic_inc(&eb->refs) (probably
better extent_buffer_get(eb)) and before btrfs_path_release().

An alternative would be to set path->locks[0] to NULL, which would
btrfs_release_path prevent from unlocking it, kidnapping its lock for
our purpose. But I much prefer the open coded solution.

-Jan
