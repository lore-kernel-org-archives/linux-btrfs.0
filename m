Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C09C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 14:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FFC20863
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 14:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfB0OvX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:51:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:36848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726590AbfB0OvX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 09:51:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01233AECD;
        Wed, 27 Feb 2019 14:51:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D93BDDA83C; Wed, 27 Feb 2019 15:52:42 +0100 (CET)
Date:   Wed, 27 Feb 2019 15:52:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: Perform locking/unlocking in
 btrfs_remap_file_range()
Message-ID: <20190227145242.GO24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190225190744.21664-1-rgoldwyn@suse.de>
 <20190225190744.21664-3-rgoldwyn@suse.de>
 <CAL3q7H4JXORsxn5LB2ZK2Mg2wSyZcSgq3P4zFavN-nLQyn2V-A@mail.gmail.com>
 <20190226125717.6seq2y7vjbh5hyud@merlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226125717.6seq2y7vjbh5hyud@merlin>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 26, 2019 at 06:57:17AM -0600, Goldwyn Rodrigues wrote:
> On 12:08 26/02, Filipe Manana wrote:
> > On Mon, Feb 25, 2019 at 7:08 PM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> > >
> > > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > >
> > > Moves code to make it more readable, so as locking and unlocking is
> > > done in the same function.
> > >
> > > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > > ---
> > >  fs/btrfs/ioctl.c | 53 +++++++++++++++++++++--------------------------------
> > >  1 file changed, 21 insertions(+), 32 deletions(-)
> > >
> > > diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> > > index 9c8e1734429c..f0ae1af91ff3 100644
> > > --- a/fs/btrfs/ioctl.c
> > > +++ b/fs/btrfs/ioctl.c
> > > @@ -3975,22 +3975,6 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> > >         u64 wb_len;
> > >         int ret;
> > >
> > > -       if (!(remap_flags & REMAP_FILE_DEDUP)) {
> > > -               struct btrfs_root *root_out = BTRFS_I(inode_out)->root;
> > > -
> > > -               if (btrfs_root_readonly(root_out))xfs_reflink_remap_prep
> > > -                       return -EROFS;
> > > -
> > > -               if (file_in->f_path.mnt != file_out->f_path.mnt ||
> > > -                   inode_in->i_sb != inode_out->i_sb)
> > > -                       return -EXDEV;
> > > -       }
> > 
> > Why move these checks?
> > The goal of the _prep function (both btrfs and vfs)  is to have the
> > checks for all needed conditions in one place.
> 
> In the original flow, these checks were done without locks.
> But I suppose they can be done with locks held as well.

The locking does not affect the above checks, so no problem here.

> > 
> > As for the lock/unlock, it follows the same pattern from xfs
> > (xfs_reflink_remap_prep and xfs_file_remap_range).
> > No complaints about changing this, I'm just neutral about it.
> > 
> 
> I just read the xfs code and yes it is similar. Locking and unlocking
> in separate functions makes it difficult to read, especially
> when it can be done in the same function.
> 
> > > -
> > > -       if (same_inode)
> > > -               inode_lock(inode_in);
> > > -       else
> > > -               btrfs_double_inode_lock(inode_in, inode_out);
> > > -

But removing the checks from here can't be done because there's inode
compatibility flag check done right here (in current code, since commit
500710d3b872) but it's not in this diff.

Otherwise there's a race with chatter, once fixed by
b5c40d598f5408bd0ca22dfffa82f03cd9433f23 "Btrfs: fix clone vs chattr
NODATASUM race".
