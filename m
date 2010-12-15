From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 19:42:23 +0100
Message-ID: <201012151942.23924.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com> <4D08370D.6020705@cn.fujitsu.com> <1292429359-sup-8458@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1292429359-sup-8458@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 15 December, 2010, Chris Mason wrote:
> Excerpts from Li Zefan's message of 2010-12-14 22:33:33 -0500:
> > > Suppose to have the following sequence keys  [objectid, type, offset]:
> > > 
> > > [...]
> > > 1)    [300, BTRFS_EXTENT_DATA_KEY, xx]
> > > 2)    [300, BTRFS_INODE_ITEM_KEY, xx]
> > > 3)    [300, BTRFS_XATTR_ITEM_KEY, xx]
> > > 4)    [301, BTRFS_EXTENT_DATA_KEY, xx]
> > > 5)    [301, BTRFS_INODE_ITEM_KEY, xx]
> > > 7)    [30200, BTRFS_EXTENT_DATA_KEY, xx]
> > > 8)    [30200, BTRFS_INODE_ITEM_KEY, xx]
> > > 9)    [30200, BTRFS_XATTR_ITEM_KEY, xx]
> > > [...]
> > > 
> > > 
> > > Suppose that the buffer is filled between the item 2 and 3. We should 
restart 
> > > the search, but how set the min_* key ? Try the following hypothesis
> > > 
> > > h1) objectid++, type = 0 -> In the next search the key 3 would be 
skipped
> > > h2) objectid asis, type ++, -> in the next search the key 4 would be 
skipped
> > > h3) objectid asis, type = 0 -> in the next search the key 1,2,3 would be 
> > 
> > h4) objectid asis, type asis, offset++ -> we should get the correct 
result.
> 
> This is the right answer ;).  The problem is that even though our key has
> 3 distinct parts, and the API makes it look like you have very fine
> grained control over those three parts, you have to remember to reset
> them as you iterate between objectids.  It isn't a obvious as it should
> be.
> 
> The current API is a very raw export of how we do the searches in the
> kernel too.  You can do pretty much anything with it, but we pay with
> complexity.

Hi Chris,

I am a bit confused about your answer.

The actual API is a bit confused (or almost not "obvious"). An application in 
order to work properly has to make some adjustment to the min_* fields AND 
filter the results (because if we tweak with the min_* field, not useful data 
is returned). Moreover this  means that we move between user-space<->kernel-
space a lot of unused data (un-necessary context switch).

On the basis of your answer, it seems that this is ok (please don't consider 
only the case of listing the subvolumes which is a very simple cases). And 
nothing have to do.

Instead I suggest to (see my email [PATCH] BTRFS_IOC_TREE_SEARCH: store and 
use the last key found):
- leave the min_* and max_* fields to act only as filter
- add three more fields start_* as start point for the search 
- make some small modification to the kernel code to track in the start_* 
fields the last key found

pro:
- we pass to userspace only useful data
- we simplify a lot the userspace application, because they don't have to 
update the min_* fields (they will work in a obvious way :-) )
- we can use the ordered property of a btree structure to perform efficient 
data lookup (if we reset to zero the min_* fields we lookup un-necessary data)
- we have the same functionality of the old API

cons:
- we need a modification ( :-) )

May be that I missed some point, but I don't see any advantage to continue to 
support the actual API. Of course, that doesn't means that we can remove the 
old API ignoring the backward compatibility. 
But I think that there are sufficient pros to develop a new API

Please be patient: my english is very bad; I am not trying to blame anybody; I 
want only a "perfect fs" (TM) :-)

> 
> -chris
> 
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
