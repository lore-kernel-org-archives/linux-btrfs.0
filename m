Return-Path: <SRS0=1OQK=CF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225DAC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Aug 2020 12:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0886F22BF5
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Aug 2020 12:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgH0MnZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 08:43:25 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:43024 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbgH0MmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Aug 2020 08:42:12 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 35DDF1F66E;
        Thu, 27 Aug 2020 12:41:47 +0000 (UTC)
Date:   Thu, 27 Aug 2020 12:41:47 +0000
From:   Eric Wong <e@80x24.org>
To:     linux-btrfs@vger.kernel.org
Subject: adding new devices to degraded raid1
Message-ID: <20200827124147.GA16923@dcvr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I don't need to do it right away, but is it possible to add new
devices to a degraded raid1?

One thing I might do in the future is replace a broken big drive
with two small drives.  It may even be used to migrate to SSDs.

Since btrfs-replace only seems to do 1:1 replacements, and I
needed to physically remove an existing broken device to make
room for the replacements, could I do something like:

	mount -o degraded /mnt/foo
	btrfs device add small1 small2 /mnt/foo
	btrfs device remove broken /mnt/foo

?

Anyways, so far raid1 has been working great for me, but I have
some devices nearing 70K Power_On_Hours according to SMART

Thanks.
