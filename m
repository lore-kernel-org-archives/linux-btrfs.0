Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BEBC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 15:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8828220672
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 15:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8828220672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbeK0Cck (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 21:32:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:47480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbeK0Cck (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 21:32:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 69084AD05
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 15:38:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37E54DAD8F; Mon, 26 Nov 2018 16:37:53 +0100 (CET)
Date:   Mon, 26 Nov 2018 16:37:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove extent_io_ops::readpage_io_failed_hook
Message-ID: <20181126153753.GG2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181122081749.26146-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122081749.26146-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 10:17:49AM +0200, Nikolay Borisov wrote:
> For data inodes this hook does nothing but to return -EAGAIN which is
> used to signal to the endio routines that this bio belongs to a data
> inode. If this is the case the actual retrying is handled by
> bio_readpage_error. Alternatively, if this bio belongs to the btree
> inode then btree_io_failed_hook just does some cleanup and doesn't
> retry anything.
> 
> This patch simplifies the code flow by eliminating
> readpage_io_failed_hook and instead open-coding btree_io_failed_hook in
> end_bio_extent_readpage. Also eliminate some needless checks since IO is always
> performed on either data inode or btree inode, both of which are guaranteed to 
> have their extent_io_tree::ops set. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
