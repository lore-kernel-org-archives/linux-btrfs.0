Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAC4C32789
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Aug 2022 11:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiHVLyO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 07:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiHVLyE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2022 07:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CAE1EEF5
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2022 04:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 336D76108B
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2022 11:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F657C433C1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2022 11:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661169230;
        bh=CjOjK4n5TCq1wWYYqrXy1+gmgCKkjxUfTURVo8P9K7k=;
        h=From:To:Subject:Date:From;
        b=s3Et/9wFzcaVfiklwfEespn2PjZdGsK/mN1z0Dd1FkEVuEJtwVhrNNBR68f9arcCv
         Td9w2u0wfRsx5bNXkDI16hqTZfYe1PC0nKkoJmKLTU6MNvba4hxTQ4TPZNzwZMZXr8
         F44RP74lKSx9BgGPPAuxkhvAvlO/Gn20+fYGNyub8YbGoiu8KfFjxbC7cfGXKp0iK6
         XsoJQBktKhi6medPCNBYeMOP+oc/a/mf9Rd1jzM89j/h81X3AlUNN9fP6WweVCZ5bn
         ibFLOh/4gER3xYTMCDyUR44Z0Kpyfc3MbqeNI94qLg5rnrRGKP4y/1mvHKJQvtiNp1
         y8ao9nULNhiyQ==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix lost error value deleting root reference
Date:   Mon, 22 Aug 2022 12:53:45 +0100
Message-Id: <cover.1661168931.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Fix a silent failure in case deleting a root reference fails when searching
for an item. Then make btrfs_del_root_ref() less likely to run into such
type of bug in the future. Details in the changelogs.

Filipe Manana (2):
  btrfs: fix silent failure when deleting root reference
  btrfs: simplify error handling at btrfs_del_root_ref()

 fs/btrfs/root-tree.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

-- 
2.35.1

