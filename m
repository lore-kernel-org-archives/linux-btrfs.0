Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbbIIMBK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 08:01:10 -0400
Date: Wed, 9 Sep 2015 14:00:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 9/9] Btrfs: add free space tree mount option
Message-ID: <20150909120023.GF8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1441309178.git.osandov@fb.com>
 <de086134d128aad13d16b2aabc72918d7ec7637e.1441309178.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <de086134d128aad13d16b2aabc72918d7ec7637e.1441309178.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 03, 2015 at 12:44:27PM -0700, Omar Sandoval wrote:
> Now we can finally hook up everything so we can actually use free space
> tree. On the first mount with the free_space_tree mount option, the free
> space tree will be created and the FREE_SPACE_TREE read-only compat bit
> will be set. Any time the filesystem is mounted from then on, we will
> use the free space tree.
> 
> Having both the free space cache and free space trees enabled is
> nonsense, so we don't allow that to happen. Since mkfs sets the
> superblock cache generation to -1, this means that the filesystem will
> have to be mounted with nospace_cache,free_space_tree to create the free
> space trees on first mount. Once the FREE_SPACE_TREE bit is set, the
> cache generation is ignored when mounting. This is all a little more
> complicated than would be ideal, but at some point we can presumably
> make the free space tree the default and stop setting the cache
> generation in mkfs.

I have objections against introducing another options to do something
with space cache. As you write, it does not make sens to have
'space_cache' and 'free_space_tree' enabled, and I agree. The b-tree
approach is an "implementation detail", an improved version of space
caching.

Because of that I propose to do the following:

* use space_cache mount option, and add a value denoting the used
  implementation, eg. space_cache=btree or space_cache=v2 etc

* keep space_cache for backward compatibility for the current
  implementaion

* clear_cache should reset state for both

* nospace_cache prevents using any of the two versions of space cache

On the mkfs side, we can add new incompat feature to the -O option that
will set the incompat bit to the superblock. Mounting such filesystem
would use the v2 cache automatically.

I'd like to see the b-tree space cache default in the future, until then
it'll be mkfs-time option or mount-time option.

For backward compatibility, mounting a free space v2 filesystem on older
kernel can be done with support of userspace tools: reset the cache
generation (as if clear_cache was used), drop all the free-space-tree
structures and unset the incompat bit. I think this kind of fallback is
desirable.


Other than that, I like the series and the improvements it's supposed to
bring.
