Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67462ECAAD8
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Sep 2022 16:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234966AbiIAQMx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 12:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiIAQMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2022 12:12:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581B35F11B;
        Thu,  1 Sep 2022 09:12:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACA9361F5F;
        Thu,  1 Sep 2022 16:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400E0C433B5;
        Thu,  1 Sep 2022 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662048763;
        bh=VsWmNkcYV7RTMwpyTPLBGKGsbZZpqllgdmLClVlD/MA=;
        h=From:To:Cc:Subject:Date:From;
        b=aNlyD7OcYETd6j8zJ9pBdDU19eHpzO/+S5nFVyxZobAaiFlgS04o8BR3ldt9w1bcF
         cKHV/PU+s965sXsww/ZNZxDMkVpz2M+jBm/Y8NBYzgVGwukT/g75VzfST0qjskCw6l
         kdwxMusWouWjGEoYHfu0qJIFa89qfDs2bsEZIGFJZ2ngE7JxQHEci+s9oKoborUrJw
         AX1vpDrLDTCskAqsKUp+J4eGl/qmvEie5SAcmGn6cF1ifdhYUdxurkEukcN1XrgKyb
         zDXJZktcNMcsKcXt3VQG05xuHYkeAp8BTVLp7Xv2eQOtQzPpxl/FFEyrVX8zMVw/tv
         Hp7I+f6BWXQYg==
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs: remove 'seek' group from btrfs/007
Date:   Thu,  1 Sep 2022 17:12:25 +0100
Message-Id: <bc7149309a8eca5999f22477a838602023094cb8.1662048451.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

btrfs/007 does not test lseek, it tests send/receive and lseek is not
exercised anywhere in this test. So just remove it from the 'seek' group.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/007 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/007 b/tests/btrfs/007
index ed7d143a..c4a8d9d0 100755
--- a/tests/btrfs/007
+++ b/tests/btrfs/007
@@ -13,7 +13,7 @@
 owner=list.btrfs@jan-o-sch.net
 
 . ./common/preamble
-_begin_fstest auto quick rw metadata send seek
+_begin_fstest auto quick rw metadata send
 
 # Override the default cleanup function.
 _cleanup()
-- 
2.35.1

