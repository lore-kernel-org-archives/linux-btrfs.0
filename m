Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51463 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LLBj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 20:39:28 -0500
Date: Wed, 12 Dec 2012 09:37:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Jim Schutt <jaschut@sandia.gov>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: 3.7.0-rc8 btrfs locking issue
Message-ID: <20121212013736.GA12318@liubo>
Reply-To: bo.li.liu@oracle.com
References: <50BF7129.90602@sandia.gov>
 <20121209140442.GA14309@liubo.jp.oracle.com>
 <50C7604B.7070203@sandia.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C7604B.7070203@sandia.gov>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 11, 2012 at 09:33:15AM -0700, Jim Schutt wrote:
> On 12/09/2012 07:04 AM, Liu Bo wrote:
> > On Wed, Dec 05, 2012 at 09:07:05AM -0700, Jim Schutt wrote:
> > Hi Jim,
> > 
> > Could you please apply the following patch to test if it works?
> 
> Hi,
> 
> So far, with your patch applied I've been unable to reproduce
> the recursive deadlock.  Thanks a lot for this patch!
> This issue has been troubling me for a while.

Hi Jim,

Good news for us :)

> 
> I've been trying to learn more about btrfs internals -
> if you have the time to answer a couple questions about
> your patch, I'd really appreciate it.

See below.

> 
> > 
> > (It's against 3.7-rc8.)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 3d3e2c1..100289b 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -3346,7 +3346,8 @@ u64 btrfs_get_alloc_profile(struct btrfs_root
> > *root, int data)
> >  
> >  	if (data)
> >  		flags = BTRFS_BLOCK_GROUP_DATA;
> > -	else if (root == root->fs_info->chunk_root)
> > +	else if (root == root->fs_info->chunk_root ||
> > +		 root == root->fs_info->dev_root)
> >  		flags = BTRFS_BLOCK_GROUP_SYSTEM;
> >  	else
> >  		flags = BTRFS_BLOCK_GROUP_METADATA;
> > @@ -3535,6 +3536,7 @@ static u64 get_system_chunk_thresh(struct
> > btrfs_root *root, u64 type)
> >  		num_dev = 1;	/* DUP or single */
> >  
> >  	/* metadata for updaing devices and chunk tree */
> > +	num_dev = num_dev << 1
> 
> AFAICS this is doubling the size of the reserve, which
> reduces the chance of a recursive do_chunk_alloc(), right?
> 

Not like that, we hit the deadlock because updating device tree also
uses METADATA chunk, which may be called when we're actually allocating
a METADATA chunk, so the patch I sent you makes updating device tree
use SYSTEM chunk, which we'll have some code to check if it is enough
before allocating a chunk(if not, we'll allocate a SYSTEM chunk first).

Here I double the size just because the worst case of allocating a
DATA/METADATA chunk -may- results in

1)adding a SYSTEM chunk +
2)adding dev extent per chunk stripe +
3)updating chunk stripes's bytes_used

> >  	return btrfs_calc_trans_metadata_size(root, num_dev + 1);
> 
> btrfs_calc_trans_metadata_size(root, num_items) multiplies its
> num_items argument by another factor of three - do you know if
> there is there some rationale behind that number, or is it
> perhaps also an empirically determined factor?

The height of Btrfs's metadata btree is at most 8,
leaf is on 0 level while node is at most on 7 level.

Each btree update may results in COWing a node and its sibling nodes,
where the factor of tree comes from

> 
> What I'm wondering about is that if the size of the reserve is
> empirically determined, will it need to be increased again
> later when machines are more capable, and can handle a higher
> load?
> 
> Do you think it's feasible to modify the locking for
> do_chunk_alloc to allow it to recurse without deadlock?

Well, it could be, but IMO it'll bring us complexity, so worse
maintainance.

Any questions? Feel free to ask.

thanks,
liubo
