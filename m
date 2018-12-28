Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DB2C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 13:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCC020879
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 13:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbeL1NkI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 08:40:08 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:60487 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730444AbeL1NkI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 08:40:08 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id C95ED5463; Fri, 28 Dec 2018 14:40:06 +0100 (CET)
Date:   Fri, 28 Dec 2018 14:40:06 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel traces
Message-ID: <20181228134006.GA13717@cuci.nl>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo wrote:
>> Ok.  Finally have a sysrq+w output of 4.19.8.
>> The uptime of this system has been a few days.  It has already received quite
>> some btrfs-sends in that time (every night).  When the sysrq+w output was
>> taken, the system started to get more and more processes in a D kernel state
>> bordering on becoming unusable.  I had to hard-reset the system after this
>> to get it going again.

>It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

>This is one of the easiest way to trigger an ABBA deadlock.

>Please either disable qgroup or apply this patch to solve it:
>https://patchwork.kernel.org/patch/10725371/

Any idea in which kernel version this patch is/will be included?
-- 
Stephen.
