From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: fix OOPS of empty filesystem after balance
Date: Thu, 10 Mar 2011 07:28:21 -0500
Message-ID: <1299760026-sup-300@think>
References: <4D743F3A.6030105@cn.fujitsu.com> <4D7890D3.6080309@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D7890D3.6080309@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-03-10 03:50:27 -0500:
> On 03/07/2011 10:13 AM, liubo wrote:
> > btrfs will remove unused block groups after balance.
> > When a empty filesystem is balanced, the block group with tag "DATA" may be
> > dropped, and after umount and mount again, it will not find "DATA" space_info
> > and lead to OOPS.
> > So we initial the necessary space_infos(DATA, SYSTEM, METADATA) to avoid OOPS.
> > 
> 
> Hi, Chirs,
> 
> These two fixes are for critical problems(one OOPS and one memory leak), so would
> you please take some time to review them and check if they are ready for the next
> git pull? 
> 
> Seems that you have been a lot busy these days. ;)

Hi Liubo,

I'm looking at both of these.  There are no more rc's for 2.6.38, only
the final release, so the bar is very high for a commit that goes in.

-chris

> 
> thanks,
> liubo
> 
> > Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> > ---
> >  fs/btrfs/ctree.h       |    1 +
> >  fs/btrfs/disk-io.c     |    6 ++++++
> >  fs/btrfs/extent-tree.c |   23 +++++++++++++++++++++++
> >  3 files changed, 30 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 28188a7..49c50e5 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -2221,6 +2221,7 @@ int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
> >                     u64 num_bytes);
> >  int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
> >                  struct btrfs_root *root, u64 type);
> > +int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
> >  
> >  /* ctree.c */
> >  int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 3e1ea3e..8bcdc62 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1967,6 +1967,12 @@ struct btrfs_root *open_ctree(struct super_block *sb,
> >      fs_info->metadata_alloc_profile = (u64)-1;
> >      fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
> >  
> > +    ret = btrfs_init_space_info(fs_info);
> > +    if (ret) {
> > +        printk(KERN_ERR "Failed to initial space info: %d\n", ret);
> > +        goto fail_block_groups;
> > +    }
> > +
> >      ret = btrfs_read_block_groups(extent_root);
> >      if (ret) {
> >          printk(KERN_ERR "Failed to read block groups: %d\n", ret);
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 100e409..08525ee 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -8714,6 +8714,29 @@ out:
> >      return ret;
> >  }
> >  
> > +int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
> > +{
> > +    struct btrfs_space_info *space_info;
> > +    int ret;
> > +
> > +    ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM, 0, 0,
> > +                                 &space_info);
> > +    if (ret)
> > +        return ret;
> > +
> > +    ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA, 0, 0,
> > +                                 &space_info);
> > +    if (ret)
> > +        return ret;
> > +
> > +    ret = update_space_info(fs_info, BTRFS_BLOCK_GROUP_DATA, 0, 0,
> > +                                 &space_info);
> > +    if (ret)
> > +        return ret;
> > +
> > +    return ret;
> > +}
> > +
> >  int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
> >  {
> >      return unpin_extent_range(root, start, end);
> 
