Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C7BC433E0
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A46761554
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Mar 2021 18:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhC2Snh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:43:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:44166 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231420AbhC2SnU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Mar 2021 14:43:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7133DAFF4;
        Mon, 29 Mar 2021 18:43:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 63E28DA842; Mon, 29 Mar 2021 20:41:11 +0200 (CEST)
Date:   Mon, 29 Mar 2021 20:41:11 +0200
From:   David Sterba <dsterba@suse.cz>
To:     bingjingc <bingjingc@synology.com>
Cc:     josef@toxicpanda.com, dsterba@suse.com, quwenruo@cn.fujitsu.com,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, cccheng@synology.com,
        robbieko@synology.com
Subject: Re: [PATCH v2] btrfs: fix a potential hole-punching failure
Message-ID: <20210329184111.GS7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, bingjingc <bingjingc@synology.com>,
        josef@toxicpanda.com, dsterba@suse.com, quwenruo@cn.fujitsu.com,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, cccheng@synology.com,
        robbieko@synology.com
References: <1616637382-27311-1-git-send-email-bingjingc@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616637382-27311-1-git-send-email-bingjingc@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 25, 2021 at 09:56:22AM +0800, bingjingc wrote:
> From: BingJing Chang <bingjingc@synology.com>
> 
> In commit d77815461f04 ("btrfs: Avoid trucating page or punching hole
> in a already existed hole."), existed holes can be skipped by calling
> find_first_non_hole() to adjust *start and *len. However, if the given
> len is invalid and large, when an EXTENT_MAP_HOLE extent is found, the
> *len will not be set to zero because (em->start + em->len) is less than
> (*start + *len). Then the ret will be 1 but the *len will not be set to
> 0. The propagated non-zero ret will result in fallocate failure.
> 
> In the while-loop of btrfs_replace_file_extents(), len is not updated
> every time before it calls find_first_non_hole(). That is, after
> btrfs_drop_extents() successfully drops the last non-hole file extent,
> it may fail with -ENOSPC when attempting to drop a file extent item
> representing a hole. The problem can happen. After it calls
> find_first_non_hole(), the cur_offset will be adjusted to be larger
> than or equal to end. However, since the len is not set to zero. The
> break-loop condition (ret && !len) will not meet. After it leaves the
> while-loop, fallocate will return 1, which is an unexpected return
> value.
> 
> We're not able to construct a reproducible way to let
> btrfs_drop_extents() fail with -ENOSPC after it drops the last non-hole
> file extent but with remaining holes left. However, it's quite easy to
> fix. We just need to update and check the len every time before we call
> find_first_non_hole(). To make the while loop more readable, we also
> pull the variable updates to the bottom of loop like this:
> while (cur_offset < end) {
>         ...
>         // update cur_offset & len
>         // advance cur_offset & len in hole-punching case if needed
> }
> 
> Reported-by: Robbie Ko <robbieko@synology.com>
> Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a
> already existed hole.")
> Reviewed-by: Robbie Ko <robbieko@synology.com>
> Reviewed-by: Chung-Chiang Cheng <cccheng@synology.com>
> Signed-off-by: BingJing Chang <bingjingc@synology.com>

Thanks, added to misc-next.
