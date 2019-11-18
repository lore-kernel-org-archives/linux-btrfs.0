Return-Path: <SRS0=0Ua4=ZK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B4CEC432C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 19:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F71D222F6
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Nov 2019 19:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfKRTLz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Nov 2019 14:11:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:46912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbfKRTLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Nov 2019 14:11:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74CE8B24A;
        Mon, 18 Nov 2019 19:11:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 90D74DAB3A; Mon, 18 Nov 2019 20:11:54 +0100 (CET)
Date:   Mon, 18 Nov 2019 20:11:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: do not corrupt the fs with rename exchange on a
 subvol
Message-ID: <20191118191154.GM3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20191115204306.3446-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115204306.3446-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 15, 2019 at 03:43:06PM -0500, Josef Bacik wrote:
> Testing with the new fsstress support for subvolumes uncovered a pretty
> bad problem with rename exchange on subvolumes.  We're modifying two
> different subvolumes, but we only start the transaction on one of them,
> so the other one is not added to the dirty root list.  This is caught by
> btrfs_cow_block() with a warning because the root has not been updated,
> however if we do not modify this root again we'll end up pointing at an
> invalid root because the root item is never updated.
> 
> Fix this by making sure we add the destination root to the trans list,
> the same as we do with normal renames.  This fixes the corruption.
> 
> Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
