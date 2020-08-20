Return-Path: <SRS0=L84K=B6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D70C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 15:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7C1206DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Aug 2020 15:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgHTPTV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 11:19:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:32982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729033AbgHTPTQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Aug 2020 11:19:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 927D4B6ED;
        Thu, 20 Aug 2020 15:19:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8C70EDA87C; Thu, 20 Aug 2020 17:18:04 +0200 (CEST)
Date:   Thu, 20 Aug 2020 17:18:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v5 1/4] btrfs: extent_io: do extra check for extent
 buffer read write functions
Message-ID: <20200820151804.GZ2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
References: <20200819063550.62832-1-wqu@suse.com>
 <20200819063550.62832-2-wqu@suse.com>
 <20200819171159.GT2026@twin.jikos.cz>
 <66f629fa-e636-6ab5-eda8-5299d996b2f4@suse.com>
 <20200820095024.GX2026@twin.jikos.cz>
 <1507884d-ad39-8edf-03fd-42e1d10f50e1@suse.com>
 <20200820144647.GY2026@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820144647.GY2026@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 20, 2020 at 04:46:47PM +0200, David Sterba wrote:
> On Thu, Aug 20, 2020 at 05:58:53PM +0800, Qu Wenruo wrote:
> 	check_add_overflow(start, len) || start + len > eb->len

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include <linux/overflow.h>
 #include "extent_io.h"
 #include "extent-io-tree.h"
 #include "extent_map.h"
@@ -5641,9 +5642,10 @@ static void report_eb_range(const struct extent_buffer *eb, unsigned long start,
 static inline int check_eb_range(const struct extent_buffer *eb,
                                 unsigned long start, unsigned long len)
 {
+       unsigned long offset;
+
        /* start, start + len should not go beyond eb->len nor overflow */
-       if (unlikely(start > eb->len || start + len > eb->len ||
-                    len > eb->len)) {
+       if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len)) {
                report_eb_range(eb, start, len);
                return -EINVAL;
        }
---
