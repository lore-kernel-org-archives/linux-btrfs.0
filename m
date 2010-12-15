From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 11:14:17 -0500
Message-ID: <1292429359-sup-8458@think>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012131913.02276.kreijack@libero.it> <4D07027D.1000500@cn.fujitsu.com> <201012141916.41682.kreijack@libero.it> <4D08370D.6020705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D08370D.6020705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2010-12-14 22:33:33 -0500:
> > Suppose to have the following sequence keys  [objectid, type, offset]:
> > 
> > [...]
> > 1)    [300, BTRFS_EXTENT_DATA_KEY, xx]
> > 2)    [300, BTRFS_INODE_ITEM_KEY, xx]
> > 3)    [300, BTRFS_XATTR_ITEM_KEY, xx]
> > 4)    [301, BTRFS_EXTENT_DATA_KEY, xx]
> > 5)    [301, BTRFS_INODE_ITEM_KEY, xx]
> > 7)    [30200, BTRFS_EXTENT_DATA_KEY, xx]
> > 8)    [30200, BTRFS_INODE_ITEM_KEY, xx]
> > 9)    [30200, BTRFS_XATTR_ITEM_KEY, xx]
> > [...]
> > 
> > 
> > Suppose that the buffer is filled between the item 2 and 3. We should restart 
> > the search, but how set the min_* key ? Try the following hypothesis
> > 
> > h1) objectid++, type = 0 -> In the next search the key 3 would be skipped
> > h2) objectid asis, type ++, -> in the next search the key 4 would be skipped
> > h3) objectid asis, type = 0 -> in the next search the key 1,2,3 would be 
> 
> h4) objectid asis, type asis, offset++ -> we should get the correct result.

This is the right answer ;).  The problem is that even though our key has
3 distinct parts, and the API makes it look like you have very fine
grained control over those three parts, you have to remember to reset
them as you iterate between objectids.  It isn't a obvious as it should
be.

The current API is a very raw export of how we do the searches in the
kernel too.  You can do pretty much anything with it, but we pay with
complexity.

-chris
