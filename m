Return-Path: <SRS0=/gHX=5T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B651C43331
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFEB6206F8
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Apr 2020 15:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgDCPrG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 11:47:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:47408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728020AbgDCPrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Apr 2020 11:47:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9EAF0AD03;
        Fri,  3 Apr 2020 15:47:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6FD21DA727; Fri,  3 Apr 2020 17:46:30 +0200 (CEST)
Date:   Fri, 3 Apr 2020 17:46:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/5][v2] Deal with a few ENOSPC corner cases
Message-ID: <20200403154630.GF5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200313195809.141753-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313195809.141753-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 13, 2020 at 03:58:04PM -0400, Josef Bacik wrote:
> v1->v2:
> - Dropped "btrfs: only take normal tickets into account in
>   may_commit_transaction" because "btrfs: only check priority tickets for
>   priority flushing" should actually fix the problem, and Nikolay pointed out
>   that evict uses the priority list but is allowed to commit, so we need to take
>   into account priority tickets sometimes.
> - Added "btrfs: allow us to use up to 90% of the global rsv for" so that the
>   global rsv change was separate from the serialization patch.
> - Fixed up some changelogs.
> - Dropped an extra trace_printk that made it into v2.

Patchset moved to misc-next, thanks.
