Return-Path: <SRS0=Mi70=X2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3437C352AA
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Oct 2019 16:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948DB2168B
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Oct 2019 16:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfJAQjM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Oct 2019 12:39:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:55574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfJAQjL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 07776B0C6;
        Tue,  1 Oct 2019 16:39:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5C4CDDA882; Tue,  1 Oct 2019 18:39:27 +0200 (CEST)
Date:   Tue, 1 Oct 2019 18:39:27 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: fix incorrect updating of log root tree
Message-ID: <20191001163927.GD2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, Chris Mason <clm@fb.com>
References: <20190930202725.1317-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930202725.1317-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 30, 2019 at 04:27:25PM -0400, Josef Bacik wrote:
> We've historically had reports of being unable to mount file systems
> because the tree log root couldn't be read.  Usually this is the "parent
> transid failure", but could be any of the related errors, including
> "fsid mismatch" or "bad tree block", depending on which block got
> allocated.
> 
> The modification of the individual log root items are serialized on the
> per-log root root_mutex.  This means that any modification to the
> per-subvol log root_item is completely protected.
> 
> However we update the root item in the log root tree outside of the log
> root tree log_mutex.  We do this in order to allow multiple subvolumes
> to be updated in each log transaction.
> 
> This is problematic however because when we are writing the log root
> tree out we update the super block with the _current_ log root node
> information.  Since these two operations happen independently of each
> other, you can end up updating the log root tree in between writing out
> the dirty blocks and setting the super block to point at the current
> root.
> 
> This means we'll point at the new root node that hasn't been written
> out, instead of the one we should be pointing at.  Thus whatever garbage
> or old block we end up pointing at complains when we mount the file
> system later and try to replay the log.
> 
> Fix this by copying the log's root item into a local root item copy.
> Then once we're safely under the log_root_tree->log_mutex we update the
> root item in the log_root_tree.  This way we do not modify the
> log_root_tree while we're committing it, fixing the problem.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Chris Mason <clm@fb.com>

Added to 5.4 queue, thanks.
