From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC, crash][PATCH] btrfs: allow cross-subvolume file clone
Date: Tue, 9 Aug 2011 19:50:12 +0200
Message-ID: <20110809175012.GB20461@twin.jikos.cz>
References: <1312394862-28143-1-git-send-email-dsterba@suse.cz>
 <4E39F39E.9000002@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, josef@redhat.com
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E39F39E.9000002@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 04, 2011 at 09:19:26AM +0800, Miao Xie wrote:
> > the patch has been applied on top of current linus which contains patches from
> > both pull requests (ed8f37370d83).
> 
> I think it is because the caller didn't reserve enough space.Could you try to
> apply the following patch? It might fix this bug.
> 
> [PATCH v2] Btrfs: reserve enough space for file clone
> http://marc.info/?l=linux-btrfs&m=131192686626576&w=2

Thanks! Yes, it does not crash anymore. Trees reflinked succesfully,
md5sums verified.


david

> 
> Thanks
> Miao
> 
> > 
> > The filesystem consists of 5 devices 23G each, about 100G of usable space,
> > mkfs.btrfs with defaults. The kernel tree has about 6G:
> > 
> > $ btrfs fi df .
> > Data, RAID0: total=10.00GB, used=5.55GB
> > Data: total=8.00MB, used=0.00
> > System, RAID1: total=8.00MB, used=4.00KB
> > System: total=4.00MB, used=0.00
> > Metadata, RAID1: total=1.50GB, used=121.75MB
> > Metadata: total=8.00MB, used=0.00
> > 
> > $ df -h .
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/sda5             110G  5.8G   82G   7% /mnt/sda5
> > 
> > ie. plenty of free space.
> > 
> > It's possible that I've omitted some important bits in the patch itself, or
> > this exposes a bug of ENOSPC or delayed-inode.
> > 
> > david
> > ---
> > 
> > From: David Sterba <dsterba@suse.cz>
> > 
> > Lift the EXDEV condition and allow different root trees for files being
> > cloned, then pass source inode's root when searching for extents.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> > ---
> >  fs/btrfs/ioctl.c |    7 ++++---
> >  1 files changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > index 0b980af..58eb0ef 100644
> > --- a/fs/btrfs/ioctl.c
> > +++ b/fs/btrfs/ioctl.c
> > @@ -2183,7 +2183,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
> >  		goto out_fput;
> >  
> >  	ret = -EXDEV;
> > -	if (src->i_sb != inode->i_sb || BTRFS_I(src)->root != root)
> > +	if (src->i_sb != inode->i_sb)
> >  		goto out_fput;
> >  
> >  	ret = -ENOMEM;
> > @@ -2247,13 +2247,14 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
> >  		 * note the key will change type as we walk through the
> >  		 * tree.
> >  		 */
> > -		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> > +		ret = btrfs_search_slot(NULL, BTRFS_I(src)->root, &key, path,
> > +				0, 0);
> >  		if (ret < 0)
> >  			goto out;
> >  
> >  		nritems = btrfs_header_nritems(path->nodes[0]);
> >  		if (path->slots[0] >= nritems) {
> > -			ret = btrfs_next_leaf(root, path);
> > +			ret = btrfs_next_leaf(BTRFS_I(src)->root, path);
> >  			if (ret < 0)
> >  				goto out;
> >  			if (ret > 0)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
