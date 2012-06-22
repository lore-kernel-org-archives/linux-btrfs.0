Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41079 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2FVSYO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 14:24:14 -0400
Received: by wgbdr13 with SMTP id dr13so2066919wgb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 11:24:13 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@fusionio.com>, idryomov@gmail.com
Subject: [PATCH 0/2] Restriper restore bugfix
Date: Fri, 22 Jun 2012 21:24:11 +0300
Message-Id: <1340389453-21439-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes restriper restore bug which triggered asserts for users with
interrupted balances on rootfs btrfs.

Thanks,

		Ilya


Ilya Dryomov (2):
  Btrfs: restore restriper state on all mounts
  Btrfs: resume balance on rw (re)mounts properly

 fs/btrfs/disk-io.c |   39 ++++++++++++++++++----------
 fs/btrfs/super.c   |    4 +++
 fs/btrfs/volumes.c |   73 ++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/volumes.h |    3 +-
 4 files changed, 76 insertions(+), 43 deletions(-)

-- 
1.7.9.1

