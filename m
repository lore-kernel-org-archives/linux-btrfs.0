Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750955AbdFBRIz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 13:08:55 -0400
Date: Fri, 2 Jun 2017 19:07:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v2 6/9] btrfs: Check name before read in
 'iterate_dir_item'
Message-ID: <20170602170753.GO12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-7-suy.fnst@cn.fujitsu.com>
 <f4b0f4bd-105b-9a6d-d4c4-ddc842ae014f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f4b0f4bd-105b-9a6d-d4c4-ddc842ae014f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 12:58:12PM +0300, Nikolay Borisov wrote:
> 
> 
> On  1.06.2017 11:57, Su Yue wrote:
> > Since 'iterate_dir_item' checks namelen in its way,
> > use 'btrfs_is_namelen_valid' not 'verify_dir_item'.
> > 
> > Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> > ---
> >  fs/btrfs/send.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index fc496a6f842a..caf96af106e6 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -1069,6 +1069,12 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
> >  			}
> >  		}
> >  
> > +		ret = btrfs_is_namelen_valid(eb, path->slots[0],
> > +			  (unsigned long)(di + 1), name_len + data_len);
> > +		if (!ret) {
> > +			ret = -ENAMETOOLONG;
> 
> In 5/9 and 7/9 the return values upon btrfs_is_namelen_valid failure are
> different. Shouldn't the failure root cause (corrupted datastructures)
> always be the same when btrfs_is_namelen_valid fails? E.g. in the case
> of send we shouldn't really have entries which are ENAMETOOLONG, since
> they should've been rejected at time they were originally created with
> ENAMETOOLONG. And in case corruption happened and iterate_dir_item
> observes failure from btrfs_is_namelen_valid then this should be
> EIO/EUCLEAN ?

Agreed.
