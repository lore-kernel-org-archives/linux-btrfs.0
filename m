Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE13C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 13:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8FFB2087E
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 13:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbfARNkW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:40:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:40372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727017AbfARNkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 08:40:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AED6FAD04;
        Fri, 18 Jan 2019 13:40:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BD29EDA83D; Fri, 18 Jan 2019 14:39:50 +0100 (CET)
Date:   Fri, 18 Jan 2019 14:39:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
Message-ID: <20190118133950.GA2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116160057.22040-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 11:00:57AM -0500, Josef Bacik wrote:
> qgroups will do the old roots lookup at delayed ref time, which could be
> while walking down the extent root while running a delayed ref.  This
> should be fine, except we specifically lock eb's in the backref walking
> code irrespective of path->skip_locking, which deadlocks the system.
> Fix up the backref code to honor path->skip_locking, nobody will be
> modifying the commit_root when we're searching so it's completely safe
> to do.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Overnight test of the untar/snap/snapdel/rm stress test is fine now,
there's a lockdep warning in the logs that I think have seen already.
