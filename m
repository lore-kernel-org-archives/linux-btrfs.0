Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:39400 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdCGVHS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 16:07:18 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27Ks9M5024027
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 20:54:10 GMT
Date: Tue, 7 Mar 2017 12:51:39 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] btrfs: Fix metadata underflow caused by
 btrfs_reloc_clone_csum error
Message-ID: <20170307205138.GE12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170306025547.1858-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H5u9N1J+h+f1m9d1Q3ZmUgirb8gOdS=idRD-2srs-Lz3g@mail.gmail.com>
 <20170307173223.GX4662@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307173223.GX4662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 06:32:23PM +0100, David Sterba wrote:
> On Mon, Mar 06, 2017 at 11:19:32PM +0000, Filipe Manana wrote:
> > On Mon, Mar 6, 2017 at 2:55 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> > > [BUG]
> > > When btrfs_reloc_clone_csum() reports error, it can underflow metadata
> > > and leads to kernel assertion on outstanding extents in
> > > run_delalloc_nocow() and cow_file_range().
> > >
> > >  BTRFS info (device vdb5): relocating block group 12582912 flags data
> > >  BTRFS info (device vdb5): found 1 extents
> > >  assertion failed: inode->outstanding_extents >= num_extents, file: fs/btrfs//extent-tree.c, line: 5858
> > >
> > > Currently, due to another bug blocking ordered extents, the bug is only
> > > reproducible under certain block group layout and using error injection.
> > >
> > > a) Create one data block group with one 4K extent in it.
> > >    To avoid the bug that hangs btrfs due to ordered extent which never
> > >    finishes
> > > b) Make btrfs_reloc_clone_csum() always fail
> > > c) Relocate that block group
> > >
> > > [CAUSE]
> > > run_delalloc_nocow() and cow_file_range() handles error from
> > > btrfs_reloc_clone_csum() wrongly:
> > >
> > > (The ascii chart shows a more generic case of this bug other than the
> > > bug mentioned above)
> > >
> > > |<------------------ delalloc range --------------------------->|
> > > | OE 1 | OE 2 | ... | OE n |
> > >                     |<----------- cleanup range --------------->|
> > > |<-----------  ----------->|
> > >              \/
> > >  btrfs_finish_ordered_io() range
> > >
> > > So error handler, which calls extent_clear_unlock_delalloc() with
> > > EXTENT_DELALLOC and EXTENT_DO_ACCOUNT bits, and btrfs_finish_ordered_io()
> > > will both cover OE n, and free its metadata, causing metadata under flow.
> > >
> > > [Fix]
> > > The fix is to ensure after calling btrfs_add_ordered_extent(), we only
> > > call error handler after increasing the iteration offset, so that
> > > cleanup range won't cover any created ordered extent.
> > >
> > > |<------------------ delalloc range --------------------------->|
> > > | OE 1 | OE 2 | ... | OE n |
> > > |<-----------  ----------->|<---------- cleanup range --------->|
> > >              \/
> > >  btrfs_finish_ordered_io() range
> > >
> > > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > 
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> 1-2 added to for-next and queued for 4.11. Thanks.

I'm afraid that patch 1 has a problem, please take a look at the thread.

Thanks,

-liubo
