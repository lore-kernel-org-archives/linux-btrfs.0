Return-Path: <SRS0=IJ3x=Q3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 770B7C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5077220645
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Feb 2019 18:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbfBTSK3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:10:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:55468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726078AbfBTSK3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 13:10:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0C25B139;
        Wed, 20 Feb 2019 18:10:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BEEDEDA851; Wed, 20 Feb 2019 19:11:46 +0100 (CET)
Date:   Wed, 20 Feb 2019 19:11:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
Subject: Re: [PATCH v5.1 12/12] btrfs: Do mandatory tree block check before
 submitting bio
Message-ID: <20190220181144.GY9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>
References: <20190218052753.24138-1-wqu@suse.com>
 <20190218052753.24138-13-wqu@suse.com>
 <7a0248d2-754d-e352-796b-df41f9fbce53@suse.com>
 <21bfa550-7efb-5405-bb2c-01689567c788@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21bfa550-7efb-5405-bb2c-01689567c788@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 05:32:56PM +0800, Qu Wenruo wrote:
> [snip]
> >>
> >> Reported-by: Leonard Lausen <leonard@lausen.nl>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  fs/btrfs/disk-io.c      | 10 ++++++++++
> >>  fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
> >>  fs/btrfs/tree-checker.h |  8 ++++++++
> >>  3 files changed, 39 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >> index 6052ab508f84..fff789f8db63 100644
> >> --- a/fs/btrfs/disk-io.c
> >> +++ b/fs/btrfs/disk-io.c
> >> @@ -313,6 +313,16 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
> >>  			return -EUCLEAN;
> >>  		}
> >>  	} else {
> >> +		if (btrfs_header_level(buf))
> >> +			err = btrfs_check_node(fs_info, buf);
> >> +		else
> >> +			err = btrfs_check_leaf_write(fs_info, buf);
> >> +		if (err < 0) {
> >> +			btrfs_err(fs_info,
> >> +			"block=%llu write time tree block corruption detected",
> >> +				  buf->start);
> >> +			return err;
> >> +		}
> > 
> > This code should be moved in csum_dirty_buffer. Currently there is
> > pending cleanups in csum_tree_block and the final if there will be
> > removed and respective read/write code factored out in
> > csum_dirty_buffer/btree_readpage_end_io_hook.
> 
> I have no preference here.
> As long as the timing isn't changed, I'm fine either way.
> 
> But at least, from my last check on misc-next, there is no conflict at
> all. So the pending cleanup isn't so pending right now?

The pending changes are probably from Johannes, that are still in the
mailinglist and I haven't processed them yet (ie. no misc-next or
for-next). My plan is to merge your patchset first, the cleanups can be
adapted more easily. As the merge window is approaching, all of that
will happen in a week or two.
