Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D828AC10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2476217FA
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 11:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388756AbfDRLhr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:37:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:43638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728074AbfDRLhr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:37:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38E9CAC84;
        Thu, 18 Apr 2019 11:37:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7DA87DA871; Thu, 18 Apr 2019 13:38:53 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:38:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: extent_io: Handle memory allocation failure in
 __clear_extent_bit()
Message-ID: <20190418113853.GJ20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
References: <20190418072114.4573-1-wqu@suse.com>
 <b2ff0fa1-9fec-46e1-75f5-e7903523063f@suse.com>
 <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f96176af-6e8a-4257-e49a-4ca2604e7226@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 03:30:20PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/18 下午3:24, Nikolay Borisov wrote:
> > 
> > 
> > On 18.04.19 г. 10:21 ч., Qu Wenruo wrote:
> >> There is a BUG_ON() in __clear_extent_bit() for memory allocation
> >> failure.
> >>
> >> While comment of __clear_extent_bit() says it can return error, but we
> >> always return 0.
> >>
> >> Some __clear_extent_bit() callers just ignore the return value, while
> >> some still expect error.
> >>
> >> Let's return proper error for this memory allocation anyway, to remove
> >> that BUG_ON() as a first step, so at least we can continue test.
> > 
> > I remember Josef did some changes into this code and said that prealloc
> > shouldn't fail because this will cause mayhem down the road i.e. proper
> > error handling is missing. If anything I think it should be added first
> > and then remove the BUG_ONs.
> 
> That's true, we could have some strange lockup due to
> lock_extent_bits(), as if some clear_extent_bits() failed due to ENOMEM
> and caller just ignore the error, we could have a lockup.

Not only lockup but unhandled failed extent range locking totally breaks
assumptions that the following code makes and this would lead to
unpredictable corruptions. Just count how many lock_extent_bits calls
are there. And any caller of __set_extent_bit. There are so many that
the BUG_ON is the measure of last resort to prevent worse problems.

> I'll try to pre-allocate certain amount of extent_state as the last
> chance of redemption.

This only lowers the chances to hit the allocation error but there's
always a case when certain amount + 1 would be needed.

> Anyway, such BUG_ON() right after kmalloc() is really a blockage for
> error injection test.

Maybe, but the code is not yet in the state to inject memory allocation
faiulres to that particular path (ie. the state changes).
