Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60838 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756115AbdCGUdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:33:47 -0500
Date: Tue, 7 Mar 2017 18:32:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
Message-ID: <20170307173223.GX4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170306025547.1858-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H5u9N1J+h+f1m9d1Q3ZmUgirb8gOdS=idRD-2srs-Lz3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5u9N1J+h+f1m9d1Q3ZmUgirb8gOdS=idRD-2srs-Lz3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 11:19:32PM +0000, Filipe Manana wrote:
> On Mon, Mar 6, 2017 at 2:55 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > [BUG]
> > When btrfs_reloc_clone_csum() reports error, it can underflow metadata
> > and leads to kernel assertion on outstanding extents in
> > run_delalloc_nocow() and cow_file_range().
> >
> >  BTRFS info (device vdb5): relocating block group 12582912 flags data
> >  BTRFS info (device vdb5): found 1 extents
> >  assertion failed: inode->outstanding_extents >= num_extents, file: fs/btrfs//extent-tree.c, line: 5858
> >
> > Currently, due to another bug blocking ordered extents, the bug is only
> > reproducible under certain block group layout and using error injection.
> >
> > a) Create one data block group with one 4K extent in it.
> >    To avoid the bug that hangs btrfs due to ordered extent which never
> >    finishes
> > b) Make btrfs_reloc_clone_csum() always fail
> > c) Relocate that block group
> >
> > [CAUSE]
> > run_delalloc_nocow() and cow_file_range() handles error from
> > btrfs_reloc_clone_csum() wrongly:
> >
> > (The ascii chart shows a more generic case of this bug other than the
> > bug mentioned above)
> >
> > |<------------------ delalloc range --------------------------->|
> > | OE 1 | OE 2 | ... | OE n |
> >                     |<----------- cleanup range --------------->|
> > |<-----------  ----------->|
> >              \/
> >  btrfs_finish_ordered_io() range
> >
> > So error handler, which calls extent_clear_unlock_delalloc() with
> > EXTENT_DELALLOC and EXTENT_DO_ACCOUNT bits, and btrfs_finish_ordered_io()
> > will both cover OE n, and free its metadata, causing metadata under flow.
> >
> > [Fix]
> > The fix is to ensure after calling btrfs_add_ordered_extent(), we only
> > call error handler after increasing the iteration offset, so that
> > cleanup range won't cover any created ordered extent.
> >
> > |<------------------ delalloc range --------------------------->|
> > | OE 1 | OE 2 | ... | OE n |
> > |<-----------  ----------->|<---------- cleanup range --------->|
> >              \/
> >  btrfs_finish_ordered_io() range
> >
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

1-2 added to for-next and queued for 4.11. Thanks.
