Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C51CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24FF52084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24FF52084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cuci.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbeLLH0P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:26:15 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:45947 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbeLLH0P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:26:15 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id 48B405463; Wed, 12 Dec 2018 08:26:14 +0100 (CET)
Date:   Wed, 12 Dec 2018 08:26:14 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel traces
Message-ID: <20181212072614.GA9188@cuci.nl>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
 <20181211115226.GA20157@cuci.nl>
 <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRva5ZrF2pq93pb0_be7P+CE+0no-nJeQTXtEaq-LpfVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy wrote:
>Also, what scheduler are you using? And do you get different results
>with a different one (better or worse)?

I'm using CFQ, and I don't think I ever tried a different one.
But, btrfs should be compatible with all schedulers.
-- 
Stephen.
