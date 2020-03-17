Return-Path: <SRS0=Lj+Q=5C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D509AC1975A
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B660F206EC
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 Mar 2020 19:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgCQTwK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 15:52:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:51614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQTwJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Mar 2020 15:52:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDD79AC77;
        Tue, 17 Mar 2020 19:52:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 87D8DDA726; Tue, 17 Mar 2020 20:51:40 +0100 (CET)
Date:   Tue, 17 Mar 2020 20:51:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     robbieko <robbieko@synology.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix missing semaphore unlock
Message-ID: <20200317195140.GW12659@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, robbieko <robbieko@synology.com>,
        linux-btrfs@vger.kernel.org
References: <20200317063102.8869-1-robbieko@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317063102.8869-1-robbieko@synology.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 17, 2020 at 02:31:02PM +0800, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>

This is not a trivial patch that could go without a changelog.

> Fixes: aab15e8ec2576 ("Btrfs: fix rare chances for data loss when doing a fast fsync")
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> ---
>  fs/btrfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index a16da274c9aa..ae903da21588 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2124,6 +2124,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  	 */
>  	ret = start_ordered_ops(inode, start, end);
>  	if (ret) {
> +		up_write(&BTRFS_I(inode)->dio_sem);

I did not spot on first sight that there's was missing semaphore unlock
and a few lines below there's down_write(dio_sem). Turns out there are
two calls to start_ordered_ops, one before dio_sem and one inside the
locked section. So I solved the puzzle but I'd prefer not having to and
get a patch with instructions.
