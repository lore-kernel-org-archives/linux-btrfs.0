Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726507AbeH2Mbp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 08:31:45 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99427AE8E
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 08:35:56 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Userspace support for FSID change 
Date: Wed, 29 Aug 2018 11:35:50 +0300
Message-Id: <1535531754-29774-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the userspace tooling support for utilising the new metadata_uuid field, 
enabling the change of fsid without having to rewrite every metadata block. This
patchset consists of adding support for the new field to various tools and 
files (Patch 1). The actual implementation of the new -m|-M options (which are 
described in more detail in Patch 2). A new misc-tests testcasei (Patch 3) which
exercises the new options and verifies certain invariants hold (these are also
described in Patch2). Patch 4 is more or less copy of the kernel conuterpart 
just reducing some duplication between btrfs_fs_info and btrfs_fs_devices 
structures. 

The intended usecase of this feature is to give the sysadmin the ability to 
create copies of filesystesm, change their uuid quickly and mount them alongside
the original filesystem for, say, forensic purposes. 

One thing which still hasn't been set in stone is whether the new options 
will remain as -m|-M or whether they should subsume the current -u|-U - from 
the point of view of users nothing should change. So this is something which 
I'd like to hear from the community. Of course the alternative of rewriting 
the metadata blocks will be assigne new options - perhaps -m|M ?

I've tested this with multiple xfstest runs with the new tools installed as 
well as running btrfs-progs test and have observed no regressions. 

Nikolay Borisov (4):
  btrfs-progs: Add support for metadata_uuid field.
  btrfstune: Add support for changing the user uuid
  btrfs-progs: tests: Add tests for changing fsid feature
  btrfs-progs: Remove fsid/metdata_uuid fields from fs_info

 btrfstune.c                                | 174 ++++++++++++++++++++++++-----
 check/main.c                               |   2 +-
 chunk-recover.c                            |  17 ++-
 cmds-filesystem.c                          |   2 +
 cmds-inspect-dump-super.c                  |  22 +++-
 convert/common.c                           |   2 +
 ctree.c                                    |  15 +--
 ctree.h                                    |   8 +-
 disk-io.c                                  |  62 ++++++++--
 image/main.c                               |  25 +++--
 tests/misc-tests/033-metadata-uuid/test.sh | 137 +++++++++++++++++++++++
 volumes.c                                  |  37 ++++--
 volumes.h                                  |   1 +
 13 files changed, 431 insertions(+), 73 deletions(-)
 create mode 100755 tests/misc-tests/033-metadata-uuid/test.sh

-- 
2.7.4
