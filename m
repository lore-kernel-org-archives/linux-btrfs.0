Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975BAC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E6E2184A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 14:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbfB1OkZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 09:40:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:52606 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbfB1OkZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 09:40:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 10AF3ACE7;
        Thu, 28 Feb 2019 14:40:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 85FFDDA944; Thu, 28 Feb 2019 15:41:44 +0100 (CET)
Date:   Thu, 28 Feb 2019 15:41:44 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] btrfs: extent_io: Always return error pointer for
 extent buffer allocation failure
Message-ID: <20190228144144.GF31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190225043801.17321-1-wqu@suse.com>
 <20190227170653.GZ24609@twin.jikos.cz>
 <2b6b667c-3457-2750-8ac9-07a8f2d13b26@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b6b667c-3457-2750-8ac9-07a8f2d13b26@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 10:08:57AM +0800, Qu Wenruo wrote:
> [snip]
> >>  	ret = radix_tree_preload(GFP_NOFS);
> >> -	if (ret)
> >> -		goto free_eb;
> >> +	if (ret) {
> >> +		btrfs_release_extent_buffer(eb);
> >> +		return ERR_PTR(ret);
> >> +	}
> >>  	spin_lock(&fs_info->buffer_lock);
> >>  	ret = radix_tree_insert(&fs_info->buffer_radix,
> >>  				start >> PAGE_SHIFT, eb);
> >> @@ -4875,21 +4892,26 @@ struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
> >>  	radix_tree_preload_end();
> >>  	if (ret == -EEXIST) {
> >>  		exists = find_extent_buffer(fs_info, start);
> >> -		if (exists)
> >> -			goto free_eb;
> >> -		else
> >> -			goto again;
> >> +		if (exists) {
> >> +			btrfs_release_extent_buffer(eb);
> >> +			return exists;
> >> +		}
> >> +		goto again;
> >>  	}
> >>  	check_buffer_tree_ref(eb);
> >>  	set_bit(EXTENT_BUFFER_IN_TREE, &eb->bflags);
> >>  
> >>  	return eb;
> >> -free_eb:
> >> -	btrfs_release_extent_buffer(eb);
> >> -	return exists;
> > 
> > Changes in this functions are more than just the conversion, namely
> > undoing the common exit block and adding the inline returns. These are
> > different logical things so I'd rather see that in a separate patch.
> > Thanks.
> 
> This part is not just undoing the goto branch.
> 
> For the error just after radix_tree_preload(GFP_NOFS), we're doing error
> out.
> 
> For the return after find_extent_buffer(), we're returning valid found eb.
> 
> The old code is abusing the exit for both error out and found case.
> Due to the change to ERR_PTR(), we can on longer follow that abuse any
> more, thus I have to remove the old free_eb label.

If you set exists to the ERR_PTR then the same code path is taken, this
is the exit block pattern. But the function is short and understandable
with the returns, so I'm ok with your version.
