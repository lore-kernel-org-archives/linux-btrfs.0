Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36213 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932342AbeEWOLS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 10:11:18 -0400
Date: Wed, 23 May 2018 22:11:00 +0800
From: Liu Bo <bo.liu@linux.alibaba.com>
To: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs_search_slot cleanups
Message-ID: <20180523141100.xgooxzegw37weozz@US-160370MP2.local>
Reply-To: bo.liu@linux.alibaba.com
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <9b80bec0-b7cf-10da-f379-373fe6ec776a@cn.fujitsu.com>
 <20180522120214.GG6649@twin.jikos.cz>
 <fd6e7b1c-6cd2-c5c2-9895-1df0db5f2ccc@suse.com>
 <77374b4d-6878-d8cf-40b2-a5f99188c2d9@cn.fujitsu.com>
 <20180523123440.GB6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180523123440.GB6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 02:34:40PM +0200, David Sterba wrote:
> On Wed, May 23, 2018 at 10:16:55AM +0800, Su Yue wrote:
> > >>> [   47.692084] kernel BUG at fs/btrfs/locking.c:286!
> > >>
> > >> I saw the crash too but did not investigate the root cause. So I'll
> > >> remove the branch from for-next until it's fixed. Thanks for the report.
> > > 
> > > I think the problem stems from Qu's patch, which sets search_commit_root
> > > =1 but doesn't set skip_locking, as a result we don't lock the tree when
> > > we obtain a reference to the root node, yet later when traversing the
> > > tree due to skip_locking not being set we try to lock it, and this
> > > causes btrfs_assert_tree_locked to triggers. Can you test whether the
> > > following diff solves the issues:
> > > 
> > > 
> > > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > > index bc19a7d11c98..23fadb640c59 100644
> > > --- a/fs/btrfs/qgroup.c
> > > +++ b/fs/btrfs/qgroup.c
> > > @@ -2702,6 +2702,7 @@ static void btrfs_qgroup_rescan_worker(struct
> > > btrfs_work *work)
> > >          * should be recorded by qgroup
> > >          */
> > >         path->search_commit_root = 1;
> > > +       path->skip_locking = 1;
> > > 
> > >         err = 0;
> > >         while (!err && !btrfs_fs_closing(fs_info)) {
> > > 
> > > 
> > > If it does, this only means we need to make skip_locking = 1 being
> > > conditional on search_commit_root being set and this situation should be
> > > handled in btrfs_search_slot.
> > 
> > After patching the change, btrfs/139 passes without BUG_ON.
> 
> Confirmed, I've added the fixup to for-next, Liu Bo's branch is there to
> and the crash did not show up.

Thanks a lot for the testing and fixes!

thanks,
-liubo
