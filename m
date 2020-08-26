Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA53C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B07162075E
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHZQNO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:13:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:50692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgHZQNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Aug 2020 12:13:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B3452B6FA;
        Wed, 26 Aug 2020 16:13:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7FB63DA730; Wed, 26 Aug 2020 18:11:58 +0200 (CEST)
Date:   Wed, 26 Aug 2020 18:11:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove alloc_list splice in btrfs_prepare_sprout
Message-ID: <20200826161158.GJ28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200812132646.9638-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812132646.9638-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Aug 12, 2020 at 04:26:46PM +0300, Nikolay Borisov wrote:
> btrfs_prepare_sprout is called when the first rw device is added to a
> seed filesystem. This means the filesystem can't have its alloc_list
> be non-empty, since seed filesystems are read only. Simply remove the
> code altogether.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Added to the rest of seed patches, thanks.
