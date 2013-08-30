Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24749 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab3H3BrC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 21:47:02 -0400
Message-ID: <521FF91B.10309@cn.fujitsu.com>
Date: Fri, 30 Aug 2013 09:44:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: separate out tests into their own directory V2
References: <1377804569-1957-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1377804569-1957-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/30/2013 03:29 AM, Josef Bacik wrote:
> The plan is to have a bunch of unit tests that run when btrfs is loaded when you
> build with the appropriate config option.  My ultimate goal is to have a test
> for every non-static function we have, but at first I'm going to focus on the
> things that cause us the most problems.  To start out with this just adds a
> tests/ directory and moves the existing free space cache tests into that
> directory and sets up all of the infrastructure.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Nothing serious, use checkpatch.pl and i get the following warnings:

  WARNING: kfree(NULL) is safe this check is probably not required
#132: FILE: fs/btrfs/free-space-cache.c:3035:
+    if (map)
+        kfree(map);

WARNING: line over 80 characters
#882: FILE: fs/btrfs/tests/free-space-tests.c:211:
+    ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 1 * 1024 * 
1024, 1);

WARNING: line over 80 characters
#927: FILE: fs/btrfs/tests/free-space-tests.c:256:
+    ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 4 * 1024 * 
1024, 1);

WARNING: line over 80 characters
#947: FILE: fs/btrfs/tests/free-space-tests.c:276:
+    ret = test_add_free_space_entry(cache, 4 * 1024 * 1024, 4 * 1024 * 
1024, 1);

WARNING: line over 80 characters
#953: FILE: fs/btrfs/tests/free-space-tests.c:282:
+    ret = test_add_free_space_entry(cache, 2 * 1024 * 1024, 2 * 1024 * 
1024, 0);

WARNING: line over 80 characters
#1016: FILE: fs/btrfs/tests/free-space-tests.c:345:
+    ret = test_add_free_space_entry(cache, 1 * 1024 * 1024, 2 * 1024 * 
1024, 1);

WARNING: line over 80 characters
#1022: FILE: fs/btrfs/tests/free-space-tests.c:351:
+    ret = test_add_free_space_entry(cache, 3 * 1024 * 1024, 1 * 1024 * 
1024, 0);

WARNING: line over 80 characters
#1030: FILE: fs/btrfs/tests/free-space-tests.c:359:
+        test_msg("Error removing bitmap and extent overlapping %d\n", ret);

  Thanks,
Wang
