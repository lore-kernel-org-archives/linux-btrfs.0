Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6CAC4338F
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Jul 2021 17:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D24560EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Jul 2021 17:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhGWQrA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:47:00 -0400
Received: from rin.romanrm.net ([51.158.148.128]:40722 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhGWQq7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jul 2021 12:46:59 -0400
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id DF96C15F;
        Fri, 23 Jul 2021 17:27:30 +0000 (UTC)
Date:   Fri, 23 Jul 2021 22:27:30 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow degenerate raid0/raid10
Message-ID: <20210723222730.1d23f9b4@natsu>
In-Reply-To: <20210723140843.GE19710@twin.jikos.cz>
References: <20210722192955.18709-1-dsterba@suse.com>
        <db9e2f31-73a5-0d0d-a1da-7acde6fb118e@gmx.com>
        <20210723140843.GE19710@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 23 Jul 2021 16:08:43 +0200
David Sterba <dsterba@suse.cz> wrote:

> > Can we slightly enhance the output?
> > RAID0/1 really looks like a new profile now, even the "1" really means
> > the number of device.
> 
> Do you have a concrete suggestion? This format was inspired by a
> discussion and suggested by users so I guess this is what people expect
> and I find it clear. It's also documented in manual page so if you think
> it's not clear or missing some important information, please let me
> know.

It really reads like another RAID level, easily confused with RAID10.

Or that it would flip between RAID0 and RAID1 depending on something.

Maybe something like RAID0d1?

-- 
With respect,
Roman
