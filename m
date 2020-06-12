Return-Path: <SRS0=a0ua=7Z=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8600FC433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Jun 2020 16:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70079207ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Jun 2020 16:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFLQsJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Jun 2020 12:48:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:59604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgFLQsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jun 2020 12:48:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B312AAC7;
        Fri, 12 Jun 2020 16:48:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6485DDA7C3; Fri, 12 Jun 2020 18:48:01 +0200 (CEST)
Date:   Fri, 12 Jun 2020 18:48:01 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Greed Rong <greedrong@gmail.com>
Subject: Re: [PATCH] btrfs: Share the same anonymous block device for the
 whole filesystem
Message-ID: <20200612164801.GV27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, Greed Rong <greedrong@gmail.com>
References: <20200612064237.13439-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612064237.13439-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 12, 2020 at 02:42:37PM +0800, Qu Wenruo wrote:
> For anonymous block device, we have at most 1 << 20 devices to allocate,
> which looks quite a lot, but if we have a workload which created 1
> snapshots per second, we only need 12 days to exhaust the whole pool.

1<<20 is 1M and that would mean that there that many snapshots active at
the same time in order to allocate all the anonymous block devices. Once
a snapshot is not part of any path the device number is released and can
be reused. So simply multiplying the numbers does not reflect the
reality.

A plausible explanation is leak of the anon bdev by something else than
btrfs on the system.
