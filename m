Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C3DC38145
	for <linux-btrfs@archiver.kernel.org>; Thu,  8 Sep 2022 11:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiIHLcD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 8 Sep 2022 07:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiIHLb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Sep 2022 07:31:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AB1C6FF0
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2022 04:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7EDAB820BF
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2022 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161F3C43141
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Sep 2022 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662636715;
        bh=wZHbIQdgUUWBy3f4cUqoA/eLv7zyB2E6w1Yq4iOMEzg=;
        h=From:To:Subject:Date:From;
        b=jU/bpBsao+giyGaC14iLsQBRZgdRun9+Rs3+VYSWw5/hzFzH+kekDJBsAI10uAi5I
         4+CF1A4FxBEN/iJAyt0riw8avozQVY0UQWJQW1a9F21UC/KA/zxgslnDBWUG+KME8w
         vxCTFvn70NTFnDli1nvRY0nWqQ/NL/KKjOaHGbJFFPvuhe0I5u/CkIX70Fob2FKYvX
         ZB86jFYtYbmP4el69nP3A9eap2ZvP7gts/wopGk+4LyWI3FgplMukTUAd/PuNacejg
         CeCeNbLY+7zAXQsWs3ZfqPBX9ZTfdNg+fzvPMMLk2vEePkoCyt8NzMAHzFPOcbon90
         wVarGPcjkbT3w==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: fix a couple of hangs during unmount caused by races
Date:   Thu,  8 Sep 2022 12:31:49 +0100
Message-Id: <cover.1662636489.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Due to some races or bad timmings, we can hang during unmount when trying
to stop the block group reclaim task or one of the space reclaim tasks.
The second case if often triggered by generic/562 for a while, but the
underlying problem has been there for a long time, despite seeming to be
more frequent recently. More details in the changelogs.

Filipe Manana (3):
  btrfs: fix hang during unmount when stopping block group reclaim worker
  btrfs: fix hang during unmount when stopping a space reclaim worker
  btrfs: remove useless used space increment during space reservation

 fs/btrfs/disk-io.c    | 42 ++++++++++++++++++++++++++++++++++++------
 fs/btrfs/space-info.c |  1 -
 2 files changed, 36 insertions(+), 7 deletions(-)

-- 
2.35.1

