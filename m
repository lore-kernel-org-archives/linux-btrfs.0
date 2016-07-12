Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36643 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbcGLAfj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 20:35:39 -0400
Received: by mail-pa0-f43.google.com with SMTP id hu1so279217pad.3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 17:35:39 -0700 (PDT)
Date: Mon, 11 Jul 2016 17:35:37 -0700
From: Omar Sandoval <osandov@osandov.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: FIDEDUPERANGE with src_length == 0
Message-ID: <20160712003537.GA27653@vader.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, Darrick,

generic/182 is failing on Btrfs for me with the following output:

--- tests/generic/182.out       2016-07-07 19:51:54.000000000 -0700
+++ /tmp/fixxfstests/xfstests/results//generic/182.out.bad      2016-07-11 17:28:28.230039216 -0700
@@ -1,12 +1,10 @@
 QA output created by 182
 Create the original files
-dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2
 69ad53078a16243d98e21d9f8704a071  TEST_DIR/test-182/file2.chk
 Compare against check files
 Make the original file almost dedup-able
-dedupe: Extents did not match.
 f4820540fc0ac02750739896fe028d56  TEST_DIR/test-182/file1
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2
 158d4e3578b94b89cbb44493a2110fb9  TEST_DIR/test-182/file2.chk

It looks like that test is checking that a dedupe with length == 0 is
treated as a dedupe to EOF, but Btrfs doesn't do that [1]. As far as I
can tell, it never did, but maybe I'm just confused. What was the
behavior when you introduced that test? That seems like a reasonable
thing to do, but I wanted to clear this up before changing/fixing Btrfs.

Thanks.

1: http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ioctl.c?h=v4.7-rc7#n3122
-- 
Omar
