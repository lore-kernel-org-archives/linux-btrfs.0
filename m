Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F50EC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 00:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4EF21473
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 00:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfDIAJu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 20:09:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:36542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbfDIAJu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 20:09:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88256AD26;
        Tue,  9 Apr 2019 00:09:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1BFCEDA88B; Tue,  9 Apr 2019 02:10:57 +0200 (CEST)
Date:   Tue, 9 Apr 2019 02:10:56 +0200
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix data bytes_may_use underflow with
 fallocate due to failed quota reserve
Message-ID: <20190409001056.GH29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <1553572571-15614-1-git-send-email-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553572571-15614-1-git-send-email-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 11:56:11AM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
> 
> When doing fallocate, we first add the range to the reserve_list
> and then reserve the quota.
> If quota reservation fails, we'll release all reserved parts of
> reserve_list.
> However, cur_offset is not updated to indicate that this
> range is already been inserted into the list.
> Therefore, the same range is freed twice.
> Once at list_for_each_entry loop, and once at the end of the
> function.
> This will result in WARN_ON on bytes_may_use when we free the
> remaining space.
> 
> At the end, under the 'out' label we have a call to:
>    btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
> alloc_end - cur_offset);
> The start offset, third argument, should be cur_offset.
> Everything from alloc_start to cur_offset was freed by the
> list_for_each_entry_safe_loop.
> 
> Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
> Signed-off-by: Robbie Ko <robbieko@synology.com>

Added to misc-next, thanks.
