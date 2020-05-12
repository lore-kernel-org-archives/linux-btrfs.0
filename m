Return-Path: <SRS0=txhb=62=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28170C54E8D
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 14:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123D1206F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 May 2020 14:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgELON3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 May 2020 10:13:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:36154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730303AbgELON0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 May 2020 10:13:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C80BAD7D
        for <linux-btrfs@vger.kernel.org>; Tue, 12 May 2020 14:13:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 90D7ADA70B; Tue, 12 May 2020 16:12:34 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Pending bugs for 5.7
Date:   Tue, 12 May 2020 16:12:34 +0200
Message-Id: <5e955017351005f2cc4c0210f401935203de8496c56cb76f53547d435f502803.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

there are some pending bugs that are either regressions or exposed after
changes in the 5.7 development cycle. At least the root leaks need to be fixed,
so patches with features are lower priority in case you wonder why yours hasn't
been merged or reviewed.

I'll post each as reply to this mail as they contain dumps of logs. The short
summary:

* root leaks

Recent updates switched from SRCU to refcounting and adde a tree root leak
detector, that reports leak in tests btrfs/125.

* corrupted leaf

For this one it's not clear if it's a regression or an old bug, reported by test
generic/457

* memory leaks

With KMEMLEAK turned on, there are several reports that there are leaks. It's
not clear if it's related to the root leaks.

* lockdep warnings

reproducible reports, our locks vs fs_reclaim, or just our locks
