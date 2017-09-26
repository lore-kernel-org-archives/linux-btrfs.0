Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934836AbdIZMPK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 08:15:10 -0400
Date: Tue, 26 Sep 2017 14:13:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs: Add sanity check for EXTENT_DATA when
 reading out leaf
Message-ID: <20170926121336.GS31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
 <20170823075759.13982-4-quwenruo.btrfs@gmx.com>
 <20170925154503.GL31640@twin.jikos.cz>
 <d90b5bd1-8b8f-4403-6d46-a817d935d63d@gmx.com>
 <4e71f431-8869-b430-4179-23a5a442951f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4e71f431-8869-b430-4179-23a5a442951f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 26, 2017 at 08:46:29AM +0800, Qu Wenruo wrote:
> On 2017年09月26日 08:28, Qu Wenruo wrote:
> > On 2017年09月25日 23:45, David Sterba wrote:
> >> On Wed, Aug 23, 2017 at 04:57:58PM +0900, Qu Wenruo wrote:
> >>> Add extra checker for item with EXTENT_DATA type.
> >>> This checks the following thing:
> >>> 0) Key offset
> >>>     All key offset must be aligned to sectorsize.
> >>>     Inline extent must have 0 for key offset.
> >>>
> >>> 1) Item size
> >>>     Plain text inline file extent size must match item size.
> >>
> >> 'plain text' seems to be a bit misleading, I don't think we've ever
> >> referred to uncompressed extent as such, although it makes some sense. I
> >> think 'uncompressed' would work too.
> > 
> > I'll use 'uncompressed' instead.
> > 
> >>
> >>>     (compressed inline file extent has no info about its on-disk size)
> >>>     Regular/preallocated file extent size must be a fixed value.
> >>>
> >>> 2) Every member of regular file extent item
> >>>     Including alignment for bytenr and offset, possible value for
> >>>     compression/encryption/type.
> >>>
> >>> 3) Type/compression/encode must be one of the valid values.
> >>>
> >>> This should be the most comprehensive and restrict check in the context
> >>> of btrfs_item for EXTENT_DATA.
> >>>
> >>> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> >>> ---
> >>>   fs/btrfs/disk-io.c              | 108 
> >>> ++++++++++++++++++++++++++++++++++++++++
> >>>   include/uapi/linux/btrfs_tree.h |   1 +
> >>>   2 files changed, 109 insertions(+)
> >>>
> >>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>> index e034d08bd036..b92296c6a698 100644
> >>> --- a/fs/btrfs/disk-io.c
> >>> +++ b/fs/btrfs/disk-io.c
> >>> @@ -549,6 +549,103 @@ static int check_tree_block_fsid(struct 
> >>> btrfs_fs_info *fs_info,
> >>>              btrfs_header_level(eb) == 0 ? "leaf" : "node",    \
> >>>              reason, btrfs_header_bytenr(eb), root->objectid, slot)
> >>> +static int check_extent_data_item(struct btrfs_root *root,
> >>> +                  struct extent_buffer *leaf,
> >>> +                  struct btrfs_key *key, int slot)
> >>> +{
> >>> +    struct btrfs_file_extent_item *fi;
> >>> +    u32 sectorsize = root->fs_info->sectorsize;
> >>> +    u32 item_size = btrfs_item_size_nr(leaf, slot);
> >>> +
> >>> +    if (!IS_ALIGNED(key->offset, sectorsize)) {
> >>> +        CORRUPT("unaligned key offset for file extent",
> >>
> >> The CORRUPT macro does not print any details beyond what it gets from
> >> the parameters, so here we'd like to know which extent it is and what's
> >> the size. The sectorsize can be found elsewhere so it does not need
> >> to be printed.
> 
> Did you mean, the corrupt can be enhanced just like btrfs_printk() to 
> have custom format and args list?

Yeah something like that. And also make it a function, unless we're
going to use some macro magic (I'm not sure about that yet).

Schematically:

btrfs_report_corruption(fs_info, EXTENT_ITEM, "file item type is unknown: %d", fi->type);

implemented as:

btrfs_err(fs_info,
	"corruption detected for item %d: "
	"file item type is unknown: %d",
	EXTENT_ITEM
	fi->type);

Here comes the magic: as btrfs_err will print the arguments on one line
and adds the \n, we have to merge the string and the argument list into
one.

But if adding a separate helper similar to btrfs_err would be more
suitable, then ok.
