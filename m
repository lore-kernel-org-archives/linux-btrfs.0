Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32987 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbIKAwK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 20:52:10 -0400
Received: by pacex6 with SMTP id ex6so58099805pac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 17:52:09 -0700 (PDT)
Date: Thu, 10 Sep 2015 17:52:07 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 9/9] Btrfs: add free space tree mount option
Message-ID: <20150911005207.GA7855@mew>
References: <cover.1441309178.git.osandov@fb.com>
 <de086134d128aad13d16b2aabc72918d7ec7637e.1441309178.git.osandov@fb.com>
 <20150909120023.GF8891@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150909120023.GF8891@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 09, 2015 at 02:00:23PM +0200, David Sterba wrote:
> On Thu, Sep 03, 2015 at 12:44:27PM -0700, Omar Sandoval wrote:
> > Now we can finally hook up everything so we can actually use free space
> > tree. On the first mount with the free_space_tree mount option, the free
> > space tree will be created and the FREE_SPACE_TREE read-only compat bit
> > will be set. Any time the filesystem is mounted from then on, we will
> > use the free space tree.
> > 
> > Having both the free space cache and free space trees enabled is
> > nonsense, so we don't allow that to happen. Since mkfs sets the
> > superblock cache generation to -1, this means that the filesystem will
> > have to be mounted with nospace_cache,free_space_tree to create the free
> > space trees on first mount. Once the FREE_SPACE_TREE bit is set, the
> > cache generation is ignored when mounting. This is all a little more
> > complicated than would be ideal, but at some point we can presumably
> > make the free space tree the default and stop setting the cache
> > generation in mkfs.
> 
> I have objections against introducing another options to do something
> with space cache. As you write, it does not make sens to have
> 'space_cache' and 'free_space_tree' enabled, and I agree. The b-tree
> approach is an "implementation detail", an improved version of space
> caching.
> 
> Because of that I propose to do the following:
> 
> * use space_cache mount option, and add a value denoting the used
>   implementation, eg. space_cache=btree or space_cache=v2 etc
> 
> * keep space_cache for backward compatibility for the current
>   implementaion
> 
> * clear_cache should reset state for both
> 
> * nospace_cache prevents using any of the two versions of space cache

Okay, I like the idea of calling this space_cache=v2 and allowing
clear_cache to clear the free space tree just in case. However, the free
space tree doesn't use a cache generation like the old free space cache,
so once it's created, we can't ever ignore it, so for nospace_cache, the
best we could do would be to fail the mount (unless clear_cache is also
set). The other option would be to add something like the cache
generation for the free space tree, but I'd rather not do that since
fixing an out-of-date free space tree is a little more involved than
with the old cache (at that point, we might as well clear the tree and
redo it all over again). What do you think of that? Is failing on
nospace_cache okay with you?

Thanks.

> On the mkfs side, we can add new incompat feature to the -O option that
> will set the incompat bit to the superblock. Mounting such filesystem
> would use the v2 cache automatically.
> 
> I'd like to see the b-tree space cache default in the future, until then
> it'll be mkfs-time option or mount-time option.
> 
> For backward compatibility, mounting a free space v2 filesystem on older
> kernel can be done with support of userspace tools: reset the cache
> generation (as if clear_cache was used), drop all the free-space-tree
> structures and unset the incompat bit. I think this kind of fallback is
> desirable.
> 
> 
> Other than that, I like the series and the improvements it's supposed to
> bring.

-- 
Omar
