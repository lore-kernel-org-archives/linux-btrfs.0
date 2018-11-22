Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFA6C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7E720684
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 13:13:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C7E720684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388712AbeKVXwi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 18:52:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:49842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbeKVXwi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 18:52:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1940B041;
        Thu, 22 Nov 2018 13:13:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D62A5DAB8E; Thu, 22 Nov 2018 14:12:59 +0100 (CET)
Date:   Thu, 22 Nov 2018 14:12:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix deadlock when enabling quotas due to
 concurrent snapshot creation
Message-ID: <20181122131257.GQ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181119094823.27346-1-fdmanana@kernel.org>
 <20181119141536.20748-1-fdmanana@kernel.org>
 <19a37acc-9b6f-7606-7ddd-2119b9bda207@gmx.com>
 <CAL3q7H5Zb7urzHfXUEEJQOeHJb8Uxkck35-5WAOggnYY=NkFMg@mail.gmail.com>
 <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b5c8646-42f7-e51d-e1f8-c28541558192@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 08:32:42AM +0800, Qu Wenruo wrote:
> >>> @@ -1013,16 +1013,22 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
> >>>               btrfs_abort_transaction(trans, ret);
> >>>               goto out_free_path;
> >>>       }
> >>> -     spin_lock(&fs_info->qgroup_lock);
> >>> -     fs_info->quota_root = quota_root;
> >>> -     set_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
> >>> -     spin_unlock(&fs_info->qgroup_lock);
> >>>
> >>>       ret = btrfs_commit_transaction(trans);
> >>>       trans = NULL;
> >>>       if (ret)
> >>>               goto out_free_path;
> >>
> >> The main concern here is, if we don't set qgroup enabled bit before we
> >> commit transaction, there will be a window where new tree modification
> >> could happen before QGROUP_ENABLED bit set.
> > 
> > That doesn't seem to make much sense to me, if I understood correctly.
> > Essentially you're saying stuff done to any tree in the the
> > transaction we use to
> > enable quotas must be accounted for. In that case the quota enabled bit should
> > be done as soon as the transaction is started, because before we set
> > it and after
> > we started (or joined) a transaction, a lot could of modifications may
> > have happened.
> > Nevertheless I don't think it's unexpected for anyone to have the
> > accounting happening
> > only after the quota enable ioctl returns success.
> 
> The problem is not accounting, the qgroup number won't cause problem.
> 
> It's the reserved space. Like some dirty pages are dirtied before quota
> enabled, but at run_dealloc() time quota is enabled.
> 
> For such case we have io_tree based method to avoid underflow so it
> should be OK.
> 
> So v2 patch looks OK.

Does that mean reviewed-by? In case there's a evolved discussion under a
patch, a clear yes/no is appreciated and an explicit Reviewed-by even
more. I'm about to add this patch to rc4 pull, thre's still some time to
add the tag. Thanks.
