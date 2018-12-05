Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA90C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64E0A2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 06:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64E0A2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbeLEGkY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 01:40:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:49692 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbeLEGkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 01:40:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12D0FAEB4
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 06:40:22 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/13] btrfs-progs: Make W=1 great (no "again")
Date:   Wed,  5 Dec 2018 14:40:05 +0800
Message-Id: <20181205064018.27755-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
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

Now, we make "make W=1" great (may 'again' or not, depending on the
distribution rolling speed).

changelog:
v1.1:
- Use cc-disable-warning instead of putting -Wno-something to improve
  compatibility.
- Better explaination on the BUG_ON() branch caused uninitialized
  variable.
- Also cleanup free-space-tree.c

v2:
- Add reviewed-by tags, except the 7th patch, as it goes a different way
  to fix in v2.
- Fix bad port of cc-disable-warning, using $CFLAGS instead of kernel
  flags.
- Make sure fixed warnings still show in W=3.
- Use do {} while() loop to replace a while() {} loop, so even compiler
  doesn't have enough hint for BUG_ON(), it won't report uninitialized
  variable warning.

Qu Wenruo (12):
  btrfs-progs: Makefile.extrawarn: Import cc-disable-warning
  btrfs-progs: Makefile.extrawarn: Don't warn on sign compare
  btrfs-progs: Fix Wempty-body warning
  btrfs-progs: Fix Wimplicit-fallthrough warning
  btrfs-progs: Fix Wsuggest-attribute=format warning
  btrfs-progs: Fix Wmaybe-uninitialized warning
  btrfs-progs: Fix Wtype-limits warning
  btrfs-progs: Fix missing-prototypes warning caused by non-static
    functions
  btrfs-progs: Move btrfs_check_nodesize to fsfeatures.c to fix
    missing-prototypes warning
  btrfs-progs: Introduce rescue.h to resolve missing-prototypes for
    chunk and super rescue
  btrfs-progs: Add utils.h include to solve missing-prototypes warning
  btrfs-progs: free-space-tree: Remove unsued function

Su Yanjun (1):
  btrfs-progs: fix gcc8 default build warning caused by
    '-Wformat-truncation'

 Makefile            |  5 ++++
 Makefile.extrawarn  | 10 ++++++++
 btrfs.c             |  2 +-
 check/mode-lowmem.c |  6 ++---
 chunk-recover.c     |  1 +
 cmds-rescue.c       |  4 +--
 ctree.c             |  4 +--
 extent-tree.c       |  2 +-
 free-space-tree.c   | 59 ++++++++++++---------------------------------
 fsfeatures.c        | 23 ++++++++++++++++++
 messages.h          | 15 ++++++++----
 rescue.h            | 21 ++++++++++++++++
 send-stream.c       |  3 +--
 string-table.c      |  1 +
 super-recover.c     |  1 +
 utils-lib.c         |  1 +
 utils.c             | 53 +++++++++++++++++-----------------------
 17 files changed, 119 insertions(+), 92 deletions(-)
 create mode 100644 rescue.h

-- 
2.19.2

