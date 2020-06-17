Return-Path: <SRS0=y2QO=76=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112B2C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 16:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96A721527
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Jun 2020 16:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgFQQjK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:39:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:49910 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgFQQjK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jun 2020 12:39:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BCC3CAC52;
        Wed, 17 Jun 2020 16:39:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3DB61DA728; Wed, 17 Jun 2020 18:38:59 +0200 (CEST)
Date:   Wed, 17 Jun 2020 18:38:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Refactor prealloc_file_extent_cluster
Message-ID: <20200617163859.GP27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200617091044.27846-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617091044.27846-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 17, 2020 at 12:10:41PM +0300, Nikolay Borisov wrote:
> Those 3 minor patches refactor prealloc_file_extent_cluster by:
> 
> 1. Removing useless check
> 2. Re-order code around to make heavyweight operations outside of inode lock,
> (not that it matters for performance) and also get rid of the out label
> 3. Switch a while to a for loop to make the loop intentino more explicit.
> 
> 
> Nikolay Borisov (3):
>   btrfs: Remove hole  check in prealloc_file_extent_cluster
>   btrfs: Perform data management operations outside of inode lock
>   btrfs: Use for loop in prealloc_file_extent_cluster

Added to misc-next, thanks.
