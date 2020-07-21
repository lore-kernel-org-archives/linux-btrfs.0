Return-Path: <SRS0=UEav=BA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1F5C433E8
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 16:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADE82077D
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 16:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbgGUQBv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:01:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:53540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgGUQBu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jul 2020 12:01:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E19A4AEF8;
        Tue, 21 Jul 2020 16:01:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9F060DA70B; Tue, 21 Jul 2020 18:01:23 +0200 (CEST)
Date:   Tue, 21 Jul 2020 18:01:23 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH][v2] btrfs: return -EROFS for BTRFS_FS_STATE_ERROR cases
Message-ID: <20200721160123.GN3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Sandeen <esandeen@redhat.com>
References: <20200721143837.3535-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721143837.3535-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 21, 2020 at 10:38:37AM -0400, Josef Bacik wrote:
> Eric reported seeing this message while running generic/475
> 
> BTRFS: error (device dm-3) in btrfs_sync_log:3084: errno=-117 Filesystem corrupted
> 
> This ret came from btrfs_write_marked_extents().  If we get an aborted
> transaction via an -EIO somewhere, we'll see it in
> btree_write_cache_pages() and return -EUCLEAN, which we spit out as
> "Filesystem corrupted".  Except we shouldn't be returning -EUCLEAN here,
> we need to be returning -EROFS.  -EUCLEAN is reserved for actual
> corruption, not IO errors.
> 
> We are inconsistent about our handling of BTRFS_FS_STATE_ERROR
> elsewhere, but we want to use -EROFS for this particular case.  The
> original transaction abort has the real error code for why we ended up
> with an aborted transaction, all subsequent actions just need to return
> -EROFS because they may not have a trans handle and have no idea about
> the original cause of the abort.
> 
> Reported-by: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

I've added full stacktrace from my logs and the patch is now ordered
after patch that filters EROFS in transaction abort. Thanks.
