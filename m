Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8CBC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 796AB206B2
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 13:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 796AB206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439843AbeKXAgZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 19:36:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:45686 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439840AbeKXAgY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 19:36:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6887AF9A;
        Fri, 23 Nov 2018 13:52:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8F19DA858; Fri, 23 Nov 2018 14:51:50 +0100 (CET)
Date:   Fri, 23 Nov 2018 14:51:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/6] btrfs: add cleanup_ref_head_accounting helper
Message-ID: <20181123135147.GD2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
References: <20181121185912.24288-1-josef@toxicpanda.com>
 <20181121185912.24288-3-josef@toxicpanda.com>
 <d35e384e-0564-7937-fa65-3a25b8296a05@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d35e384e-0564-7937-fa65-3a25b8296a05@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 09:06:30AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/11/22 上午2:59, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We were missing some quota cleanups in check_ref_cleanup, so break the
> > ref head accounting cleanup into a helper and call that from both
> > check_ref_cleanup and cleanup_ref_head.  This will hopefully ensure that
> > we don't screw up accounting in the future for other things that we add.
> > 
> > Reviewed-by: Omar Sandoval <osandov@fb.com>
> > Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/extent-tree.c | 67 +++++++++++++++++++++++++++++---------------------
> >  1 file changed, 39 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index c36b3a42f2bb..e3ed3507018d 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -2443,6 +2443,41 @@ static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> >  	return ret ? ret : 1;
> >  }
> >  
> > +static void cleanup_ref_head_accounting(struct btrfs_trans_handle *trans,
> > +					struct btrfs_delayed_ref_head *head)
> > +{
> > +	struct btrfs_fs_info *fs_info = trans->fs_info;
> > +	struct btrfs_delayed_ref_root *delayed_refs =
> > +		&trans->transaction->delayed_refs;
> > +
> > +	if (head->total_ref_mod < 0) {
> > +		struct btrfs_space_info *space_info;
> > +		u64 flags;
> > +
> > +		if (head->is_data)
> > +			flags = BTRFS_BLOCK_GROUP_DATA;
> > +		else if (head->is_system)
> > +			flags = BTRFS_BLOCK_GROUP_SYSTEM;
> > +		else
> > +			flags = BTRFS_BLOCK_GROUP_METADATA;
> > +		space_info = __find_space_info(fs_info, flags);
> > +		ASSERT(space_info);
> > +		percpu_counter_add_batch(&space_info->total_bytes_pinned,
> > +				   -head->num_bytes,
> > +				   BTRFS_TOTAL_BYTES_PINNED_BATCH);
> > +
> > +		if (head->is_data) {
> > +			spin_lock(&delayed_refs->lock);
> > +			delayed_refs->pending_csums -= head->num_bytes;
> > +			spin_unlock(&delayed_refs->lock);
> > +		}
> > +	}
> > +
> > +	/* Also free its reserved qgroup space */
> > +	btrfs_qgroup_free_delayed_ref(fs_info, head->qgroup_ref_root,
> > +				      head->qgroup_reserved);
> 
> This part will be removed in patch "[PATCH] btrfs: qgroup: Move reserved
> data account from btrfs_delayed_ref_head to btrfs_qgroup_extent_record".

We need to decide the order of merging if the patches touch the same
code. Your patch looks easier to refresh on top of this series, so
please hold on until this gets merged.
