From: Danny Kukawka <danny.kukawka@bisect.de>
Subject: [PATCH 0/4] btrfs-progs: some patches
Date: Thu, 12 Jan 2012 16:17:43 +0100
Message-ID: <1326381467-19848-1-git-send-email-danny.kukawka@bisect.de>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Patches to fix some possible segfaults, fix some compiler warnings and
indention.

They are against: 
       git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

@David: I've separated your changes to my patch for the SUSE package
        into an own patch and attached it.
 
Danny Kukawka (3):
  fix segfaults from bnc#710486
  fix some compiler warnings from cgcc
  fix indentation

David Sterba (1):
  return error code from change/get_label_unmounted

 btrfs-image.c        |    5 ++++
 btrfs-select-super.c |    4 ++-
 btrfs.c              |   12 +++++-----
 btrfslabel.c         |   62 ++++++++++++++++++++++++++++---------------------
 btrfslabel.h         |    3 +-
 btrfstune.c          |    5 ++++
 dir-test.c           |   11 +++++++++
 extent-cache.c       |    2 +-
 extent-tree.c        |    2 +-
 extent_io.c          |    2 +-
 find-root.c          |    5 +++-
 mkfs.c               |    6 +++++
 quick-test.c         |   20 ++++++++++++++++
 random-test.c        |    8 ++++++
 14 files changed, 108 insertions(+), 39 deletions(-)

-- 
1.7.8

