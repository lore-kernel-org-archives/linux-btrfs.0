Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7FBC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 18:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BF1921479
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 18:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfBSSKL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 13:10:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:45388 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfBSSKL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 13:10:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 43CF3AE8D;
        Tue, 19 Feb 2019 18:10:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E9726DA83C; Tue, 19 Feb 2019 19:11:31 +0100 (CET)
Date:   Tue, 19 Feb 2019 19:11:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH v2.1] btrfs: ensure that a DUP or RAID1 block group has
 exactly two stripes
Message-ID: <20190219181130.GT9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>
References: <210585b9-99e9-1548-f2b1-66445ab179bb@suse.de>
 <20190218102837.15219-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218102837.15219-1-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 11:28:37AM +0100, Johannes Thumshirn wrote:
> We recently had a customer issue with a corrupted filesystem. When trying
> to mount this image btrfs panicked with a division by zero in
> calc_stripe_length().
> 
> The corrupt chunk had a 'num_stripes' value of 1. calc_stripe_length()
> takes this value and divides it by the number of copies the RAID profile is
> expected to have to calculate the amount of data stripes. As a DUP profile
> is expected to have 2 copies this division resulted in 1/2 = 0. Later then
> the 'data_stripes' variable is used as a divisor in the stripe length
> calculation which results in a division by 0 and thus a kernel panic.
> 
> When encountering a filesystem with a DUP block group and a 'num_stripes'
> value unequal to 2, refuse mounting as the image is corrupted and will lead
> to unexpected behaviour.
> 
> Code inspection showed a RAID1 block group has the same issues.
> 
> Fixes: e06cd3dd7cea ("Btrfs: add validadtion checks for chunk loading")
> Cc: Liu Bo <obuil.liubo@gmail.com>
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Added to misc-next, thanks.
