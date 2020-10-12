Return-Path: <SRS0=ZkVs=DT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23EBC433E7
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Oct 2020 10:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78B1E20E65
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Oct 2020 10:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602500131;
	bh=THqTnzjoFF00nQOSkNqmDFfGHLEGVwGSGqrqT97k/kg=;
	h=From:To:Subject:Date:List-ID:From;
	b=04X8Uqn4gPWaOizUXfqMLmhI2c8iiO1CuGhWXgvxUg9UdUFXcTwcKi6w6I5uYutq7
	 5jwdfUCcBtD94Iwb6q8xy8UGALpeba1u7MVU1TotIRbHYfI/kqBLoBtYqOJ8gKKPOU
	 QY16AqkyJX7hQcJs4mw7vKnaqsKITAv9HTldxUss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387706AbgJLKza (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 06:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJLKza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Oct 2020 06:55:30 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81C9D206B6
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2020 10:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602500130;
        bh=THqTnzjoFF00nQOSkNqmDFfGHLEGVwGSGqrqT97k/kg=;
        h=From:To:Subject:Date:From;
        b=WXmYazCtQDI5dg+YN4aPZHwFXkeQAmp7W1Zb4OVZARZEurcAb3E9r+AMFHVKRpmjc
         VKlD2Stovv7WAckN//Gu80AM2HQ+WMwdCUratjXlB5Fwgx5easF/FinEg9pzckQHFT
         O0tf33rktd/yAfrGmdGr9ZNHhAkcNiZ0tJj2iZDQ=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: some readhead fixes after removing or replacing a device
Date:   Mon, 12 Oct 2020 11:55:22 +0100
Message-Id: <cover.1602499587.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This patchset fixes use-after-free bugs and a hang after a device is removed
or replaced. The hang only happens if a device replace happens while a scrub
is running (on a device other then the source device of the replace operation),
while the use-after-free bugs can happen without scrub involved.

The two first patches are the actual bug fixes, while the third patch just
adds a lockdep assertion and the fourth and last patch just makes scrub not
trigger readahead of the csums tree when it's not needed.

Filipe Manana (4):
  btrfs: fix use-after-free on readahead extent after failure to create
    it
  btrfs: fix readahead hang and use-after-free after removing a device
  btrfs: assert we are holding the reada_lock when releasing a readahead
    zone
  btrfs: do not start readahead for csum tree when scrubbing non-data
    block groups

 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/dev-replace.c |  5 +++++
 fs/btrfs/reada.c       | 49 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/scrub.c       | 20 ++++++++++-------
 fs/btrfs/volumes.c     |  3 +++
 fs/btrfs/volumes.h     |  1 +
 6 files changed, 72 insertions(+), 8 deletions(-)

-- 
2.28.0

