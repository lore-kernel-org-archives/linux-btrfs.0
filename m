Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF975C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15932075B
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfB0MEt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:04:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:59612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728916AbfB0MEt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 07:04:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35EC8AE15;
        Wed, 27 Feb 2019 12:04:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2C026DA83C; Wed, 27 Feb 2019 13:06:07 +0100 (CET)
Date:   Wed, 27 Feb 2019 13:06:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: move ulist allocation out of transaction in quota
 enable
Message-ID: <20190227120607.GD24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190225185544.14516-1-dsterba@suse.com>
 <CAL3q7H7L=183ndntoQLuUkPpmWgN1gmhS=vhiA23moP1Y7=0fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7L=183ndntoQLuUkPpmWgN1gmhS=vhiA23moP1Y7=0fQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 07:09:02PM +0000, Filipe Manana wrote:
> On Mon, Feb 25, 2019 at 6:58 PM David Sterba <dsterba@suse.com> wrote:
> >
> > The allocation happens with GFP_KERNEL after a transaction has been
> > started, this can potentially cause deadlock if reclaim tries to get the
> > memory by flushing filesystem data.
> >
> > The qgroup_ulist is not used during transaction start as the quotas are
> > not yet enabled but to provide the same semantics, use a temporary
> > variable and assign fs_info::qgroup_ulist as before.
> >
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >  fs/btrfs/qgroup.c | 14 ++++++++------
> >  1 file changed, 8 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> > index c1cd5558a646..9e49d5e132b8 100644
> > --- a/fs/btrfs/qgroup.c
> > +++ b/fs/btrfs/qgroup.c
> > @@ -887,6 +887,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
> >         struct btrfs_key found_key;
> >         struct btrfs_qgroup *qgroup = NULL;
> >         struct btrfs_trans_handle *trans = NULL;
> > +       struct ulist *tmp_ulist;
> >         int ret = 0;
> >         int slot;
> >
> > @@ -894,6 +895,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
> >         if (fs_info->quota_root)
> >                 goto out;
> >
> > +       tmp_ulist = ulist_alloc(GFP_KERNEL);
> > +       if (!tmp_ulist) {
> > +               ret = -ENOMEM;
> > +               goto out;
> > +       }
> 
> tmp_ulist needs to be freed if starting the transaction below fails.

Right. If I did not try to preserve the semantics (that does not seem to
be necessary), the freeing would happen on qgroup_ulist as before.

Starting transaction uses qgruop_ulist if quotas are enabled, so at this
time of btrfs_quota_enable, this is not yet true. The status bit is set
later.

I'll update the patch with this explanation and drop the temporary
variable.
