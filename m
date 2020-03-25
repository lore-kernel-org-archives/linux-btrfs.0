Return-Path: <SRS0=KM0e=5K=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022CEC1975A
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 15:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA8E20719
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Mar 2020 15:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCYPvE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 11:51:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:48308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727592AbgCYPvE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Mar 2020 11:51:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4806AE4D;
        Wed, 25 Mar 2020 15:51:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 716B6DA730; Wed, 25 Mar 2020 16:50:31 +0100 (CET)
Date:   Wed, 25 Mar 2020 16:50:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/5][v2] Deal with a few ENOSPC corner cases
Message-ID: <20200325155031.GE5920@twin.jikos.cz>
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

The patchset seems to be based on some other, code I think it's the
tickets for data chunks. The compilation fails because
BTRFS_RESERVE_FLUSH_DATA is not defined, but it's mentioned in several
patches.

If the base patchset is a hard requirement then both would need to go in
at the same time, otherwise if it's possible to refresh this branch I
could add it to for-next now.
