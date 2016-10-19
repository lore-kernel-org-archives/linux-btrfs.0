Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936132AbcJSONt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 10:13:49 -0400
Date: Wed, 19 Oct 2016 16:02:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: pass correct args to
 btrfs_async_run_delayed_refs()
Message-ID: <20161019140200.GP11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161018075613.10757-1-wangxg.fnst@cn.fujitsu.com>
 <pan$9e691$50b48431$37da74db$d7e3b0a2@applied-asynchrony.com>
 <5806FD2F.1000609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5806FD2F.1000609@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 12:57:19PM +0800, Wang Xiaoguang wrote:
> hi,
> 
> On 10/18/2016 06:32 PM, Holger Hoffstätte wrote:
> > On Tue, 18 Oct 2016 15:56:13 +0800, Wang Xiaoguang wrote:
> >
> >> In btrfs_truncate_inode_items()->btrfs_async_run_delayed_refs(), we
> >> swap the arg2 and arg3 wrongly, fix this.
> >>
> >> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> >> ---
> >>   fs/btrfs/inode.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index 2b790bd..2f1372b 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -4605,8 +4605,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
> >>   			BUG_ON(ret);
> >>   			if (btrfs_should_throttle_delayed_refs(trans, root))
> >>   				btrfs_async_run_delayed_refs(root,
> >> -							     trans->transid,
> >> -					trans->delayed_ref_updates * 2, 0);
> >> +					trans->delayed_ref_updates * 2,
> >> +					trans->transid, 0);
> >>   			if (be_nice) {
> >>   				if (truncate_space_check(trans, root,
> >>   							 extent_num_bytes)) {
> > Reviewed-by: Holger Hoffstätte <holger@applied-asynchrony.com>
> >
> > Passing the wrong transid..why did this ever work?
> Indeed this bug just impacts asynchronous delayed refs handle when we 
> truncate
> inodes.  In delayed_ref_async_start(), there is such codes:
> 
>      trans = btrfs_join_transaction(async->root);
>      if (trans->transid > async->transid)
>          goto end;
>      ret = btrfs_run_delayed_refs(trans, async->root, async->count);
> 
>  From this codes, we can see that this just influence whether can we handle
> delayed refs or the number of delayed refs to handle, this may impact
> performance, but will not result in missing delayed refs, all delayed 
> refs will
> be handled in btrfs_commit_transaction().

You should put this kind of information to the changelog itself, now
added.
