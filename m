Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043DEC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1C382081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:21:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1C382081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbeKFBlt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:41:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:50100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387438AbeKFBlt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:41:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C181B05B
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 16:21:22 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 40D27DAF91; Mon,  5 Nov 2018 17:21:10 +0100 (CET)
Date:   Mon, 5 Nov 2018 17:21:10 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Removal of optional hooks from struct extent_io_ops
Message-ID: <20181105162110.GZ9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:45PM +0200, Nikolay Borisov wrote:
> extent_io_ops has a set of 8 optional hooks which are set only for data and 
> freespace inodes. The majority of them actually deal with delallocs in one way 
> or another. Inspecting the code it transpired that there is actually no need to
> have them as function pointers in a structure. Data/freespace inodes can easily
> be distinguished from the btree_inode (which is pending removal anyway) by 
> inspecting extent_io_tree::private_data. This member is set by all data/freespace
> inodes. This series exploits this fact to remove the majority of them. Others, 
> such as fill_delalloc, writepage_start_hook and writepage_end_io_hook are always
> called from the data writeout path and can be directly called without having to
> check whether the respective pointers are set. 
> 
> This series has undergone multiple xfstest runs and no regressions were 
> identified. Additionally all but run_delalloc_range functions are given more 
> descriptive names, related to their actual intent. 
> 
> Nikolay Borisov (8):
>   btrfs: Remove extent_io_ops::fill_delalloc
>   btrfs: Remove extent_io_ops::writepage_start_hook
>   btrfs: Remove extent_io_ops::writepage_end_io_hook
>   btrfs: Remove extent_io_ops::check_extent_io_range callback
>   btrfs: Remove extent_io_ops::set_bit_hook extent_io callback
>   btrfs: Remove extent_io_ops::clear_bit_hook callback
>   btrfs: Remove extent_io_ops::merge_extent_hook callback
>   btrfs: Remove extent_io_ops::split_extent_hook callback

Added to misc-next, thanks.
