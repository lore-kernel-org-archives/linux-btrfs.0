Return-Path: <SRS0=35yg=BE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BCFC433DF
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jul 2020 06:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46739206D8
	for <linux-btrfs@archiver.kernel.org>; Sat, 25 Jul 2020 06:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgGYGCc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 25 Jul 2020 02:02:32 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:37880 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgGYGCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Jul 2020 02:02:31 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id A947B1F5AE;
        Sat, 25 Jul 2020 06:02:31 +0000 (UTC)
Date:   Sat, 25 Jul 2020 06:02:31 +0000
From:   Eric Wong <e@80x24.org>
To:     linux-btrfs@vger.kernel.org
Subject: mixing raid1 and raid0?
Message-ID: <20200725055728.GA6238@dcvr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey all, I've started using btrfs recently with old HDDs of
various sizes in a btrfs raid1 pool.  It seems pretty good from
a flexibility and redundancy standpoint.

However, things like temporary files, caches, etc. don't need to
be raid1, and raid0 might allow me to reduce wear on HDDs; so
I'd like to make part of it raid0 while keeping most of it raid1.

If my btrfs is mounted as /mnt/btrfs, would the following do
what I want?

  btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/btrfs/precious
  btrfs balance start -dconvert=raid0 -mconvert=raid0 /mnt/btrfs/junk

Or should I make a separate FS for temporary and disposable
raid0 data?

Thanks
