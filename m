Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE673C433FE
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Oct 2022 12:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJKMRQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 08:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJKMRP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2022 08:17:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8302422FC
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2022 05:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6497F60AF5
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2022 12:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ADBC433C1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2022 12:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665490632;
        bh=D6vHve3xncaAwhLjL7/FdoJ3tP07QLUwXKvAxYfEg0Q=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Wq9JmYFu0XzwV8+pdAtMMxaQ8L7NjHT7BSKGh9+yT4mbyBnXQKgeEIsrTa19T4qwK
         HR78i3Rfcxr/4rOoJMuM/HKHBZWuHOCuDJkxZ5DMKAbfFwFm9kNPyj2iCq8PiYN3fr
         2d+VSPSfYujU3nDmgxyDvzvJ89Q2gAH5sXIoE1DY4d70bfAm1czvbQtPKr4dPdmZpy
         KIZtPMqyWNZUxNsBsw0aGLS5p6x+cfAL9AjK3wwYQHCoB+WPvETBu1xoj7PRg4J7L0
         kSIuxdNcO7YwUB34oDDZPpHmmxXIwGnHLllN5rHOy8XdE3xzv/wiO3UHTAxwHUqO43
         j6LwhpNUZn6BQ==
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/19] btrfs: fixes, cleanups and optimizations around fiemap
Date:   Tue, 11 Oct 2022 13:16:50 +0100
Message-Id: <cover.1665490018.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1665396437.git.fdmanana@suse.com>
References: <cover.1665396437.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The first 3 patches are bug fixes, the first two fixing bugs in backref
walking that have been around since 2013 and 2017, respectively, while the
third one fixes a bug introduced in this merge window.

The remaining are performance optimizations in the fiemap code path, as
well as some cleanups and refactorings to support them. Results and tests
are found in the changelogs of individual patches (06/19, 16/19, 18/19
and 19/19).

V2: Add one more patch to fix a long standing bug (since 2013) regarding
    delayed data references during backref walking. Made it first patch
    in the series since later patches touched the surrounding code and
    it should backported to stable releases.

Filipe Manana (19):
  btrfs: fix processing of delayed data refs during backref walking
  btrfs: fix processing of delayed tree block refs during backref walking
  btrfs: ignore fiemap path cache if we have multiple leaves for a data extent
  btrfs: get the next extent map during fiemap/lseek more efficiently
  btrfs: skip unnecessary extent map searches during fiemap and lseek
  btrfs: skip unnecessary delalloc search during fiemap and lseek
  btrfs: drop pointless memset when cloning extent buffer
  btrfs: drop redundant bflags initialization when allocating extent buffer
  btrfs: remove checks for a root with id 0 during backref walking
  btrfs: remove checks for a 0 inode number during backref walking
  btrfs: directly pass the inode to btrfs_is_data_extent_shared()
  btrfs: turn the backref sharedness check cache into a context object
  btrfs: move ulists to data extent sharedness check context
  btrfs: remove roots ulist when checking data extent sharedness
  btrfs: remove useless logic when finding parent nodes
  btrfs: cache sharedness of the last few data extents during fiemap
  btrfs: move up backref sharedness cache store and lookup functions
  btrfs: avoid duplicated resolution of indirect backrefs during fiemap
  btrfs: avoid unnecessary resolution of indirect backrefs during fiemap

 fs/btrfs/backref.c    | 489 ++++++++++++++++++++++++++++--------------
 fs/btrfs/backref.h    |  55 ++++-
 fs/btrfs/extent_io.c  |  68 +++---
 fs/btrfs/extent_map.c |  31 ++-
 fs/btrfs/extent_map.h |   2 +
 fs/btrfs/file.c       |  69 ++++--
 6 files changed, 483 insertions(+), 231 deletions(-)

-- 
2.35.1

