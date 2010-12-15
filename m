From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Wed, 15 Dec 2010 13:51:07 -0500
Message-ID: <1292438562-sup-7107@think>
References: <4D05EBC9.6020908@cn.fujitsu.com> <4D08370D.6020705@cn.fujitsu.com> <1292429359-sup-8458@think> <201012151942.23924.kreijack@libero.it>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: kreijack <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201012151942.23924.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Goffredo Baroncelli's message of 2010-12-15 13:42:23 -0500:
> On Wednesday, 15 December, 2010, Chris Mason wrote:
> > Excerpts from Li Zefan's message of 2010-12-14 22:33:33 -0500:
> > > > Suppose to have the following sequence keys  [objectid, type, offset]:
> > > > 
> > > > [...]
> > > > 1)    [300, BTRFS_EXTENT_DATA_KEY, xx]
> > > > 2)    [300, BTRFS_INODE_ITEM_KEY, xx]
> > > > 3)    [300, BTRFS_XATTR_ITEM_KEY, xx]
> > > > 4)    [301, BTRFS_EXTENT_DATA_KEY, xx]
> > > > 5)    [301, BTRFS_INODE_ITEM_KEY, xx]
> > > > 7)    [30200, BTRFS_EXTENT_DATA_KEY, xx]
> > > > 8)    [30200, BTRFS_INODE_ITEM_KEY, xx]
> > > > 9)    [30200, BTRFS_XATTR_ITEM_KEY, xx]
> > > > [...]
> > > > 
> > > > 
> > > > Suppose that the buffer is filled between the item 2 and 3. We should 
> restart 
> > > > the search, but how set the min_* key ? Try the following hypothesis
> > > > 
> > > > h1) objectid++, type = 0 -> In the next search the key 3 would be 
> skipped
> > > > h2) objectid asis, type ++, -> in the next search the key 4 would be 
> skipped
> > > > h3) objectid asis, type = 0 -> in the next search the key 1,2,3 would be 
> > > 
> > > h4) objectid asis, type asis, offset++ -> we should get the correct 
> result.
> > 
> > This is the right answer ;).  The problem is that even though our key has
> > 3 distinct parts, and the API makes it look like you have very fine
> > grained control over those three parts, you have to remember to reset
> > them as you iterate between objectids.  It isn't a obvious as it should
> > be.
> > 
> > The current API is a very raw export of how we do the searches in the
> > kernel too.  You can do pretty much anything with it, but we pay with
> > complexity.
> 
> Hi Chris,
> 
> I am a bit confused about your answer.
> 
> The actual API is a bit confused (or almost not "obvious"). An application in 
> order to work properly has to make some adjustment to the min_* fields AND 
> filter the results (because if we tweak with the min_* field, not useful data 
> is returned). Moreover this  means that we move between user-space<->kernel-
> space a lot of unused data (un-necessary context switch).
> 
> On the basis of your answer, it seems that this is ok (please don't consider 
> only the case of listing the subvolumes which is a very simple cases). And 
> nothing have to do.

Well, it's ok in that I wanted the API to be very close to the way
searches are done in the kernel.  I'll definitely agree it isn't
perfect, especially as we hop between objectids or types.

But I don't want to extend it just yet, mostly because we don't have new
applications making use of it.  I'd rather couple any new apis with new
applications that we haven't yet thought of.

Thanks a lot for the time you're spending on review and looking at this.
If you have killer apps that can really make use of new APIs, I'm happy
to start reworking things.

-chris
