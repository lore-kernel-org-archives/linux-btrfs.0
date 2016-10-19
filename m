Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756514AbcJSOXq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:23:46 -0400
Date: Wed, 19 Oct 2016 16:23:44 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org, jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH 2/2] btrfs: fix false enospc for compression
Message-ID: <20161019142344.GR11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161006025139.22776-1-wangxg.fnst@cn.fujitsu.com>
 <20161006025139.22776-2-wangxg.fnst@cn.fujitsu.com>
 <5800E4AB.2010701@applied-asynchrony.com>
 <5804937A.2060506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5804937A.2060506@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 05:01:46PM +0800, Wang Xiaoguang wrote:
> > [..]
> >>   int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
> >> -			      struct extent_state **cached_state);
> >> +			      struct extent_state **cached_state, int flag);
> >>   int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
> >> -			    struct extent_state **cached_state);
> >> +			    struct extent_state **cached_state, int flag);
> > [..]
> >>   int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
> >>   		      struct page **pages, size_t num_pages,
> >>   		      loff_t pos, size_t write_bytes,
> >> -		      struct extent_state **cached);
> >> +		      struct extent_state **cached, int flag);
> > Instead of adding "int flag" why not use the already defined
> > btrfs_metadata_reserve_type enum? I know it's just an int at the end of
> > the day, but the dedupe support already added another "int dedupe" argument
> > and it's probably easy to cause confusion.
> > Maybe later it would be beneficial to consolidate the flags into a consistent
> > set of enum values to prevent more "int flag" inflation and better declare the
> > intent of the extent state change. Not sure if that makes sense.
> Yes, agree.
> I'll rebase them later, thanks.

Would be great. I won't manually merge the patch now as it's not a
conflict against the current state, btrfs_set_extent_delalloc has the
extra parameter already. Please consolidate them before this patch is
supposed to be merged. Thanks.
