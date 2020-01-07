Return-Path: <SRS0=KPg5=24=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A98C33C8C
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D78CE222D9
	for <linux-btrfs@archiver.kernel.org>; Tue,  7 Jan 2020 15:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgAGPXw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 7 Jan 2020 10:23:52 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51965 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgAGPXw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2020 10:23:52 -0500
Received: from [10.5.225.158] (unknown [176.54.23.134])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 5A9FD20000A;
        Tue,  7 Jan 2020 15:23:47 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     <dsterba@suse.cz>
CC:     <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Date:   Tue, 07 Jan 2020 18:23:45 +0300
Message-ID: <16f809ac7e8.2bfa.85c738e3968116fc5c0dc2de74002084@kernel.wtf>
In-Reply-To: <20200106155328.GK3929@twin.jikos.cz>
References: <20200103184739.26903-1-cengiz@kernel.wtf>
 <20200106155328.GK3929@twin.jikos.cz>
User-Agent: AquaMail/1.22.0-1511 (build: 102200004)
Subject: Re: [PATCH] fs: btrfs: prevent unintentional int overflow
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On January 6, 2020 18:53:40 David Sterba <dsterba@suse.cz> wrote:

> The overflow can't happen in practice. Taking generous maximum value for
> an item and sectorsize (64K) and doing the math will reach nowhere the
> overflow limit for 32bit type:
>
> 64K / 4 * 64K = 1G

I didn't know that. Thanks for sharing.

> I'm not sure if this is worth adding the cast, or mark the coverity
> issue as not important.

If the cast is adding any overhead (which I don't think it does) I would 
kindly request adding it for the sake of completeness.

For example: if some newbie like me tries adding something, they would be 
warned that we should consider possible overflows and/or at least be 
careful with expressions that contain different sized integers.

If this sounds unnecessary, I will help with marking the Coverity issue as 
unimportant.

Thank you!



