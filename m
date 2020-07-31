Return-Path: <SRS0=krxf=BK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=BAYES_05,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4FAC433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 00:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7725C2083E
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 Jul 2020 00:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgGaAQx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Jul 2020 20:16:53 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:53642 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgGaAQw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Jul 2020 20:16:52 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 6B7931F5AE;
        Fri, 31 Jul 2020 00:16:52 +0000 (UTC)
Date:   Fri, 31 Jul 2020 00:16:52 +0000
From:   Eric Wong <e@80x24.org>
To:     linux-btrfs@vger.kernel.org
Subject: raid1 with several old drives and a big new one
Message-ID: <20200731001652.GA28434@dcvr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Say I have three ancient 2TB HDDs and one new 6TB HDD, is there
a way I can ensure one raid1 copy of the data stays on the new
6TB HDD?

I expect the 2TB HDDs to fail sooner than the 6TB HDD given
their age (>5 years).

The devid balance filter only affects data which already exists
on the device, so that isn't suitable for this, right?

Thanks in advance.
