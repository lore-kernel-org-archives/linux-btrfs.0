Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044ADC282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2A752192C
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 08:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbfAYIEt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:04:49 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:60398 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfAYIEs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 03:04:48 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id DDCB25463; Fri, 25 Jan 2019 09:04:46 +0100 (CET)
Date:   Fri, 25 Jan 2019 09:04:46 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New hang (Re: Kernel traces), sysreq+w output
Message-ID: <20190125080446.GB27316@cuci.nl>
References: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
 <20181212072614.GA9188@cuci.nl>
 <CAJCQCtSCcM0YTtp0f1i=FmrFigsfJEsr+Excwm=YHx4_wN49gg@mail.gmail.com>
 <20181228092036.GA30363@cuci.nl>
 <9b81647b-66c2-9870-161f-084b7d41af9c@gmx.com>
 <20181228134006.GA13717@cuci.nl>
 <e816d264-839b-a2b0-9787-755a6ac2d103@gmx.com>
 <20181228150016.GB13717@cuci.nl>
 <20190123155046.GA8995@cuci.nl>
 <20190125080137.GA27316@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125080137.GA27316@cuci.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Stephen R. van den Berg wrote:
>Stephen R. van den Berg wrote:
>>Stephen R. van den Berg wrote:
>>>Qu Wenruo wrote:
>>>>>> It's caused by qgroup, and a dead lock on btrfs_drop_snapshot().

>>>>>> Please either disable qgroup or apply this patch to solve it:
>>>>>> https://patchwork.kernel.org/patch/10725371/

>>>Ok, booting the system in v4.20 with this patch.  I'll report back if
>>>it does not resolve the problem.

I'm running v4.20.0 with this patch on this system, BTW.
-- 
Stephen.
