Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from haggis.mythic-beasts.com ([93.93.131.56]:34331 "EHLO
	haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcFYAgO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 20:36:14 -0400
Date: Sat, 25 Jun 2016 00:47:29 +0100
From: Luis Henriques <henrix@camandro.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: tests: 001-simple-unmounted: fix test failure
 due to bashism
Message-ID: <20160624234729.GA29145@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The usage of 'source' is a bashism, and '.' should be used instead.  This
is causing fuzz-tests/001-simple-unmounted to fail in systems where
/bin/sh isn't bash:

    [TEST/fuzz]   001-simple-unmounted
./test.sh: 5: ./test.sh: source: not found
./test.sh: 7: ./test.sh: setup_root_helper: not found
./test.sh: 8: ./test.sh: check_prereq: not found
./test.sh: 18: ./test.sh: check_all_images: not found

Since most (all?) tests actually use /bin/bash, change this test to use
bash too.

Signed-off-by: Luis Henriques <henrix@camandro.org>
---
 tests/fuzz-tests/001-simple-unmounted/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fuzz-tests/001-simple-unmounted/test.sh b/tests/fuzz-tests/001-simple-unmounted/test.sh
index bf01a3a45a96..98fe7b0ccb74 100755
--- a/tests/fuzz-tests/001-simple-unmounted/test.sh
+++ b/tests/fuzz-tests/001-simple-unmounted/test.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 
 # iterate over all fuzzed images and run 'btrfs check'
 
