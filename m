Return-Path: <SRS0=+IVA=WD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30532C32751
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 16:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C69521BF2
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Aug 2019 16:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbfHGQb2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Aug 2019 12:31:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:48038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387922AbfHGQb2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Aug 2019 12:31:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A33E8AF93;
        Wed,  7 Aug 2019 16:31:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 26B5ADA7D7; Wed,  7 Aug 2019 18:31:59 +0200 (CEST)
Date:   Wed, 7 Aug 2019 18:31:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] Migrate the block group code into it's own file
Message-ID: <20190807163158.GX28208@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20190806162837.15840-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806162837.15840-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 06, 2019 at 12:28:22PM -0400, Josef Bacik wrote:
> This is the rebased set of the much larger group of patches I sent last month.
> The first 10 patches are already merged, these just didn't apply cleanly.  I
> went through and applied each one, deleted and re-copied anything that didn't
> merge cleanly, and compiled between each patch to make sure everything was
> kosher.  This series just moves code around with the goal of making
> extent-tree.c smaller.  I made no other changes other than moving code around, I
> want to keep cleanups a separate thing _after_ we move the code around.  Thanks,

I had the remaining part of the previous patchset ready so I only
checked that this one is the same. The export of btrfs_get_alloc_profile
is in the patch "btrfs: migrate the block group read/creation code" and
the 15/15 is from unrelated patchset.

There were again conflicts with patches merged recently (sysfs and
device stats), I made sure the changes are not lost but this again
proves that large code moves need to be scheduled to the end of devel
cycle.
