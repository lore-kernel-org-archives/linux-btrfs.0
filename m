Return-Path: <SRS0=UIME=2X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142E9C2D0DC
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 13:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E232420863
	for <linux-btrfs@archiver.kernel.org>; Thu,  2 Jan 2020 13:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgABNZO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 08:25:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:58302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgABNZN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Jan 2020 08:25:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6F39EAD49;
        Thu,  2 Jan 2020 13:25:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C48D3DA790; Thu,  2 Jan 2020 14:25:04 +0100 (CET)
Date:   Thu, 2 Jan 2020 14:25:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Check leaf chunk item size
Message-ID: <20200102132504.GF3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191217105820.20884-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217105820.20884-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 17, 2019 at 06:58:20PM +0800, Qu Wenruo wrote:
> Inspired by btrfs-progs github issue #208, where chunk item in chunk
> tree has invalid num_stripes (0).
> 
> Although that can already be catched by current btrfs_check_chunk_valid(),
> that function doesn't really check item size as it needs to handle chunk
> item in super block sys_chunk_array().
> 
> This patch will just add two extra checks for chunk items in chunk tree:
> - Basic chunk item size
>   If the item is smaller than btrfs_chunk (which already contains one
>   stripe), exit right now as reading num_stripes may even go beyond
>   eb boundary.
> 
> - Item size check against num_stripes
>   If item size doesn't match with calculated chunk size, then either the
>   item size or the num_stripes is corrupted. Error out anyway.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Added to misc-next, thanks.
