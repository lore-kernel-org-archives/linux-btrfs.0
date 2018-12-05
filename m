Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3C4C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C9EF2082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C9EF2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbeLEONK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:13:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:44008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbeLEONK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 09:13:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 72B29AEE5
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 14:13:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A3351DAB92; Wed,  5 Dec 2018 15:12:49 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 4.19.1
Date:   Wed,  5 Dec 2018 15:12:49 +0100
Message-Id: <20181205141249.3498-1-dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 4.19.1 have been released.  There are build fixes, minor
update to libbtrfsutil and documentation updates.

Changes since 4.19.1-rc1: fix typos in CHANGES

Changes:

  * build fixes
    * big-endian builds fail due to bswap helper clashes
    * 'swap' macro is too generic, renamed to prevent build failures
  * libbtrfs
    * minor version update to 1.1.0
    * fix default search to top=0 as documented
    * rename 'async' to avoid future python binding problems
    * add support for unprivileged subvolume listing ioctls
    * added tests, API docs
  * other
    * lot of typos fixed
    * warning cleanups
    * doc formatting updates
    * CI tests against zstd 1.3.7

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (7):
      btrfs-progs: kerncompat: rename swap to __swap
      btrfs-progs: README: add link to INSTALL
      btrfs-progs: docs: fix rendering of exponents in manual pages
      btrfs-progs: link to libbtrfsutil/README from the main README
      btrfs-progs: tests: pull zstd version 1.3.7 to the travis CI
      btrfs-progs: update CHANGES for v4.19.1
      Btrfs progs v4.19.1

Josh Soref (11):
      btrfs-progs: docs: fix typos in Documentation
      btrfs-progs: docs: fix typos in READMEs, INSTALL and CHANGES
      btrfs-progs: fix typos in Makefile
      btrfs-progs: tests: fix typos in test comments
      btrfs-progs: tests: fsck/025, fix typo in helpre name
      btrfs-progs: fix typos in comments
      btrfs-progs: fix typos in user-visible strings
      btrfs-progs: check: fix typo in device_extent_record::chunk_objectid
      btrfs-progs: utils: fix typo in a variable
      btrfs-progs: mkfs: fix typo in "multipler" variables
      btrfs-progs: fix typo in btrfs-list function export

Omar Sandoval (10):
      libbtrfsutil: use top=0 as default for SubvolumeIterator()
      libbtrfsutil: change async parameters to async_ in Python bindings
      libbtrfsutil: document qgroup_inherit parameter in Python bindings
      libbtrfsutil: use SubvolumeIterator as context manager in tests
      libbtrfsutil: add test helpers for dropping privileges
      libbtrfsutil: allow tests to create multiple Btrfs instances
      libbtrfsutil: relax the privileges of subvolume_info()
      libbtrfsutil: relax the privileges of subvolume iterator
      libbtrfsutil: bump version to 1.1.0
      libbtrfsutil: document API in README

Rosen Penev (3):
      btrfs-progs: kernel-lib: bitops: Fix big endian compilation
      btrfs-progs: task-utils: Fix comparison between pointer and integer
      btrfs-progs: treewide: Fix missing declarations

