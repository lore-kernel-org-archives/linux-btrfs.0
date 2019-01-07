Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B024C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 19:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0972147C
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 19:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbfAGTAT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 14:00:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:54922 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728043AbfAGTAT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 14:00:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 032BCAF3B
        for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2019 19:00:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29176DA7E8; Mon,  7 Jan 2019 19:59:45 +0100 (CET)
Date:   Mon, 7 Jan 2019 19:59:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce new mount option to skip block group
 items scan
Message-ID: <20190107185945.GC23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181220080137.22819-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220080137.22819-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 20, 2018 at 04:01:37PM +0800, Qu Wenruo wrote:
> Btrfs needs to read out all block group (bg) items to fill its bg
> caches.
> 
> However such bg caches are only needed for read-write mount, and makes
> no sense for RO mount.
> 
> So this patch introduce new mount option, skip_bg, to skip block group
> items scan.
> 
> This new 'skip_bg' mount option can only be used with TRUE read-only
> mount, which needs the following dependency:
> - RO mount
>   Obviously.
> 
> - No log tree or notreelog mount option
> 
> - No way to remoutn RW
>   Similar to notreelog mount option.
> 
> - No chunk <-> bg <-> dev extents restrict check
> 
> This option should only be used as kernel equivalent of btrfs-restore.
> 
> With this patch, we can even mount a btrfs whose extent root is
> completely corrupted.

So it's a last-resort rescue option, I'd suggest to make that more
explicit. Something like rescue=skip-bg. We can add all sorts of other
values that would relax some checks. Adding a separate mount option
would be quite impractical.

This would also align with the constraints you mention above, eg. no way
to remount RW. This is fine for the corrupted extent root. I wonder what
kind of metadata damage support would still make sense. a 'completely
corrupted extent root' means you never know what you get from the
filesystem.

The in-kernel checks and interconnection of the structures would have to
be ready for missing metadata or more sanity checks would need to be
added.

I think that all the restore and rescue functionality is better suited
for userspace where the unpredictable corruptions that cannot be parsed
do not lead to kernel crashes or silent memory overwrites.

> But can also be an option to test if btrfs_read_block_groups() is the
> major cause for slow btrfs mount.

We have a debugging/testing -only mount option 'fragment', so we may
consider adding more.
