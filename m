Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4CCC282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCC932175B
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 22:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfA1WHZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 17:07:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:55882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbfA1WHZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 17:07:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A019B076;
        Mon, 28 Jan 2019 22:07:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 922A3DA78C; Mon, 28 Jan 2019 23:06:49 +0100 (CET)
Date:   Mon, 28 Jan 2019 23:06:48 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/7] Abort cleanup fixes
Message-ID: <20190128220648.GL2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181121190545.24798-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121190545.24798-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 02:05:38PM -0500, Josef Bacik wrote:
> A new xfstests that really hammers on transaction aborts (generic/495 I think?)
> uncovered a lot of random issues.  Some of these were introduced with the new
> delayed refs rsv patches, others were just exposed by them, such as the pending
> bg stuff.  With these patches in place I stopped getting all the random
> leftovers and WARN_ON()'s when running whichever xfstest that was and things are
> much smoother now.  Thanks,

FYI

in 5.0-rc:

- btrfs: wait on ordered extents on abort cleanup
- btrfs: handle delayed ref head accounting cleanup in abort

in misc-next:

- btrfs: make btrfs_destroy_delayed_refs use btrfs_delete_ref_head
- btrfs: make btrfs_destroy_delayed_refs use btrfs_delayed_ref_lock
- btrfs: call btrfs_create_pending_block_groups unconditionally

reworked as https://patchwork.kernel.org/patch/10784039/ :

- btrfs: cleanup pending bgs on transaction abort
- btrfs: just delete pending bgs if we are aborted
