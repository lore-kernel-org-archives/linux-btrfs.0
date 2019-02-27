Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D25FAC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFAB20643
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 17:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfB0RZK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 12:25:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:39030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfB0RZK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 12:25:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D997AB87;
        Wed, 27 Feb 2019 17:25:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14526DA83C; Wed, 27 Feb 2019 18:26:30 +0100 (CET)
Date:   Wed, 27 Feb 2019 18:26:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix file corruption after snapshotting due to
 mix of buffered/DIO writes
Message-ID: <20190227172629.GB24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org
References: <20190204142810.1800-1-fdmanana@kernel.org>
 <20190227134230.11860-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227134230.11860-1-fdmanana@kernel.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 01:42:30PM +0000, fdmanana@kernel.org wrote:
> @@ -1897,15 +1899,45 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
>  	 * from already being in a transaction and our join_transaction doesn't
>  	 * have to re-take the fs freeze lock.
>  	 */
> -	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT))
> +	if (btrfs_test_opt(fs_info, FLUSHONCOMMIT)) {
>  		writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
> +	} else {
> +		struct btrfs_pending_snapshot *pending;
> +		struct list_head *head = &trans->transaction->pending_snapshots;
> +
> +		/*
> +		 * Flush dellaloc for any root that is going to be snapshotted.
> +		 * This is done to avoid a corrupted version of files, in the
> +		 * snapshots, that had both buffered and direct IO writes (even
> +		 * if they were done sequentially) due to an unordered update of
> +		 * the inode's size on disk.
> +		 */
> +		list_for_each_entry(pending, head, list)
> +			btrfs_start_delalloc_snapshot(pending->root);
> +	}

A diff would be better than words, incremental on top of your patch:

@@ -1912,8 +1912,15 @@ static inline int btrfs_start_delalloc_flush(struct btrfs_trans_handle *trans)
                 * if they were done sequentially) due to an unordered update of
                 * the inode's size on disk.
                 */
-               list_for_each_entry(pending, head, list)
-                       btrfs_start_delalloc_snapshot(pending->root);
+               list_for_each_entry(pending, head, list) {
+                       int ret;
+
+                       ret = btrfs_start_delalloc_snapshot(pending->root);
+                       if (ret < 0) {
+                               writeback_inodes_sb(fs_info->sb, WB_REASON_SYNC);
+                               break;
+                       }
+               }
        }
        return 0;
 }
---

Making a switch by the exact error is probably not necessary and wouldn't be
future proof anyway.
