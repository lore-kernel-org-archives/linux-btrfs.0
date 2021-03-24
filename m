Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B97C433C1
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Mar 2021 19:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2D5761A19
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Mar 2021 19:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhCXTbd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:31:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:33604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237661AbhCXTbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Mar 2021 15:31:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616614263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lP8NGhqEaai+6aYPvCkVl2K2vLbfGgrx+i52+vWs1uk=;
        b=VHI8QB3XQz340sRZBQfNmARJpm0vNat24LZ6dZD4IoO+1hx2dmnHgFsawt7vNNjVMtmP5A
        1c+wdeN513RZFoub73MBlQ2SgMMlhZ5VVHnVdi0HwJA3IkDVyN0zCDUo04ryolYOPdP2qX
        ZgSX/R4H2dw3x+zY8DcjjAvfE4cy8Os=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D7E65AD4A
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Mar 2021 19:31:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6AEBDDA732; Wed, 24 Mar 2021 20:28:58 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 5.11.1
Date:   Wed, 24 Mar 2021 20:28:58 +0100
Message-Id: <20210324192858.19011-1-dsterba@suse.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 5.11.1 have been released. This is a bugfix release.

Changelog:

  * properly format checksums when a mismatch is reported
  * check: fix false alert on tree block crossing 64K page boundary
  * convert:
    * refuse to convert filesystem with 'needs_recovery'
    * update documentation to require fsck before conversion
  * balance convert: fix raid56 warning when converting other profiles
  * fi resize: improved summary
  * other
    * build: fix checks and autoconf defines
    * fix symlink paths for CI support scripts
    * updated tests

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (10):
      btrfs-progs: ci: fix symlink paths of helper scripts
      btrfs-progs: tests: extend mkfs/001 to look for warnings after mkfs
      btrfs-progs: mkfs: enumerate all supported checksum algorithms in help text
      btrfs-progs: convert: refuse to convert filesystem with 'needs_recovery' set
      btrfs-progs: tests: add crafted image to test needs_recovery
      btrfs-progs: docs: change wording about required fsck
      btrfs-progs: balance: fix raid56 warning for other profiles
      btrfs-progs: tests: verify that ext4 supports extra_isize
      btrfs-progs: update CHANGES for 5.11.1
      Btrfs progs v5.11.1

Dāvis Mosāns (1):
      btrfs-progs: fix checksum output for "checksum verify failed"

Heiko Becker (1):
      btrfs-progs: build: Use PKG_CONFIG instead of pkg-config

Jaak Ristioja (1):
      btrfs-progs: check: fix typos in code comment and 1 typo in warning

Pierre Labastie (3):
      btrfs-progs: tests: fix quoting of sudo helper in misc/046-seed-multi-mount
      btrfs-progs: build: fix the test for EXT4_EPOCH_MASK
      btrfs-progs: build: do not use AC_DEFINE twice for a FIEMAP define

Qu Wenruo (1):
      btrfs-progs: fix false alert on tree block crossing 64K page boundary

Sidong Yang (1):
      btrfs-progs: fi resize: make output more readable

