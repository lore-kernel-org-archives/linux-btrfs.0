Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2392DC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDB9213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 13:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfB0NHE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 08:07:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:41582 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726122AbfB0NHE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 08:07:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 456E2ADAA;
        Wed, 27 Feb 2019 13:07:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 08AD4DA83C; Wed, 27 Feb 2019 14:08:23 +0100 (CET)
Date:   Wed, 27 Feb 2019 14:08:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/2] Fix missing reference aborts when resuming snapshot
 delete
Message-ID: <20190227130823.GG24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190206204615.5862-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206204615.5862-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 06, 2019 at 03:46:13PM -0500, Josef Bacik wrote:
> With my delayed refs rsv patches in place we started hitting issues in our build
> servers that do a lot of snapshot deletions.  Turns out there was a bug in
> btrfs_end_transaction_throttle() that caused it to basically always commit the
> transaction, which uncovered this particular bug.
> 
> The gory details are in the change logs for both patches, but generally speaking
> it's a problem with how we update our root_item->drop_progress key.  We will
> skip updating it some times even though we will have dropped references to
> blocks.  If we crash or unmount at these times we will start at a point earlier
> in our delete than we should be and try to free blocks that we already freed,
> thus ending up with a transaction abort because we couldn't find the extent
> reference.
> 
> There are 2 patches, 1 patch to deal with already broken file systems, and 1
> patch to keep this problem from happening in the first place.
> 
> The steps to reproduce this easily are sort of tricky, I had to add a couple of
> debug patches to the kernel in order to make it easy, basically I just needed to
> make sure we did actually commit the transaction every time we finished a
> walk_down_tree/walk_up_tree combo.
> 
> The reproducer
> 
> 1) Creates a base subvolume.
> 2) Creates 100k files in the subvolume.
> 3) Snapshots the base subvolume (snap1).
> 4) Touches files 5000-6000 in snap1.
> 5) Snapshots snap1 (snap2).
> 6) Deletes snap1.
> 
> I do this with dm-log-writes, and then replay to every FUA in the log and fsck
> the fs.  Without these patches this falls over pretty quickly.  With just the
> first patch we can mount the fs at the point that the fsck fails and it cleans
> everything up properly.  With both patches applied the fsck never fails and
> we're golden.  Thanks,

I copied the reproducer steps to the 2nd patch. 1 and 2 added to
misc-next.
