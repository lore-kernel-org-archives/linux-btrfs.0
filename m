Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFAAC4332F
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Nov 2022 16:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiKOQZc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 11:25:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiKOQZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2022 11:25:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5702BCE26
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 08:25:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF712618E5
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 16:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EB2C433D6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668529529;
        bh=qzoPgMv8ySdaMygjih+9ZiHnRHlCbiktFRPD2gL625c=;
        h=From:To:Subject:Date:From;
        b=f8hFfWOmbrf+wtHuS8lNADkVGf0DAtI9WwNaqQLbY5VdrFahndwRjtfVP4C3Obf+J
         J++9pINSbX6+V9dqMCYVUT+q2cf40kNCt1DzcfYlAiblbV4bs9V6xz+KPp0yeVVabf
         4Ba5UeBjT+K12KQVaRWjvasrwD5jY7bHbYTu3Plwwo2lDCpLs4vLul6KsZ7dLMdhux
         N6/PXjrYU9TH/mwgFIj4LhAOJgvkNFP4hvB/POYaOSUzxFO1Q3qHnRaQq3MoEUXKwI
         nRp/ufMxCNYQrJ9q3Lr5OmjXBAHog0kFXhBi447ydl92EDV7/OOibe4ZGjO3bQyrxu
         rSqkt7lQ4YxyQ==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: receive: fix a silent data loss bug with encoded writes
Date:   Tue, 15 Nov 2022 16:25:23 +0000
Message-Id: <cover.1668529099.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

When using a v2 stream, with encoded writes, if the receiver fails to
perform an encoded write, it fallbacks to decompressing the data and then
write it using regular buffered IO. However that logic is currenty buggy,
and it can result in writing less data than expected or no data at all.
This results in a silent data loss.

Patch 3/3 fixes that bug and has all the details about how/why it happens,
while previous patches just added debug messages to the callbacks for
encoded writes and fallocate, which are currently missing and are very
useful for debugging.

Filipe Manana (3):
  btrfs-progs: receive: add debug messages when processing encoded writes
  btrfs-progs: receive: add debug messages when processing fallocate
  btrfs-progs: receive: fix silent data loss after fall back from encoded write

 cmds/receive.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

-- 
2.35.1

