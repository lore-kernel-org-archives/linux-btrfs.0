Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932415AbeD0K5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 06:57:52 -0400
Date: Fri, 27 Apr 2018 12:55:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <obuil.liubo@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: set keep_lock when necessary in
 btrfs_defrag_leaves
Message-ID: <20180427105516.GY21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524706063-93210-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180426180659.GX21272@twin.jikos.cz>
 <CANQeFDBF7RwCufPa7s782fPsw60JBRq70ue_Dq7O__M0XFxaew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANQeFDBF7RwCufPa7s782fPsw60JBRq70ue_Dq7O__M0XFxaew@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 11:23:23AM +0800, Liu Bo wrote:
> >> ---
> >> v2: update commit log with more details.
> >>
> >>  fs/btrfs/tree-defrag.c | 3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
> >> index 3c0987ab587d..c12747904d4c 100644
> >> --- a/fs/btrfs/tree-defrag.c
> >> +++ b/fs/btrfs/tree-defrag.c
> >> @@ -65,8 +65,6 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
> >>               memcpy(&key, &root->defrag_progress, sizeof(key));
> >>       }
> >>
> >> -     path->keep_locks = 1;
> >> -
> >>       ret = btrfs_search_forward(root, &key, path, BTRFS_OLDEST_GENERATION);
> >
> > What does btrfs_search_forward do as the first statement:
> >
> > 5115 int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
> > 5116                          struct btrfs_path *path,
> > 5117                          u64 min_trans)
> > 5118 {
> > .... declarations
> > 5128
> > 5129         path->keep_locks = 1;
> >
> > So even if removed from above, there will be no change. The value of
> > keep_locks is preserved after btrfs_path_release.
> >
> 
> It will set it back,
> 
> out:
>         path->keep_locks = keep_locks;

Oh, right. So much for reading the whole function.
