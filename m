Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D90FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 10:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3969F20870
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 10:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="GlS37J18"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfCYKVp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 06:21:45 -0400
Received: from mail.synology.com ([211.23.38.101]:47988 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730484AbfCYKVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 06:21:44 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id 2019143E9A7E
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:21:43 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553509303; bh=eueeLYXr5TlYgtVkRr+IKQ21GLveGssjOpRPP3aHWbw=;
        h=Date:From:To:Subject:In-Reply-To:References;
        b=GlS37J18xhU7O2Mim3/vFJxL+CwgBn6inkzZJ96CBE6bMKPCduXRofdNkkAPzRKkU
         Gy7FfgQ9KL4REOnUc/+QBq4JVODnlE9jLG2W+yCbIJcmUdHlmyWuoLcPaXIt7+enYi
         ZSowXpQhg+jpurNud9T7FGHf/WOlQNlAduWqQKDM=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 25 Mar 2019 18:21:43 +0800
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix data bytes_may_use underflow with fallocate
 due to failed quota reserve
In-Reply-To: <1547435747-20013-1-git-send-email-robbieko@synology.com>
References: <1547435747-20013-1-git-send-email-robbieko@synology.com>
Message-ID: <37152188396716094fd3d7341555efb9@synology.com>
X-Sender: robbieko@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi All,
Can someone help review the patch ?
Thanks.

robbieko 於 2019-01-14 11:15 寫到:
> From: Robbie Ko <robbieko@synology.com>
> 
> When doing fallocate, we first add the range to the reserve_list
> and then reserve the qutoa.
> If quota reservation fails, we'll release all reserved parts of
> reserve_list.
> However, cur_offset doen't update to indicate that this range is
> already been inserted into the list.
> Therefore, the same range is freed twice.
> One at list_for_each_entry loop, and the other at the end of the
> function.
> This will result in WARN_ON on bytes_may_use when we free the
> remaining space.
> 
> Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index d38dc8c..43c6c8a 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, 
> int mode,
>  			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
>  					cur_offset, last_byte - cur_offset);
>  			if (ret < 0) {
> +				cur_offset = last_byte;
>  				free_extent_map(em);
>  				break;
>  			}



