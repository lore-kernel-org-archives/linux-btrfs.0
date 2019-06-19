Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482F9C31E5D
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 11:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221B721655
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 11:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbfFSLgM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 07:36:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:37198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727244AbfFSLgM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 07:36:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F00D7AEB3
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 11:36:10 +0000 (UTC)
Date:   Wed, 19 Jun 2019 06:36:08 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Evaluate io_tree in find_lock_delalloc_range()
Message-ID: <20190619113608.zy24txjcu42nzhb6@fiona>
References: <20190619003524.32377-1-rgoldwyn@suse.de>
 <8a7dd8d7-a918-b618-d8e2-bf0ff182cfdc@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a7dd8d7-a918-b618-d8e2-bf0ff182cfdc@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  9:05 19/06, Nikolay Borisov wrote:
> 
> 
> On 19.06.19 г. 3:35 ч., Goldwyn Rodrigues wrote:
> > Simplification.
> > No point passing the tree variable when it can be evaluated
> > from inode.
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> The patch is good, however, there are several calls to find_
> lock_delalloc_range in btrfs tests so you'd need to fix those 
> invocations, otherwise compilation of the in-kernel test suite will fails. 
> 
> fs/btrfs/tests/extent-io-tests.c:       found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> fs/btrfs/tests/extent-io-tests.c:       found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> fs/btrfs/tests/extent-io-tests.c:       found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> fs/btrfs/tests/extent-io-tests.c:       found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> fs/btrfs/tests/extent-io-tests.c:       found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> 
> 

Oh, I missed the test, even if it was listed as EXPORT_FOR_TESTS.
Looking at the tests, it seems it needs to work on a different io_tree than
in the inode. So, I suppose this patch should NOT be included for the sake
of tests. Perhaps we should use wrapper functions for simplifications.

-- 
Goldwyn
