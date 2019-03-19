Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1FBC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62883213F2
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 13:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCSNIg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:08:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:38504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfCSNIg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 09:08:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 19B80AD5D
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 13:08:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D7729DA8A7; Tue, 19 Mar 2019 14:09:49 +0100 (CET)
Date:   Tue, 19 Mar 2019 14:09:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Couple of coverity fixes
Message-ID: <20190319130948.GK3516@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190318154520.4086-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190318154520.4086-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 18, 2019 at 05:45:17PM +0200, Nikolay Borisov wrote:
> Here are 3 patches based on the latest coverity defect scans. Mostly minor, 
> quality-of-life type of fixes. One redundant assignment removal, 1 bounds 
> checking in qgroup and 1 possible overflow in qgroups please merge.  
> 
> Nikolay Borisov (3):
>   btrfs: Remove unused -EIO assignment in end_bio_extent_readpage
>   btrfs: Fix bound checking in qgroup_trace_new_subtree_blocks
>   btrfs: Avoid possible qgroup_rsv_size overflow in
>     btrfs_calculate_inode_block_rsv_size

Added to misc-next, thanks.
