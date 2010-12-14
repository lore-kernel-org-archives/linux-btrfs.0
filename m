From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Bug in the design of the tree search ioctl API ? [was Re: [PATCH 1/3] Btrfs: Really return keys within specified range]
Date: Tue, 14 Dec 2010 19:16:41 +0100
Message-ID: <201012141916.41682.kreijack@libero.it>
References: <4D05EBC9.6020908@cn.fujitsu.com> <201012131913.02276.kreijack@libero.it> <4D07027D.1000500@cn.fujitsu.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D07027D.1000500@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 14 December, 2010, Li Zefan wrote:
> Goffredo Baroncelli wrote:
> > Hi Li,
> > 
> > On Monday, 13 December, 2010, Li Zefan wrote:
> >> The keys returned by tree search ioctl should be restricted to:
> >>
> >> 	key.objectid = [min_objectid, max_objectid] &&
> >> 	key.offset   = [min_offset, max_offset] &&
> >> 	key.type     = [min_type, max_type]
> >>
> >> But actually it returns those keys:
> >>
> >> 	[(min_objectid, min_type, min_offset),
> >> 		(max_objectid, max_type, max_offset)].
> >>
> > 
> > I have to admit that I had need several minutes to understand what you 
wrote 
> > :). Then I came to conclusion that the tree search ioctl is basically 
wrong.
> > 
> > IMHO, the error in this API is to use the lower bound of the acceptance 
> > criteria (the min_objectid, min_offset, min_type fields) also as starting 
> > point for the search.
> > 
> > Let me explain with an example.
> > 
> > Suppose to want to search all the keys in the range
> > 
> >  	key.objectid = 10..20
> >  	key.offset   = 100..200
> >  	key.type     = 2..5
> > 
> > 
> > Suppose to set sk->nr_items to 1 for simplicity, and the keys available 
which 
> > fit in the range are
> > 
> > 1)	[15,150,3]
> > 2)	[16,160,4]
> > 3)	[17,180,3]
> > 
> > All these key satisfy the "acceptance criteria", but because we have to 
> > restart the search from the last key found, the code should resemble
> > 
> > 	sk = &args.key
> > 
> > 	sk->min_objectid=10; sk->max_objectid=20
> > 	sk->min_offset=100; sk->max_offset=200
> > 	sk->min_type=2; sk->max_type=5
> > 	sk->nr_items = 1;
> > 
> > 	while(1){
> > 		ioctl(fd,  BTRFS_IOC_TREE_SEARCH, &args);
> > 		if( !sk->nr_items )
> > 			break
> > 
> > 		for(off = 0, i=0 ; i < sk->nr_items ; i   ){
> > 			sh = (struct btrfs_ioctl_search_header *)(args.buf  
> >                                                                  off);
> > 
> > 			[...]
> > 	                sk->min_objectid = sh->objectid;
> >         	        sk->min_offset = sh->offset;
> > 	                sk->min_type = sh->type;
> > 		}
> > 
> > 		<increase the sk->min_* key of 1>
> > 				
> > 	}
> > 
> > But in this case, the code after found the key #2, sets the minimum 
acceptance 
> > criteria to [16,160,4], which exclude the key #3 because min_type is too 
high.
> > 
> > Ideally, we should add three new field to the search key structure:
> > 
> > 	sk->start_objectid
> > 	sk->start_offset
> > 	sk->start_type
> > 
> > And after every iteration the code (even the kernel code) should set these 
> > fields as "last key found  1", leaving the min_* fields as they are.
> > 
> > My analysis is correct or I miss  something ?
> > 
> 
> After looking more deeply, I found the ioctl was changed in this way
> on purpose, to support "btrfs subvolume find-new" specifically.
> 
> See this commit:
> 
> commit abc6e1341bda974e2d0eddb75f57a20ac18e9b33
> Author: Chris Mason <chris.mason@oracle.com>
> Date:   Thu Mar 18 12:10:08 2010 -0400
> 
>     Btrfs: fix key checks and advance in the search ioctl
> 
>     The search ioctl was working well for finding tree roots, but using it 
for
>     generic searches requires a few changes to how the keys are advanced.
>     This treats the search control min fields for objectid, type and offset
>     more like a key, where we drop the offset to zero once we bump the type,
>     etc.
> 
>     The downside of this is that we are changing the min_type and min_offset
>     fields during the search, and so the ioctl caller needs extra checks to 
make
>     the keys in the result are the ones it wanted.
> 
>     This also changes key_in_sk to use btrfs_comp_cpu_keys, just to make
>     things more readable.
> 
> So I think we can just fix the btrfs tool. Though adding sk->start_xxx 
should
> also be able to meet the needs for "btrfs subvolume find-new".

Sorry, but I have to disagree. This API seems to me simply bugged. The example 
above (which is quite generic) highlights this fact. But I can provide a more 
real case: suppose to use the BTRFS_IOC_TREE_SEARCH ioctl to find the new 
files. We are interested to the following items:

- BTRFS_EXTENT_DATA_KEY			(type = 1)
- BTRFS_INODE_ITEM_KEY			(type = 24)
- BTRFS_XATTR_ITEM_KEY			(type = 108)

Acceptance criteria:

	min_type = 1
	max_type = 108
	min_offset = 0
	max_offset = ~0
	min_objectid = 0
	max_objectid = ~0
	min_transid = <the base generation number>

Pay attention that we aren't interested in the offset.

Suppose to have the following sequence keys  [objectid, type, offset]:

[...]
1)	[300, BTRFS_EXTENT_DATA_KEY, xx]
2)	[300, BTRFS_INODE_ITEM_KEY, xx]
3)	[300, BTRFS_XATTR_ITEM_KEY, xx]
4)	[301, BTRFS_EXTENT_DATA_KEY, xx]
5)	[301, BTRFS_INODE_ITEM_KEY, xx]
7)	[30200, BTRFS_EXTENT_DATA_KEY, xx]
8)	[30200, BTRFS_INODE_ITEM_KEY, xx]
9)	[30200, BTRFS_XATTR_ITEM_KEY, xx]
[...]


Suppose that the buffer is filled between the item 2 and 3. We should restart 
the search, but how set the min_* key ? Try the following hypothesis

h1) objectid++, type = 0 -> In the next search the key 3 would be skipped
h2) objectid asis, type ++, -> in the next search the key 4 would be skipped
h3) objectid asis, type = 0 -> in the next search the key 1,2,3 would be 
returned a second time...

Pay attention that every inode may have more key type BTRFS_XATTR_ITEM_KEY or 
type BTRFS_EXTENT_DATA_KEY, so it is not possible to know in advance when the 
buffer is filled.

Only as  theoretical exercise, we can improve the search logic in userspace so 
when an item is returned, in the next search we set the minimum type as 
previous type+1, and the *maximum* objectid as the latest ofound bject id. 
When we are sure that there are not more key with this objectid  we can reuse 
the old max_objectid and min_type... But to me it seems very fragile.

Chris what do you think ? Otherwise I missed something this seems a severe bug 
in the api ?

In another email I will propose a patch which may address this problem.

Regards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
