Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755742AbeCVODI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:03:08 -0400
Date: Thu, 22 Mar 2018 15:00:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Validate child tree block's level and first key
Message-ID: <20180322140041.GB6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180319091841.18603-1-wqu@suse.com>
 <20180322134058.GA6955@twin.jikos.cz>
 <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <806f4931-f224-7168-f4c2-b08af0a05278@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2018 at 09:53:46PM +0800, Qu Wenruo wrote:
> >> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> >> index 26484648d090..3866b8ab20f1 100644
> >> --- a/fs/btrfs/backref.c
> >> +++ b/fs/btrfs/backref.c
> >> @@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
> >>  		BUG_ON(ref->key_for_search.type);
> >>  		BUG_ON(!ref->wanted_disk_byte);
> >>  
> >> -		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0);
> >> +		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0, NULL,
> >> +				     0);
> > 
> > Please add 2nd function that will take the extended parameters and
> > keep read_tree_block as is.
> 
> So for any new caller of read_tree_block(), reviewer is the last person
> to info the author to use these parameters for safety check?
> 
> And in fact, the old function should be avoid if possible, I think the
> new parameters act as a pretty good sign to make any caller double think
> about this.

I saw half of the new parameters were just 0, NULL, so this looks like a
lot of code churn and I haven't looked closer if there's a chance to
fill the parameters in all callsites. So if it's a matter of adding them
incrementally then fine.
