Return-Path: <SRS0=WhU1=6V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E6C38A24
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 12:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D28C20CC7
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 May 2020 12:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgEGMHi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:07:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:48144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgEGMHi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 May 2020 08:07:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B213ABC7
        for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2020 12:07:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CBCD9DA732; Thu,  7 May 2020 14:06:46 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 5.6.1
Date:   Thu,  7 May 2020 14:06:46 +0200
Message-Id: <20200507120646.12602-1-dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 5.6.1 have been released.

The hilight of this minor release is the warning about multiple block groups
profiles, printed by several commands:

  WARNING: Multiple block group profiles detected, see 'man btrfs(5)'.
  WARNING:   Data: single, raid1

And the summary of 'fi usage' prints:

  Multiple profiles:                 yes      (data)

This might need some fine tuning, or more to be put to documenation but
I think the current status is ok so let's get it out to get feedback
eventually.

Changelog:

  * print warning when multiple block group profiles exist, update 'fi usage'
    summary, add docs to maual page explaining the situation
  * build: optional support for libgcrypt or libsodium, providing hash
    implementations
  * other:
    * fixed, updated and new tests
    * cleanups
    * updated docs

No change since rc1.

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

Alexandru Ungureanu (2):
      btrfs-progs: docs: improved asciidoc syntax to fix rendering issues
      btrfs-progs: docs: add example on deleting a subvolume

Anand Jain (1):
      btrfs-progs: tests: drop trailing slash from TEST_TOP path

David Sterba (19):
      btrfs-progs: remove obsolete fs_info::fs_mutex
      btrfs-progs: move backref.[ch] to kernel-shared/
      btrfs-progs: add more hash implementation providers
      btrfs-progs: docs: clarify mount options
      btrfs-progs: tests: enhance README
      btrfs-progs: tests: add coverage for multiple profiles warning
      btrfs-progs: remove unused function btrfs_check_for_mixed_profiles_by_path
      btrfs-progs: rename helpers for multiple block group checks
      btrfs-progs: unexport btrfs_get_string_for_multiple_profiles
      btrfs-progs: simplify string dump of block group profiles
      btrfs-progs: simplify string separator checks in sprint_profiles
      btrfs-progs: reorder single to be first in multiple bg list
      btrfs-progs: adjust multiple block group warning format
      btrfs-progs: fix detection of multiple profiles when generating the strings
      btrfs-progs: fi usage: list multiple profiles type
      btrfs-progs: docs: update section about multiple block group profiles
      btrfs-progs: tests: clean loop devices created by tests
      btrfs-progs: update CHANGES for 5.6.1
      Btrfs progs v5.6.1

Goffredo Baroncelli (5):
      btrfs-progs: add code for checking mixed profile function
      btrfs-progs: add mixed profiles check to some btrfs sub-commands.
      btrfs-progs: fi usage: add check for multiple profiles
      btrfs-progs: add further checks for multiple profiles
      btrfs-progs: docs: add section about multiple profiles

Marcos Paulo de Souza (1):
      btrfs-progs: tests: mkfs/018, fix check for truncate command failure

Qu Wenruo (6):
      btrfs-progs: remove extent_buffer::tree member
      btrfs-progs: do proper error handling in add_cache_extent()
      btrfs-progs: fix bad kernel header non-flat include case
      btrfs-progs: tests: filter output for run_check_stdout
      btrfs-progs: tests: introduce expand_command() to inject aruguments more accurately
      btrfs-progs: remove the duplicated @level parameter for btrfs_bin_search()

