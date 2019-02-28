Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF34C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633382184A
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 16:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731196AbfB1QBe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:01:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:40688 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729880AbfB1QBe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 11:01:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1B86BAF3E;
        Thu, 28 Feb 2019 16:01:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 964F2DA944; Thu, 28 Feb 2019 17:02:53 +0100 (CET)
Date:   Thu, 28 Feb 2019 17:02:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] btrfs: Fix possible NULL pointer dereference in btrfs
 selftest
Message-ID: <20190228160253.GK31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190222005350.7535-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222005350.7535-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 08:53:50AM +0800, Qu Wenruo wrote:
> When CONFIG_BTRFS_FS_RUN_SANITY_TESTS is enabled, btrfs will run
> selftest at module load time.
> 
> During selftest, we allocate extent buffer using
> alloc_test_extent_buffer(), instead of alloc_test_extent_buffer().
> 
> The problem is, unlike alloc_extent_buffer(),
> alloc_test_extent_buffer() can return NULL pointer instead of error
> pointer, and callers all expect error pointer other than NULL pointer.
> 
> So this could lead to NULL pointer dereference during selftest.
> 
> Fix it by returning error pointer in alloc_test_extent_buffer().
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This patch is obsoleted by https://patchwork.kernel.org/patch/10828221/
"btrfs: extent_io: Always return error pointer for extent buffer
allocation failure", right?
