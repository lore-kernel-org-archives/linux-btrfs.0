Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F144FC4332F
	for <linux-btrfs@archiver.kernel.org>; Tue, 17 May 2022 10:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344694AbiEQKrs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 17 May 2022 06:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344675AbiEQKrj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 May 2022 06:47:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7407736308
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2022 03:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46756B8181D
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2022 10:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9B4C34100
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2022 10:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652784454;
        bh=q0OykQeCIAu7RwBBQ/P1cvBTKWozuCfVheJ5Y2FBZ6k=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=T7Q0/Jtpjf9BkKmIqORrM4UqvjhqZ3dZDS/UmcvrgdGwuoZ8gv3U4IzI32TCn31LQ
         PW7CcQnKbSRzgKLhpMeD5KUbx43WopN/hpJjU7cGjadR/vAXaOXMt1rkWZz/AE0AKd
         gCU/A+hjvZ2lHGvVhBpOTiKYNROSbFUj3aV8q3mFBqVFwNORVNScE5T8svR/CQZMXF
         FyULRaG4GUKgk6lMM0DjXBDXRYijWK8QMVwePJ6Bg8h/O4U5nuzEteYT6xIh9KFxaZ
         NrWlcv1f8mvr2RSQbuMtIxoaRdwiQNtWl45tr2yEYhxl9XiJSxdbtsFciJ/HuoB0Vr
         3PANJYOpcVV7w==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: teach send to avoid trashing the page cache with data
Date:   Tue, 17 May 2022 11:47:28 +0100
Message-Id: <cover.1652784088.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651770555.git.fdmanana@suse.com>
References: <cover.1651770555.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When doing a send operation, we read the data of all extents we need to
send into the page cache, which almost always is wasteful as it can lead
to eviction of other things from the page cache that are more useful for
applications (and maybe other kernel subsystems). This patchset makes send
evict the data from the page cache once it has sent it. The actual work
is in the second patch, while the first one is just preparatory work.
More details in the changelogs.

V2: Fixed it to work with subpage sector size. It was broken as we could
    end up zeroing out part of a page when extents are not sector size
    aligned. Reported by Qu.

Filipe Manana (2):
  btrfs: send: keep the current inode open while processing it
  btrfs: send: avoid trashing the page cache

 fs/btrfs/send.c | 133 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 114 insertions(+), 19 deletions(-)

-- 
2.35.1

