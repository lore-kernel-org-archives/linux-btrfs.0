Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752761AbdKFOA7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 09:00:59 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 605B7ABB1
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 14:00:58 +0000 (UTC)
Date: Mon, 6 Nov 2017 14:59:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 11/11] btrfs: use non-RCU list traversal in
 write_all_supers callees
Message-ID: <20171106135907.GE28789@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1509471604.git.dsterba@suse.com>
 <8430e9c00d58748f1cb574b686396c8349ac7311.1509471604.git.dsterba@suse.com>
 <f5d61e0d-b9b1-a34f-c3d2-3ba27ab4c448@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f5d61e0d-b9b1-a34f-c3d2-3ba27ab4c448@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 02, 2017 at 11:49:15AM +0200, Nikolay Borisov wrote:
> 
> 
> On 31.10.2017 19:44, David Sterba wrote:
> > We take the fs_devices::device_list_mutex mutex in write_all_supers
> > which will prevent any add/del changes to the device list. Therefore we
> > don't need to use the RCU variant list_for_each_entry_rcu in any of the
> > called functions.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/disk-io.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index efce9a2fa9be..042cf46e4cd0 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3396,9 +3396,10 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
> >  	int errors_wait = 0;
> >  	blk_status_t ret;
> >  
> > +	WARN_ON(!mutex_is_locked(&info->fs_devices->device_list_mutex));
> 
> Don't we want lockdep_assert_held ? I'm assuming enough testing with
> lockdep on is performed so it will be caught in time if this invariant
> is broken.

Yes, lockdep_assert_held should enough, this is a development-time
warning. Will be fixed.
