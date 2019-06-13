Return-Path: <SRS0=BVwv=UM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C5BC31E4A
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Jun 2019 17:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA8CE2080A
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Jun 2019 17:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfFMRDZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Jun 2019 13:03:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:50378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393210AbfFMRDZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 480E2AFA5;
        Thu, 13 Jun 2019 17:03:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D2ACDA897; Thu, 13 Jun 2019 19:04:14 +0200 (CEST)
Date:   Thu, 13 Jun 2019 19:04:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: run delayed iput at unlink time
Message-ID: <20190613170412.GX3563@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190507172734.93994-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507172734.93994-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 07, 2019 at 01:27:34PM -0400, Josef Bacik wrote:
> We have been seeing issues in production where a cleaner script will end
> up unlinking a bunch of files that have pending iputs.  This means they
> will get their final iput's run at btrfs-cleaner time and thus are not
> throttled, which impacts the workload.
> 
> Since we are unlinking these files we can just drop the delayed iput at
> unlink time.  We are already holding a reference to the inode so this
> will not be the final iput and thus is completely safe to do at this
> point.  Doing this means we are more likely to be doing the final iput
> at unlink time, and thus will get the IO charged to the caller and get
> throttled appropriately without affecting the main workload.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Ping for updates.
