Return-Path: <SRS0=vxqh=7C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03655C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 May 2020 06:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84C920756
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 May 2020 06:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgETG66 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 May 2020 02:58:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:42392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgETG66 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 May 2020 02:58:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 428E8ACBD
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2020 06:58:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: balance root leak and runaway balance fix
Date:   Wed, 20 May 2020 14:58:49 +0800
Message-Id: <20200520065851.12689-1-wqu@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset will fix the most wanted balance bug, runaway balance.
All my fault, and all small fixes.

The first patch fixes the root leakage and NULL pointer dereference
caused by it.

The second patch will fix the runaway balance and add alerting system to
prevent such problem from happening again.
The runaway fix depends on the root leakage fix, thus they are sent in a
patchset.

The first patch is just resent without any modification.

For backport to older kernels, the first patch needs small modification
to use atomic_t other than refcount_t.

Qu Wenruo (2):
  btrfs: relocation: Fix reloc root leakage and the NULL pointer
    reference caused by the leakage
  btrfs: relocation: Clear the DEAD_RELOC_TREE bit for orphan roots to
    prevent runaway balance

 fs/btrfs/disk-io.c    |  1 +
 fs/btrfs/relocation.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.26.2

