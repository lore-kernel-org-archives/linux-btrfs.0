Return-Path: <SRS0=hLti=QP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB7BC169C4
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 16:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E43020821
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Feb 2019 16:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfBHQJA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:09:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:41058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfBHQJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Feb 2019 11:09:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D75DEACEA;
        Fri,  8 Feb 2019 16:08:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C9A76DA83D; Fri,  8 Feb 2019 17:08:18 +0100 (CET)
Date:   Fri, 8 Feb 2019 17:08:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20190208160817.GP2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 10:24:51AM -0500, Josef Bacik wrote:
> v1->v2:
> - addressed comments from reviewers.
> - fixed a bug in patch 6 that was introduced because of changes to upstream.
> 
> -- Original message --
> 
> The delayed refs rsv patches exposed a bunch of issues in our enospc
> infrastructure that needed to be addressed.  These aren't really one coherent
> group, but they are all around flushing and reservations.
> may_commit_transaction() needed to be updated a little bit, and we needed to add
> a new state to force chunk allocation if things got dicey.  Also because we can
> end up needed to reserve a whole bunch of extra space for outstanding delayed
> refs we needed to add the ability to only ENOSPC tickets that were too big to
> satisfy, instead of failing all of the tickets.  There's also a fix in here for
> one of the corner cases where we didn't quite have enough space reserved for the
> delayed refs we were generating during evict().  Thanks,

The patchset has been added to misc-next, I've updated the changelogs
and addressed the feedback from Nikolay.
