Return-Path: <SRS0=VlvV=PF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E4BC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 15:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2777820879
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Dec 2018 15:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbeL1PAS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Dec 2018 10:00:18 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:38282 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbeL1PAR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Dec 2018 10:00:17 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id 2CCD65463; Fri, 28 Dec 2018 16:00:16 +0100 (CET)
Date:   Fri, 28 Dec 2018 16:00:16 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel traces
Message-ID: <20181228150016.GB13717@cuci.nl>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo wrote:
>On 2018/12/28 ??????9:40, Stephen R. van den Berg wrote:
>>> It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

>>> This is one of the easiest way to trigger an ABBA deadlock.

>>> Please either disable qgroup or apply this patch to solve it:
>>> https://patchwork.kernel.org/patch/10725371/

Ok, booting the system in v4.20 with this patch.  I'll report back if
it does not resolve the problem.
-- 
Stephen.
