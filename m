Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57934 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755630AbdIGSRt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 14:17:49 -0400
Date: Thu, 7 Sep 2017 20:16:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com, clm@fb.com, dsterba@suse.com, jbacik@fb.com
Subject: Re: [PATCH 2/2] btrfs: finish ordered extent cleaning if no progress
 is found
Message-ID: <20170907181619.GD31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
 <150425634736.4737.8343712690392096633.stgit@naota.dhcp.fujisawa.hgst.com>
 <741949a9-32e6-ce18-0e7c-ca259edf909b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <741949a9-32e6-ce18-0e7c-ca259edf909b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 07:31:58PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月01日 16:59, Naohiro Aota wrote:
> > __endio_write_update_ordered() repeats the search until it reaches the end
> > of the specified range. This works well with direct IO path, because before
> > the function is called, it's ensured that there are ordered extents filling
> > whole the range. It's not the case, however, when it's called from
> > run_delalloc_range(): it is possible to have error in the midle of the loop
> > in e.g. run_delalloc_nocow(), so that there exisits the range not covered
> > by any ordered extents. By cleaning such "uncomplete" range,
> > __endio_write_update_ordered() stucks at offset where there're no ordered
> > extents.
> > 
> > Since the ordered extents are created from head to tail, we can stop the
> > search if there are no offset progress.
> > 
> > Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
> > Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
> > Cc: <stable@vger.kernel.org> # 4.12
> > ---
> >   fs/btrfs/inode.c |    4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index ae4c0a1bef38..fd5934121b4b 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -8309,6 +8309,7 @@ static void __endio_write_update_ordered(struct inode *inode,
> >   	btrfs_work_func_t func;
> >   	u64 ordered_offset = offset;
> >   	u64 ordered_bytes = bytes;
> > +	u64 last_offset;
> >   	int ret;
> >   
> >   	if (btrfs_is_free_space_inode(BTRFS_I(inode))) {
> > @@ -8320,6 +8321,7 @@ static void __endio_write_update_ordered(struct inode *inode,
> >   	}
> >   
> >   again:
> > +	last_offset = ordered_offset;
> >   	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
> >   						   &ordered_offset,
> >   						   ordered_bytes,
> > @@ -8330,6 +8332,8 @@ static void __endio_write_update_ordered(struct inode *inode,
> >   	btrfs_init_work(&ordered->work, func, finish_ordered_fn, NULL, NULL);
> >   	btrfs_queue_work(wq, &ordered->work);
> >   out_test:
> > +	if (ordered_offset == last_offset)
> > +		return;
> 
> Such check seems strange to me.
> 
> For ordered_offset == last_offset case, it means 
> btrfs_dec_test_ordered_pending() doesn't find any ordered extent in that 
> range, so we can exit.
> This takes me a while to dig into btrfs_dec_test_first_ordered_pending().
> 
> Extra comment will help here, or to modify 
> btrfs_dev_test_ordered_pending() to explicitly info caller there is no 
> extra pending ordered extent.

I'll update the patch with the comment based on your note, please send a
patch with the proposed code changes if you like.
