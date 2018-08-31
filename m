Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40682 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbeHaSTW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 14:19:22 -0400
Received: by mail-qt0-f194.google.com with SMTP id h4-v6so14654949qtj.7
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 07:11:41 -0700 (PDT)
Date: Fri, 31 Aug 2018 10:11:39 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/35] btrfs: dump block_rsv whe dumping space info
Message-ID: <20180831141138.vus5d7okct36d54a@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-8-josef@toxicpanda.com>
 <f6b8c728-1ce5-f14a-533a-ad3ca9efeed7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6b8c728-1ce5-f14a-533a-ad3ca9efeed7@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 10:53:54AM +0300, Nikolay Borisov wrote:
> 
> 
> On 30.08.2018 20:41, Josef Bacik wrote:
> > For enospc_debug having the block rsvs is super helpful to see if we've
> > done something wrong.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/btrfs/extent-tree.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 80615a579b18..df826f713034 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -7910,6 +7910,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
> >  	return ret;
> >  }
> >  
> > +static void dump_block_rsv(struct btrfs_block_rsv *rsv)
> > +{
> > +	spin_lock(&rsv->lock);
> > +	printk(KERN_ERR "%d: size %llu reserved %llu\n",
> > +	       rsv->type, (unsigned long long)rsv->size,
> > +	       (unsigned long long)rsv->reserved);
> > +	spin_unlock(&rsv->lock);
> > +}
> 
> There was feedback on this hunk which you seem to have ignored:
> 
> https://www.spinics.net/lists/linux-btrfs/msg80473.html
> 

Yup good point, I'll fix this up.  Thanks,

Josef
