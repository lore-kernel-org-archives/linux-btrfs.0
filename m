Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15ACFC10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA022082E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 15:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfDLPfN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:35:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:40844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726796AbfDLPfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 11:35:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B5E5ADE3;
        Fri, 12 Apr 2019 15:35:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3F001DA8D6; Fri, 12 Apr 2019 17:36:19 +0200 (CEST)
Date:   Fri, 12 Apr 2019 17:36:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 2/2] btrfs: Do mandatory tree block check before
 submitting bio
Message-ID: <20190412153618.GF3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Leonard Lausen <leonard@lausen.nl>,
        David Sterba <dsterba@suse.com>
References: <20190404034708.3399-1-wqu@suse.com>
 <20190404034708.3399-3-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404034708.3399-3-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 11:47:08AM +0800, Qu Wenruo wrote:
> @@ -514,6 +514,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	u8 result[BTRFS_CSUM_SIZE];
>  	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
>  	struct extent_buffer *eb;
> +	int err;

Please next time user 'ret' for newly added return values, I've fixed
that in the commit.
