Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56631 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750955AbdIAPMB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 11:12:01 -0400
Date: Fri, 1 Sep 2017 17:10:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: josef@toxicpanda.com, kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs-progs: print the csum length in debug-tree
Message-ID: <20170901151034.GR2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503666788-13122-1-git-send-email-jbacik@fb.com>
 <93debd97-9f8c-ace8-4941-04e95e6771f6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <93debd97-9f8c-ace8-4941-04e95e6771f6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 04:48:43PM +0300, Nikolay Borisov wrote:
> 
> 
> On 25.08.2017 16:13, josef@toxicpanda.com wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > While looking at a log of a corrupted fs I needed to verify we were
> > missing csums for a given range.  Make this easier by printing out how
> > many bytes a csum extent item represents when using btrfs_debug_tree.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  print-tree.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/print-tree.c b/print-tree.c
> > index 5927ed3..a124c96 100644
> > --- a/print-tree.c
> > +++ b/print-tree.c
> > @@ -1103,9 +1103,15 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
> >  		case BTRFS_CSUM_ITEM_KEY:
> >  			printf("\t\tcsum item\n");
> >  			break;
> > -		case BTRFS_EXTENT_CSUM_KEY:
> > -			printf("\t\textent csum item\n");
> > +		case BTRFS_EXTENT_CSUM_KEY: {
> > +			u16 csum_size =
> > +				btrfs_super_csum_size(root->fs_info->super_copy);
> > +			u32 size = (item_size / csum_size) *
> > +				root->fs_info->sectorsize;
> > +			printf("\t\textent csum item bytes %lu\n",
> > +			       (unsigned long)size);
> 
> Currently for a csum item we get:
> 
> item 0 key (EXTENT_CSUM EXTENT_CSUM 1103101952) itemoff 16279 itemsize 4
> 		extent csum item
> 
> 
>  Why don't you go one step further and print the covered range -
> it would be key.offset + size (the number you've calculated) And so you
> can print something like:
> 
> item 0 key (EXTENT_CSUM EXTENT_CSUM 1103101952) itemoff 16279 itemsize 4
> 		extent csum item 1103101952-1103106048
> 
> "extent csum item range %llu-%lly\n", key.offset, key.offset + size

I think the calculation is really simple to do, if one needs it.

The 'bytes' seem to refer to the range so I'll change that to length.
