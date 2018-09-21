Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35951 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391102AbeIVATQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 20:19:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id b11-v6so6347771pfo.3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 11:29:10 -0700 (PDT)
Date: Fri, 21 Sep 2018 11:29:08 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v8 0/6] Btrfs: implement swap file support
Message-ID: <20180921182908.GA31081@vader>
References: <cover.1537419652.git.osandov@fb.com>
 <20180920172255.GE5847@twin.jikos.cz>
 <20180920174124.GB26479@vader>
 <20180921151735.GK5847@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180921151735.GK5847@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2018 at 05:17:35PM +0200, David Sterba wrote:
> On Thu, Sep 20, 2018 at 10:41:24AM -0700, Omar Sandoval wrote:
> > On Thu, Sep 20, 2018 at 07:22:55PM +0200, David Sterba wrote:
> > > On Wed, Sep 19, 2018 at 10:02:11PM -0700, Omar Sandoval wrote:
> > > > From: Omar Sandoval <osandov@fb.com>
> > > > Changes from v7 [1]:
> > > > 
> > > > - Expanded a few commit messages
> > > > - Added Johannes' acked-by on patches 1 and 2
> > > > - Rebased on v4.19-rc4
> > > 
> > > I've sent my comments, it's mostly about the usability or small
> > > enhancements. As you've got acks from MM people, I hope it would be ok
> > > if I add this series to for-next so we can give it some testing.
> > 
> > That'd be great. Feel free to grab it from my git tree
> > (https://github.com/osandov/linux/tree/btrfs-swap) if you want the
> > version with your comments addressed.
> 
> Updates looks good, branch added to the for-next snapshot and will be in
> upcoming for-next.

I got a kbuild error when building with CONFIG_SWAP=n, just pushed the
fix below on patch 6:

diff --git b/fs/btrfs/inode.c a/fs/btrfs/inode.c
index ffe266e612e3..6de98bb30c27 100644
--- b/fs/btrfs/inode.c
+++ a/fs/btrfs/inode.c
@@ -10489,6 +10489,7 @@ void btrfs_set_range_writeback(struct extent_io_tree *tree, u64 start, u64 end)
 	}
 }
 
+#ifdef CONFIG_SWAP
 /*
  * Add an entry indicating a block group or device which is pinned by a
  * swapfile. Returns 0 on success, 1 if there is already an entry for it, or a
@@ -10812,6 +10813,17 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	sis->highest_bit = bsi.nr_pages - 1;
 	return bsi.nr_extents;
 }
+#else
+static void btrfs_swap_deactivate(struct file *file)
+{
+}
+
+static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+			       sector_t *span)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 
 static const struct inode_operations btrfs_dir_inode_operations = {
 	.getattr	= btrfs_getattr,

> > > The MM patches would better go separately to 4.20 via the mm tree.  I
> > > did only build tests so 4.20 target is still feasible but given that
> > > it's rc4 it's a bit too close. There are some limitations posed by the
> > > swapfiles so I'd like to have a chance to do some actual tests myself
> > > and check the usability status.
> > 
> > 4.20 would be nice, but I could live with 4.21. I'll just be backporting
> > it to our internal kernel here anyways ;) Let me know how the tests go
> > and which way you want to go.
> 
> Backporting to your kernel is fine, your users will complain to you, but
> once it's in the mainline the complaints will go my way :)
> 
> As for the merge of the non-btrfs patches, I checked again and there are
> the VFS/documentation patches that haven't been CCed to the relvant
> people.  For that reason I'm not much comfortable to take them through
> my tree for the final merge. The MM part looks fine from that
> perspective.

There aren't any VFS changes, just the trivial documentation fixes.
fsdevel was Cc'd for the first four versions, but it's hard enough to
get Al to look at actual changes, let alone a documentation fix.
