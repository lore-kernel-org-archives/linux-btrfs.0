Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620AbcASKhH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jan 2016 05:37:07 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, clm@fb.com
Subject: [PATCH 0/3] GFP flags adjustments, part 2
Date: Tue, 19 Jan 2016 11:37:00 +0100
Message-Id: <cover.1453199502.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few more tweaks to the GFP flags, for 4.5. This is low-risk and still preparatory so
we can narrow down the contexts where we can utilize the more fine-grained GFP flags and
attack the memory allocation failures.

----------------------------------------------------------------
The following changes since commit 39a27ec1004e886f1d949bdb8f2616896d02c5c2:

  btrfs: use GFP_KERNEL for xattr and acl allocations (2015-12-03 15:03:44 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/gfp-flags

for you to fetch changes up to 3677d94d23ae74d584ba61396aa51e82bb53e2d4:

  btrfs: scrub: use GFP_KERNEL on the submission path (2016-01-19 10:17:31 +0100)

----------------------------------------------------------------
David Sterba (3):
  btrfs: send: use GFP_KERNEL everywhere
  btrfs: reada: use GFP_KERNEL everywhere
  btrfs: scrub: use GFP_KERNEL on the submission path

 fs/btrfs/reada.c | 10 +++++-----
 fs/btrfs/scrub.c | 24 +++++++++++++-----------
 fs/btrfs/send.c  | 36 ++++++++++++++++++------------------
 3 files changed, 36 insertions(+), 34 deletions(-)

-- 
2.6.3

