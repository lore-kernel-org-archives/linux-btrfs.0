Return-Path: <SRS0=Vd0G=MH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88891C43382
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38CF820843
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Sep 2018 15:29:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38CF820843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbeIYVhL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:37:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:39944 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729315AbeIYVhL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 17:37:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1F683AED3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2018 15:29:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C80BEDAE2F; Tue, 25 Sep 2018 17:29:08 +0200 (CEST)
Date:   Tue, 25 Sep 2018 17:29:08 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: Use NAME_MAX to replace intermediate number
 of BTRFS_NAME_LEN
Message-ID: <20180925152908.GE3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180925000626.15474-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180925000626.15474-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 25, 2018 at 08:06:25AM +0800, Qu Wenruo wrote:
> Since we're following the name size limit of linux, just use NAME_MAX.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 53af9f5253f4..5ab6d1f6e055 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -65,7 +65,7 @@ struct btrfs_ordered_sum;
>   * we can actually store much bigger names, but lets not confuse the rest
>   * of linux
>   */
> -#define BTRFS_NAME_LEN 255
> +#define BTRFS_NAME_LEN NAME_MAX

While the values are the same, the symbolic names have a slightly
different meaning. NAME_MAX is from the public API, BTRFS_NAME_LEN is
defined as btrfs limit, and de facto part of the on-disk format. These
are independent, although compatible for all practical purposes. I would
not conflate the two in the define, the comment could be updated to
document that better though.
