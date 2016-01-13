Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbcAMI6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 03:58:12 -0500
Date: Wed, 13 Jan 2016 09:55:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 17/25] btrfs-progs: extent-tree: Enhance
 btrfs_record_file_extent
Message-ID: <20160113085546.GO4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448953905-28673-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1448953905-28673-18-git-send-email-quwenruo@cn.fujitsu.com>
 <20160112101720.GK4227@twin.jikos.cz>
 <56959B4D.5060603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56959B4D.5060603@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 08:33:17AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/01/12 11:17 +0100:
> > On Tue, Dec 01, 2015 at 03:11:37PM +0800, Qu Wenruo wrote:
> >> --- a/extent-tree.c
> >> +++ b/extent-tree.c
> >> +static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
> >> +				      struct btrfs_root *root, u64 objectid,
> >> +				      struct btrfs_inode_item *inode,
> >> +				      u64 file_pos, u64 disk_bytenr,
> >> +				      u64 *ret_num_bytes)
> >>   {
> >>   	int ret;
> >>   	struct btrfs_fs_info *info = root->fs_info;
> > ...
> >> @@ -3999,25 +4003,80 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
> >>   		return ret;
> >>   	}
> >>
> >> -	btrfs_init_path(&path);
> >> +	path = btrfs_alloc_path();
> >> +	if (!path)
> >> +		return -ENOMEM;
> >> +
> > ...
> >>   fail:
> >> -	btrfs_release_path(&path);
> >> +	btrfs_release_path(path);
> >> +	return ret;
> >
> > Coverity correctly complains that path leaks here.
> 
> Oh, I should use btrfs_free_path().
> 
> Should I rebase the unmerged to patches to current devel and send it again?

Please hold on until 4.4 is released (at most a few days from now).
