Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41EBC433E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 11:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9B79206E3
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 11:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgHZLPy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 07:15:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:33556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbgHZLOx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Aug 2020 07:14:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7E49B1BE;
        Wed, 26 Aug 2020 11:15:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0F6CDA730; Wed, 26 Aug 2020 13:13:41 +0200 (CEST)
Date:   Wed, 26 Aug 2020 13:13:41 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Merge inode_can_compress in inode_need_compress
Message-ID: <20200826111341.GD28318@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200818063056.9094-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818063056.9094-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 18, 2020 at 09:30:56AM +0300, Nikolay Borisov wrote:
> The latter is the only caller of the former. Just open code can_compress
> into need_compress and also remove the warning since it's made redundant
> by this change.

We had discussions and some disagreements in the past regarding the
need/can compression helpers

(v1) https://lore.kernel.org/linux-btrfs/20180515073622.18732-1-wqu@suse.com/
(v2) https://lore.kernel.org/linux-btrfs/20190701051225.17957-1-wqu@suse.com/

The fix got merged as there was a pending user report and bug to fix,
but I remember there's more to do.

While this patch cleans up some of the code, I don't think it's going
the right way, we have 2 semantics for the compression decision and the
helpers codify that.

I haven't read the discussions yet again and will have to do that
before merging this patch.
