Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52999 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751015AbdGLNn4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 09:43:56 -0400
Date: Wed, 12 Jul 2017 15:42:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        rgoldwyn@suse.de
Subject: Re: [PATCH] btrfs: qgroups: Fix BUG_ON condition
Message-ID: <20170712134242.GA2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <1499841739-18549-1-git-send-email-nborisov@suse.com>
 <9f2efc65-1972-e200-72ff-2ccf29da06d1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9f2efc65-1972-e200-72ff-2ccf29da06d1@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 03:09:42PM +0800, Qu Wenruo wrote:
> 
> 
> 在 2017年07月12日 14:42, Nikolay Borisov 写道:
> > The current code was erroneously checking for root_level > BTRFS_MAX_LEVEL. If
> > we had a root_level of 8 then the check won't trigger and we could
> > potentially hit a buffer overflow. The correct check should be
> > root_level >= BTRFS_MAX_LEVEL
> 
> Thanks for catching this.
> 
> Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> 
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> >   fs/btrfs/qgroup.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index 4ce351efe281..3b787915ef31 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -1603,7 +1603,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
> >   	struct extent_buffer *eb = root_eb;
> >   	struct btrfs_path *path = NULL;
> >   
> > -	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
> > +	BUG_ON(root_level < 0 || root_level >= BTRFS_MAX_LEVEL);
> >   	BUG_ON(root_eb == NULL);
> >   
> >   	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
> > @@ -2959,7 +2959,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode,
> >   	if (free && reserved)
> >   		return qgroup_free_reserved_data(inode, reserved, start, len);
> >   	extent_changeset_init(&changeset);
> > -	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
> > +	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
> >   			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
> 
> I didn't recongize it's a tailing white space at first.

The original code is from you, so please configure your editor to
hilight trailing whitespace. Whitespace damage happens, git am warns
about tha but git cherry-pick does not.

> Nice catch.

So before we start seeing patches that fix random whitespace in
unrelated code: please don't do that.

As you wrote, it was not obvious that there was no change on the line,
this just slowed down reading the patch.
