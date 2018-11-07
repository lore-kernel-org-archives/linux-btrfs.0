Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C77C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 16:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9737720827
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 16:01:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9737720827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbeKHBcb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 20:32:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:59980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727668AbeKHBcb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 20:32:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2D05B65D;
        Wed,  7 Nov 2018 16:01:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA16ADAD1F; Wed,  7 Nov 2018 17:01:19 +0100 (CET)
Date:   Wed, 7 Nov 2018 17:01:19 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181107160119.GG24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> There's a race between close_ctree() and cleaner_kthread().
> close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> sees it set, but this is racy; the cleaner might have already checked
> the bit and could be cleaning stuff. In particular, if it deletes unused
> block groups, it will create delayed iputs for the free space cache
> inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> longer running delayed iputs after a commit. Therefore, if the cleaner
> creates more delayed iputs after delayed iputs are run in
> btrfs_commit_super(), we will leak inodes on unmount and get a busy
> inode crash from the VFS.
> 
> Fix it by parking the cleaner before we actually close anything. Then,
> any remaining delayed iputs will always be handled in
> btrfs_commit_super(). This also ensures that the commit in close_ctree()
> is really the last commit, so we can get rid of the commit in
> cleaner_kthread().
> 
> Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
> Signed-off-by: Omar Sandoval <osandov@fb.com>

I'll queue this patch for rc2 as it fixes crashes I see during testing.
My version does more changes and would be more suitable for a series,
that could actually document the shutdown sequence and add a few
assertions on top.

Reviewed-by: David Sterba <dsterba@suse.com>
