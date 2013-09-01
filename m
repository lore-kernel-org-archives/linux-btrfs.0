Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63782 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3IAGPQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 02:15:16 -0400
Received: by mail-pa0-f44.google.com with SMTP id fz6so3940018pac.31
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Aug 2013 23:15:15 -0700 (PDT)
Date: Sun, 01 Sep 2013 14:15:09 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Subject: Re:  Btrfs: separate out tests into their own directory V2
Cc: <linux-btrfs@vger.kernel.org>
Message-ID: <5222db6d.y1rlQi1VIlwCf9La%wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Using checkpatch.pl, i get the following warnings(errors):
WARNING: kfree(NULL) is safe this check is probably not required
#132: FILE: fs/btrfs/free-space-cache.c:3035:
+	if (map)
+		kfree(map);

WARNING: line over 80 characters
#882: FILE: fs/btrfs/tests/free-space-tests.c:211:
+	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 1024, 1);

WARNING: line over 80 characters
#927: FILE: fs/btrfs/tests/free-space-tests.c:256:
+	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 1024, 1);

WARNING: line over 80 characters
#947: FILE: fs/btrfs/tests/free-space-tests.c:276:
+	ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 1024, 1);

WARNING: line over 80 characters
#953: FILE: fs/btrfs/tests/free-space-tests.c:282:
+	ret = test_add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 1024, 0);

WARNING: line over 80 characters
#1016: FILE: fs/btrfs/tests/free-space-tests.c:345:
+	ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 1024, 1);

WARNING: line over 80 characters
#1022: FILE: fs/btrfs/tests/free-space-tests.c:351:
+	ret = test_add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 1024, 0);

WARNING: line over 80 characters
#1030: FILE: fs/btrfs/tests/free-space-tests.c:359:
+		test_msg("Error removing bitmap and extent overlapping %d\n", ret);

total: 0 errors, 8 warnings, 997 lines checked

patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Thanks, Wang
