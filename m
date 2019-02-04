Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673BAC282CB
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2997C2087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311734;
	bh=1P6ddRaa2acZTiaEa7qbqsmaMtqSGi0geOMD/rxebEI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=eplFhosDMJzL5l8YWCcJBACxKYjZPic7dPM4AIHxZVL6dEiV11DADy+aVYTX6xUrP
	 xygY16yoUH37l4jKVdYoTMM/knwI3TtnJ5DPvFC3KaDJSV7R/jSqlbJjSUKSs1ijGI
	 4Z59IJ8n5OebD4pnn+48QDV01j4s3WQIcr1ZTfuc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfBDUUc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:32 -0500
Received: from mail-yw1-f51.google.com ([209.85.161.51]:43143 "EHLO
        mail-yw1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbfBDUUb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:31 -0500
Received: by mail-yw1-f51.google.com with SMTP id u200so803629ywu.10;
        Mon, 04 Feb 2019 12:20:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+1LR4JeB/SCjmhhYycQ9QVATK3ttv2iHku/UUjRKjZM=;
        b=l57CbTGvmtaTqifNPaw1Lqmi+QwXM4oB3zwDrW+YqB9lVVd2dExlf85v/2QjyObn6K
         avxpzCvSl9x50WFOJLP7Ry+snSi3iE8j6aKkMW2trTsqj0HlDFAoqbWO85dBBUUGZNjM
         /TARNlrIqAItuBhxBtR/rKF2gUzV3QbdxKSROrKzMqHjjlntf4jwyp9VxIvURdhIdQ+K
         8uVK17NisvUz8C/43Qu0V4tRdTSpfINHxpL4R0FGWGLscbeWFk1d1PRP+XcS07RMqxGU
         X6e1gKFtIy7hKiaMn+JvL2jY81O2Tu6lIrI1+Aus77K/m3tUYMCnzoaouH3D1K3Si/F2
         yLMw==
X-Gm-Message-State: AHQUAuaxkN8C9xAwWvH++S0RLxlFHBjtiQyeW9Mu5M5w2yXcfwm6gsI9
        DDbqQdcC+r5aSJWuPUDf9l8=
X-Google-Smtp-Source: AHgI3Iag7tye71FBFOntjUCRRM+jCXfdL3OkVYKba1zSAo5WCD8ksqvEjC2ToGT+sPmnc7u63AVD3A==
X-Received: by 2002:a0d:e8c1:: with SMTP id r184mr1132981ywe.368.1549311629789;
        Mon, 04 Feb 2019 12:20:29 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:28 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH v2 00/12] btrfs: add zstd compression level support
Date:   Mon,  4 Feb 2019 15:19:56 -0500
Message-Id: <20190204202008.51652-1-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi everyone,

V2 had only a handful of changes outside of minor feedback.
0001:
- use functions over macros
0003:
- BTRFS_NR_WORKSPACE_MANAGERS is added instead of overriding
  BTRFS_COMPRESS_TYPES
0011 (new):
- address monotonic memory requirement for zstd workspaces
0012:
- increase reclaim timer to 307s from 67s
- move from keeping track of time in ns to jiffies
- remove timer in cleanup code
- use min_t() instead of if statements in .set_level()
- add header text to describe how workspaces are managed
- nofs_flag type -> unsigned long to unsigned int

From v1:
This is a respin of [1] which aims to add zstd compression level
support. V3 moves away from the using set_level() to resize workspaces
in favor of just allocating a workspace of the appropriate level and
using a timer to reclaim unused workspaces.

Zstd compression requires different amounts of memory for each level of
compression. The prior patches implemented indirection to allow for each
compression type to manage their workspaces independently. This patch
uses this indirection to implement compression level support for zstd.

As mentioned above, a requirement that differs zstd from zlib is that
higher levels of compression require more memory. To manage this, each
compression level has its own queue of workspaces. A global LRU is used
to help with reclaim. To guarantee forward progress, a max level
workspace is preallocated and hidden from the LRU.

When getting a workspace, it uses a bitmap to identify the levels that
are populated and scans up. If it finds a workspace that is greater than
it, it uses it, but does not update the last_used time and the
corresponding place in the LRU. This provides a mechanism to decrease
memory utilization as we only keep around workspaces that are sized
appropriately for the in use compression levels.

By knowing which compression levels have available workspaces, we can
recycle rather than always create new workspaces as well as take
advantage of the preallocated max level for forward progress. If we hit
memory pressure, we sleep on the max level workspace. We continue to
rescan in case we can use a smaller workspace, but eventually should be
able to obtain the max level workspace or allocate one again should
memory pressure subside. The memory requirement for decompression is the
same as level 1, and therefore can use any of available workspace.

The number of workspaces is bound by an upper limit of the workqueue's
limit which currently is 2 (percpu) limit). Second, a reclaim timer is
used to free inactive/improperly sized workspaces. The reclaim timer is
set to 67s to avoid colliding with transaction commit (every 30s) and
attempts to reclaim any unused workspace older than 45s.

Repeating the experiment from v2 [1], the Silesia corpus was copied to a
btrfs filesystem 10 times and then read back after dropping the caches.
The btrfs filesystem was on an SSD.

Level   Ratio   Compression (MB/s)  Decompression (MB/s)
1       2.658        438.47                910.51
2       2.744        364.86                886.55
3       2.801        336.33                828.41
4       2.858        286.71                886.55
5       2.916        212.77                556.84
6       2.363        119.82                990.85
7       3.000        154.06                849.30
8       3.011        159.54                875.03
9       3.025        100.51                940.15
10      3.033        118.97                616.26
11      3.036         94.19                802.11
12      3.037         73.45                931.49
13      3.041         55.17                835.26
14      3.087         44.70                716.78
15      3.126         37.30                878.84

[1] https://lore.kernel.org/linux-btrfs/20181031181108.289340-1-terrelln@fb.com/

This patchset contains the following 12 patches:
  0001-btrfs-add-helpers-for-compression-type-and-level.patch
  0002-btrfs-rename-workspaces_list-to-workspace_manager.patch
  0003-btrfs-manage-heuristic-workspace-as-index-0.patch
  0004-btrfs-unify-compression-ops-with-workspace_manager.patch
  0005-btrfs-add-helper-methods-for-workspace-manager-init-.patch
  0006-btrfs-add-compression-interface-in-get-put-_workspac.patch
  0007-btrfs-move-to-fn-pointers-for-get-put-workspaces.patch
  0008-btrfs-plumb-level-through-the-compression-interface.patch
  0009-btrfs-change-set_level-to-bound-the-level-passed-in.patch
  0010-btrfs-zstd-use-the-passed-through-level-instead-of-d.patch
  0011-btrfs-make-zstd-memory-requirements-monotonic.patch
  0012-btrfs-add-zstd-compression-level-support.patch

0001 adds helper functions for type_level conversion. 0002 renames
workspaces_list to workspace_manager.  0003 moves back to managing the
heuristic workspaces as the index 0 compression level. 0004-0007 unify
operations with the workspace_manager with 0007 moving to compression
types owning their workspace_manager. 0008-0010 plumbs level throughout
the compression level getting interface and converts set_level() to be a
bounding function rather than setting level on a workspace. 0011
makes zstd compression level memory monotonic. 00012 adds zstd
compression level support.

This patchset is on top of kdave#master d73aba1115cf.

diffstats below:

Dennis Zhou (12):
  btrfs: add helpers for compression type and level
  btrfs: rename workspaces_list to workspace_manager
  btrfs: manage heuristic workspace as index 0
  btrfs: unify compression ops with workspace_manager
  btrfs: add helper methods for workspace manager init and cleanup
  btrfs: add compression interface in (get/put)_workspace()
  btrfs: move to fn pointers for get/put workspaces
  btrfs: plumb level through the compression interface
  btrfs: change set_level() to bound the level passed in
  btrfs: zstd use the passed through level instead of default
  btrfs: make zstd memory requirements monotonic
  btrfs: add zstd compression level support

 fs/btrfs/compression.c | 249 +++++++++++++++------------------
 fs/btrfs/compression.h |  53 ++++++-
 fs/btrfs/lzo.c         |  31 +++-
 fs/btrfs/super.c       |  10 +-
 fs/btrfs/zlib.c        |  45 ++++--
 fs/btrfs/zstd.c        | 311 +++++++++++++++++++++++++++++++++++++++--
 6 files changed, 539 insertions(+), 160 deletions(-)

Thanks,
Dennis
