Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBACCC71153
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Aug 2023 07:38:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjH1Hho (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 03:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjH1HhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2023 03:37:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CCFCC
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2023 00:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D630963281
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2023 07:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDCCC433CC
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2023 07:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693208239;
        bh=Q0HVFayl88Vakiuagwdr/4e5dRW9MGs2M71sG5REZiE=;
        h=From:To:Subject:Date:From;
        b=rRNQ5+GtunY/dHi5F7Zd/C3UWaxNm20liQHsBpr9ZNjtj5mBmCk/2wM5UbR0R2Dkg
         mNyuVfBDX4iWHRffNr579IJDyE20iw5gYeQR3fRNenve7WoEBe9s2Tm2lV7wOntZV1
         1WjsDAoc05wWVF5Duu2sHR68/8Sl7qnFdPA6wtUcikD/8HNy7gj6GL/MM9b4kus1FF
         jfnub6bE8Fdk4Glm32BfvZ/7QboiIFJHDXbx+bheRTZq+kUjdUOF0gv1BAYXMbpSP5
         yeVfyStHik883GNG126aQjr3LqHJXMldoAlGMw9ILI13zb4nnhh1KuE+Q98ltJd47F
         uflARG6F4DgRw==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: updates to error path for delayed dir index insertion failure
Date:   Mon, 28 Aug 2023 08:37:13 +0100
Message-Id: <cover.1693207973.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Some updates to the error path for delayed dir index insertion failure,
motivated by a recent syzbot report:

  https://lore.kernel.org/linux-btrfs/00000000000036e1290603e097e0@google.com/

Details in the changelogs.

Filipe Manana (2):
  btrfs: improve error message after failure to add delayed dir index item
  btrfs: remove BUG() after failure to insert delayed dir index item

 fs/btrfs/delayed-inode.c | 71 ++++++++++++++++++++++++++--------------
 1 file changed, 46 insertions(+), 25 deletions(-)

-- 
2.40.1

