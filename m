Return-Path: <SRS0=7Ay/=BY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18625C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Aug 2020 14:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5AD320838
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Aug 2020 14:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHNOqM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Aug 2020 10:46:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:42694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgHNOqL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Aug 2020 10:46:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E20C9ABE2;
        Fri, 14 Aug 2020 14:46:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EAAABDA6EF; Fri, 14 Aug 2020 16:45:06 +0200 (CEST)
Date:   Fri, 14 Aug 2020 16:45:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 14/17] btrfs: introduce BTRFS_NESTING_NEW_ROOT for adding
 new roots
Message-ID: <20200814144506.GY2026@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200810154242.782802-1-josef@toxicpanda.com>
 <20200810154242.782802-15-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810154242.782802-15-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 10, 2020 at 11:42:39AM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -16,6 +16,11 @@
>  #define BTRFS_WRITE_LOCK_BLOCKING 3
>  #define BTRFS_READ_LOCK_BLOCKING 4
>  
> +/*
> + * We are limited in number of subclasses by MAX_LOCKDEP_SUBCLASSES, which at
> + * the time of this patch is 8, which is how many we're using here.  Keep this
> + * in mind if you decide you want to add another subclass.
> + */
>  enum btrfs_lock_nesting {
>  	BTRFS_NESTING_NORMAL = 0,
>  
> @@ -55,6 +60,15 @@ enum btrfs_lock_nesting {
>  	 * handle this case where we need to allocate a new split block.
>  	 */
>  	BTRFS_NESTING_SPLIT,
> +
> +	/*
> +	 * When promoting a new block to a root we need to have a special
> +	 * subclass so we don't confuse lockdep, as it will appear that we are
> +	 * locking a higher level node before a lower level one.  Copying also
> +	 * has this problem as it appears we're locking the same block again
> +	 * when we make a snapshot of an existing root.
> +	 */
> +	BTRFS_NESTING_NEW_ROOT,
>  };

To prevent accidental addition (and not reading the comment about the
maximum count), I suggest to use the static_assert with one extra
definition like

--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -14,11 +14,6 @@
 #define BTRFS_WRITE_LOCK 1
 #define BTRFS_READ_LOCK 2
 
-/*
- * We are limited in number of subclasses by MAX_LOCKDEP_SUBCLASSES, which at
- * the time of this patch is 8, which is how many we're using here.  Keep this
- * in mind if you decide you want to add another subclass.
- */
 enum btrfs_lock_nesting {
        BTRFS_NESTING_NORMAL = 0,
 
@@ -67,8 +62,19 @@ enum btrfs_lock_nesting {
         * when we make a snapshot of an existing root.
         */
        BTRFS_NESTING_NEW_ROOT,
+
+       /*
+        * We are limited in number of subclasses by MAX_LOCKDEP_SUBCLASSES,
+        * which at the time of this patch is 8, which is how many we're using
+        * here.  Keep this in mind if you decide you want to add another
+        * subclass.
+        */
+       BTRFS_NESTING_MAX
 };
 
+static_assert(BTRFS_NESTING_MAX <= MAX_LOCKDEP_SUBCLASSES,
+             "too many lock subclasses defined");
+
 struct btrfs_path;
 
 void __btrfs_tree_lock(struct extent_buffer *eb, enum btrfs_lock_nesting nest);
---
