Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB36C67839
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B002086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 18:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544637967;
	bh=Rw7X9dM8jJCquth7XW6EFxcisOacfHhPDGdjadIVGMk=;
	h=From:To:Subject:Date:List-ID:From;
	b=iU481VNv2j9909f1ErqnUMr7ciyMopUImSiNTcOKt/CrfmswcOWIkxKznK6kuW5nT
	 NgLyrlCFwgA2QRnTg5ZYkT0ewbaNEdgY0Lljsk1weTDAO0YjdhFNQS61jU6N5kX9JG
	 mOvmbG23dxwYqhucVPpoAoi/no+6995g371ragls=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75B002086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbeLLSGG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:06:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbeLLSGF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 13:06:05 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B54A2084E
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 18:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544637965;
        bh=Rw7X9dM8jJCquth7XW6EFxcisOacfHhPDGdjadIVGMk=;
        h=From:To:Subject:Date:From;
        b=VrorfjEHjnzUmY5TQh5A67b6vj9GclPBcbvaGKVECHbVDs5Rl9AOxcVGERiUyVPyh
         xuzJOqRlfHm3V0ONo9Y5CPJB/vCP3zApRctgEaEm34gitH5JDH6CKkO5UBRp9HrT4N
         IqCgTZ4oQNZSW7sjNMebDkgz/kXe3fnWVzWfAMi4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] Btrfs: a few more cleanups and fixes for clone/deduplication
Date:   Wed, 12 Dec 2018 18:05:55 +0000
Message-Id: <20181212180559.15249-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

This is a follow up to the recent change that makes btrfs use the generic
helper for cloning and deduplication [1]. It contains a mix of cleanups
and fixes, which existed before that change.

[1] Btrfs: use generic_remap_file_range_prep() for cloning and deduplication

Filipe Manana (4):
  Btrfs: move duplicated nodatasum check into common reflink/dedupe
    helper
  Btrfs: use cross mount point check for cloning and deduplication
  Btrfs: check if destination root is read-only for deduplication
  Btrfs: remove no longer needed range length checks for deduplication

 fs/btrfs/ioctl.c | 50 ++++++++++++++------------------------------------
 1 file changed, 14 insertions(+), 36 deletions(-)

-- 
2.11.0

