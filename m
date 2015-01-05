Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:45383 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbbAETch (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Jan 2015 14:32:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21674.58885.622263.403070@localhost.localdomain>
Date: Mon, 5 Jan 2015 20:29:09 +0100
From: lutz.euler@freenet.de (Lutz Euler)
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: really fix trim 0 bytes after a device delete
In-Reply-To: <4883936.ZkQeZXYBc4@merkaba>
References: <20644.2272.57892.435731@localhost.localdomain>
	<20644.2675.653732.24816@localhost.localdomain>
	<21672.2859.468940.450115@localhost.localdomain>
	<4883936.ZkQeZXYBc4@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

happy new year to you, too!

[Martin Steigerwald:]
> Happy new year!
> 
> Am Samstag, 3. Januar 2015, 16:30:51 schrieb Lutz Euler:
> > Commit 2cac13e41bf5b99ffc426bd28dfd2248df1dfa67, "fix trim 0 bytes after
> > a device delete", said:
> >   A user reported a bug of btrfs's trim, that is we will trim 0 bytes
> >   after a device delete.
> > The commit didn't attack the root of the problem so did not fix the bug
> > except for a special case.
> > 
> > For block discard, btrfs_trim_fs directly compares the range passed in
> > against the filesystem's objectids. The former is bounded by the sum of
> > the sizes of the devices of the filesystem, the latter is a completely
> > unrelated set of intervals of 64-bit integers. The bug reported occurred
> > as the smallest objectid was larger than the sum of the device sizes.
> > The above mentioned commit only fixed the case where the smallest
> > objectid is nonzero and the largest objectid less than the sum of the
> > device sizes, but it still trims too little if the largest objectid is
> > larger than that, and nothing in the reported situation.
> > 
> > The current mapping between the given range and the objectids is thus
> > clearly broken, so, to fix the bug and as a first step towards a
> > complete solution, simply ignore the range parameter's start and length
> > fields and always trim the whole filesystem. (While this makes it
> > impossible to trim a filesystem only partly, due to the broken mapping
> > this often didn't work anyway.)
> > 
> > V2:
> > - Rebased onto 3.9. (still applies to and works with 3.19-rc2)
> > - Take range->minlen into account.
> > 
> > Reported-by: Lutz Euler <lutz.euler@freenet.de>
> > Signed-off-by: Lutz Euler <lutz.euler@freenet.de>
> 
> Is that the patch you send me for testing?

Yes, it is.

Kind regards,

Lutz

> If so, feel free to add:
> 
> Reported-and-tested-by: Martin Steigerwald <martin@lichtvoll.de>
> 
> If not I can retest with this one.
> 
> Thanks,
> Martin
> 
> > ---
> >  fs/btrfs/extent-tree.c |   25 +++++++++++--------------
> >  1 files changed, 11 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index cfb3cf7..81006c1 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -8824,26 +8824,23 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
> >  	u64 start;
> >  	u64 end;
> >  	u64 trimmed = 0;
> > -	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
> >  	int ret = 0;
> >  
> >  	/*
> > -	 * try to trim all FS space, our block group may start from non-zero.
> > +	 * The range passed in is a subinterval of the interval from 0
> > +	 * to the sum of the sizes of the devices of the filesystem.
> > +	 * The objectid's used in the filesystem can span any set of
> > +	 * subintervals of the interval from 0 to (u64)-1. As there is
> > +	 * neither a simple nor an agreed upon mapping between these
> > +	 * two ranges we ignore the range parameter's start and len
> > +	 * fields and always trim the whole filesystem (that is, only
> > +	 * the free space in allocated chunks).
> >  	 */
> > -	if (range->len == total_bytes)
> > -		cache = btrfs_lookup_first_block_group(fs_info, range->start);
> > -	else
> > -		cache = btrfs_lookup_block_group(fs_info, range->start);
> > +	cache = btrfs_lookup_first_block_group(fs_info, 0);
> >  
> >  	while (cache) {
> > -		if (cache->key.objectid >= (range->start + range->len)) {
> > -			btrfs_put_block_group(cache);
> > -			break;
> > -		}
> > -
> > -		start = max(range->start, cache->key.objectid);
> > -		end = min(range->start + range->len,
> > -				cache->key.objectid + cache->key.offset);
> > +		start = cache->key.objectid;
> > +		end = cache->key.objectid + cache->key.offset;
> >  
> >  		if (end - start >= range->minlen) {
> >  			if (!block_group_cache_done(cache)) {
> > 
> 
> -- 
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
