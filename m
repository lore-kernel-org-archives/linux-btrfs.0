Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47739 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751993AbcIFClp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 22:41:45 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>, "'Sean Fu'" <fxinrong@gmail.com>,
        <dsterba@suse.com>
CC: <clm@fb.com>, <anand.jain@oracle.com>, <fdmanana@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com> <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com> <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
In-Reply-To: <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
Subject: RE: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment in btrfs_read_chunk_tree.
Date: Tue, 6 Sep 2016 10:41:15 +0800
Message-ID: <003701d207e8$23f26160$6bd72420$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Qu Wenruo

> From: Qu Wenruo [mailto:quwenruo@cn.fujitsu.com]
> Sent: Monday, September 05, 2016 3:57 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>; 'Sean Fu' <fxinrong@gmail.com>;
> dsterba@suse.com
> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
> linux-btrfs@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root
> assignment in btrfs_read_chunk_tree.
> 
> 
> 
> At 09/05/2016 09:19 AM, Zhao Lei wrote:
> > Hi, Sean Fu
> >
> >> From: Sean Fu [mailto:fxinrong@gmail.com]
> >> Sent: Sunday, September 04, 2016 7:54 PM
> >> To: dsterba@suse.com
> >> Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
> >> zhaolei@cn.fujitsu.com; linux-btrfs@vger.kernel.org;
> >> linux-kernel@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
> >> Subject: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
> in
> >> btrfs_read_chunk_tree.
> >>
> >> The input argument root is already set with "fs_info->chunk_root".
> >> "chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info)" in caller
> >> "open_ctree".
> >> “root->fs_info = fs_info” in "btrfs_alloc_root".
> >>
> > The root argument of this function means "any root".
> > And the function is designed getting chunk root from
> > "any root" in head.
> >
> > Since there is only one caller of this function,
> > and the caller always send chunk_root as root argument in
> > current code, we can remove above conversion,
> > and I suggest renaming root to chunk_root to make it clear,
> > something like:
> >
> > - btrfs_read_chunk_tree(struct btrfs_root *root)
> > + btrfs_read_chunk_tree(struct btrfs_root *chunk_root)
> 
> Since root is only used to get fs_info->chunk_root, why not use fs_info
> directly?
> 
Good idea.

Thanks
Zhaolei

> Thanks,
> Qu
> 
> >
> > Thanks
> > Zhaolei
> >
> >> Signed-off-by: Sean Fu <fxinrong@gmail.com>
> >> ---
> >>  fs/btrfs/volumes.c | 2 --
> >>  1 file changed, 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index 366b335..384a6d2 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root
> *root)
> >>  	int ret;
> >>  	int slot;
> >>
> >> -	root = root->fs_info->chunk_root;
> >> -
> >>  	path = btrfs_alloc_path();
> >>  	if (!path)
> >>  		return -ENOMEM;
> >> --
> >> 2.6.2
> >>
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >



