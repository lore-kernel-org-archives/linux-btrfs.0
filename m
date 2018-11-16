Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FD7C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86505208E7
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 07:54:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86505208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbeKPSFq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:05:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:46124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbeKPSFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 13:05:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9CEF8ABDC
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 07:54:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/9] btrfs-progs: Make W=1 clean (no "again")
Date:   Fri, 16 Nov 2018 15:54:17 +0800
Message-Id: <20181116075426.4142-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/warning_fixes
Which is based on v4.19 tag.

This patchset will make "make W=1" reports no warning.

This patch will first introduce fix to Makefile.extrawarn to make
"cc-disable-warning" works, then disable sign-compare warning
completely, as we really don't want extra "unsigned" prefix to slow our
typing.

Then re-use (ok, in fact rework) Yanjun's patch to disable
formwat-truncation warning.

Finally, fix all the remaining warnings reported by make W=1.

Now, we make "make W=1" clean (may 'again' or not, depending on the
distribution rolling speed).

Qu Wenruo (8):
  btrfs-progs: Makefile.extrawarn: Import cc-disable-warning
  btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
  btrfs-progs: Fix Wempty-body warning
  btrfs-progs: Fix Wimplicit-fallthrough warning
  btrfs-progs: Fix Wsuggest-attribute=format warning
  btrfs-progs: Fix Wmaybe-uninitialized warning
  btrfs-progs: Fix Wtype-limits warning
  btrfs-progs: Cleanup warning reported by -Wmissing-prototypes except
    free space tree

Su Yanjun (1):
  btrfs-progs: fix gcc8 default build warning caused by
    '-Wformat-truncation'

 Makefile            |  1 +
 Makefile.extrawarn  |  9 ++++++-
 btrfs.c             |  2 +-
 check/mode-lowmem.c |  6 ++---
 chunk-recover.c     |  1 +
 cmds-rescue.c       |  4 +--
 ctree.c             |  3 ++-
 extent-tree.c       |  2 +-
 free-space-tree.c   | 59 ++++++++++++---------------------------------
 fsfeatures.c        | 22 +++++++++++++++++
 messages.h          | 15 ++++++++----
 rescue.h            | 14 +++++++++++
 send-stream.c       |  3 +--
 string-table.c      |  1 +
 super-recover.c     |  1 +
 utils-lib.c         |  1 +
 utils.c             | 53 +++++++++++++++++-----------------------
 17 files changed, 105 insertions(+), 92 deletions(-)
 create mode 100644 rescue.h

-- 
2.19.1

