Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6166EC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 18:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3126820878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 18:05:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3126820878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbeLFSF5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 13:05:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:45320 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbeLFSF5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 13:05:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 406BDAF43;
        Thu,  6 Dec 2018 18:05:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9236DDAB92; Thu,  6 Dec 2018 19:05:35 +0100 (CET)
Date:   Thu, 6 Dec 2018 19:05:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/2] btrfs: catch cow on deleting snapshots
Message-ID: <20181206180534.GD23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
References: <20181130165214.17883-1-josef@toxicpanda.com>
 <20181130165214.17883-2-josef@toxicpanda.com>
 <CAL3q7H6o=TiqyiQ9Ljy8=4Gc9+-ww-S1ATc-MNq=8k3F_BsLzQ@mail.gmail.com>
 <20181130171917.oce3tpl6kjsujpia@macbook-pro-91.local.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130171917.oce3tpl6kjsujpia@macbook-pro-91.local.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 30, 2018 at 12:19:18PM -0500, Josef Bacik wrote:
> On Fri, Nov 30, 2018 at 05:14:54PM +0000, Filipe Manana wrote:
> > On Fri, Nov 30, 2018 at 4:53 PM Josef Bacik <josef@toxicpanda.com> wrote:
> > >
> > > From: Josef Bacik <jbacik@fb.com>
> > >
> > > When debugging some weird extent reference bug I suspected that we were
> > > changing a snapshot while we were deleting it, which could explain my
> > > bug.  This was indeed what was happening, and this patch helped me
> > > verify my theory.  It is never correct to modify the snapshot once it's
> > > being deleted, so mark the root when we are deleting it and make sure we
> > > complain about it when it happens.
> > >
> > > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > > ---
> > >  fs/btrfs/ctree.c       | 3 +++
> > >  fs/btrfs/ctree.h       | 1 +
> > >  fs/btrfs/extent-tree.c | 9 +++++++++
> > >  3 files changed, 13 insertions(+)
> > >
> > > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > > index 5912a97b07a6..5f82f86085e8 100644
> > > --- a/fs/btrfs/ctree.c
> > > +++ b/fs/btrfs/ctree.c
> > > @@ -1440,6 +1440,9 @@ noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
> > >         u64 search_start;
> > >         int ret;
> > >
> > > +       if (test_bit(BTRFS_ROOT_DELETING, &root->state))
> > > +               WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\n");
> > 
> > Please use btrfs_warn(), it makes sure we use a consistent message
> > style, identifies the fs, etc.
> > Also, "thats" should be "that is" or "that's".
> > 
> 
> Ah yeah, I was following the other convention in there but we should probably
> convert all of those to btrfs_warn.  I'll fix the grammer thing as well, just a
> leftover from the much less code of conduct friendly message I originally had
> there.  Thanks,

Committed with the following fixup:

-               WARN(1, KERN_CRIT "cow'ing blocks on a fs root thats being dropped\n");
+               btrfs_error(fs_info,
+                       "COW'ing blocks on a fs root that's being dropped");

