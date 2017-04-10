Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752903AbdDJOOd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 10:14:33 -0400
Date: Mon, 10 Apr 2017 16:14:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 8/9] btrfs: qgroup: Introduce extent changeset for
 qgroup reserve functions
Message-ID: <20170410141430.GA4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170313075216.5125-1-quwenruo@cn.fujitsu.com>
 <20170313075216.5125-9-quwenruo@cn.fujitsu.com>
 <20170407120025.GT4781@twin.jikos.cz>
 <e97cbe28-1333-22bc-357b-570b4e865ec5@cn.fujitsu.com>
 <20170410140025.GZ4781@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170410140025.GZ4781@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 04:00:25PM +0200, David Sterba wrote:
> On Mon, Apr 10, 2017 at 09:25:18AM +0800, Qu Wenruo wrote:
> > 
> > 
> > At 04/07/2017 08:00 PM, David Sterba wrote:
> > > On Mon, Mar 13, 2017 at 03:52:15PM +0800, Qu Wenruo wrote:
> > >> @@ -3355,12 +3355,14 @@ static int cache_save_setup(struct btrfs_block_group_cache *block_group,
> > >>  	struct btrfs_fs_info *fs_info = block_group->fs_info;
> > >>  	struct btrfs_root *root = fs_info->tree_root;
> > >>  	struct inode *inode = NULL;
> > >> +	struct extent_changeset data_reserved;
> > >
> > > Size of this structure is 40 bytes, and it's being added to many
> > > functions. This will be noticeable on the stack consumption.
> > >
> > > -extent-tree.c:btrfs_check_data_free_space              40 static
> > > -extent-tree.c:cache_save_setup                         96 static
> > > +extent-tree.c:btrfs_check_data_free_space              48 static
> > > +extent-tree.c:cache_save_setup                         136 static
> > > -file.c:__btrfs_buffered_write                          192 static
> > > +file.c:__btrfs_buffered_write                          232 static
> > > -file.c:btrfs_fallocate                                 208 static
> > > +file.c:btrfs_fallocate                                 248 static
> > > -inode-map.c:btrfs_save_ino_cache                       112 static
> > > +inode-map.c:btrfs_save_ino_cache                       152 static
> > > -inode.c:btrfs_direct_IO                                128 static
> > > +inode.c:btrfs_direct_IO                                176 static
> > > -inode.c:btrfs_writepage_fixup_worker                   88 static
> > > +inode.c:btrfs_writepage_fixup_worker                   128 static
> > > -inode.c:btrfs_truncate_block                           136 static
> > > +inode.c:btrfs_truncate_block                           176 static
> > > -inode.c:btrfs_page_mkwrite                             112 static
> > > +inode.c:btrfs_page_mkwrite                             152 static
> > > +ioctl.c:cluster_pages_for_defrag                       200 static
> > > -ioctl.c:btrfs_defrag_file                              312 static
> > > +ioctl.c:btrfs_defrag_file                              232 static
> > > -qgroup.c:btrfs_qgroup_reserve_data                     136 static
> > > +qgroup.c:btrfs_qgroup_reserve_data                     128 static
> > > -relocation.c:prealloc_file_extent_cluster              152 static
> > > +relocation.c:prealloc_file_extent_cluster              192 static
> > >
> > > There are generic functions so this will affect non-qgroup workloads as
> > > well. So there need to be a dynamic allocation (which would add another
> > > point of failure), or reworked in another way.
> > 
> > Well, I'll try to rework this to allocate extent_changeset inside 
> > btrfs_qgroup_reserve_data(), so that callers only need extra 8 bytes 
> > stack space, and no need to introduce extra error handlers.
> 
> So this still requires the dynamic allocation, on various call paths,
> that's what I object against most at the moment.

I get that we cannot easily avoid using the extent_changeset, so we'll
end up one way or another, the stack conservation has slight preference.
