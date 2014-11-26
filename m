Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58721 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaKZDAk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 22:00:40 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so1875835pad.24
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 19:00:40 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 0/3] Extent tree rebuilding with snapshots patches
Date: Wed, 26 Nov 2014 10:58:53 +0800
Message-Id: <1416970736-26623-5-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
References: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I did send these patches a long while ago, but due to some reasons,
they were not merged, these are important fixes for fsck, without
these patches, extent tree rebuilding did not work with snapshots.

Also, /tests/fsck-tests.sh's extent tree rebuild test could always
detect failure without these patches, unluckily, it need extra
enviroment setting, so i supposed it was always 'NOTRUN'!

last patch fix a regression for root rebuilding, root rebuilding
should be at first, because if root(extent root eg) corrupted,
root items also won't succeed.

patches are based on David's integration-20141125

Wang Shilong (3):
  Btrfs-progs: fsck: deal with snapshot one by one when rebuilding
    extent tree
  Btrfs-progs: fsck: add ability to rebuild extent tree with snapshots
  Btrfs-progs, fsck: move root items repair after root rebuilding

 cmds-check.c | 412 +++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 303 insertions(+), 109 deletions(-)

-- 
2.1.0

