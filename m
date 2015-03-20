Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:63862 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbbCTBJy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:09:54 -0400
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id B13DF1E944E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:09:52 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wWvk38jqKMD3 for <linux-btrfs@vger.kernel.org>;
	Fri, 20 Mar 2015 02:09:46 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 1EB321E93E2
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:09:45 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YYlRZ-0006yl-Ko
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 02:09:45 +0100
Date: Fri, 20 Mar 2015 02:09:45 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Changes since v1:
 * Split patch into smaller patches
 * btrfs-convert and mkfs now shares check_node_or_leaf_size
 * Rebased onto latest v3.19.x

Sebastian Thorarensen (4):
  btrfs-progs: mkfs: Move out some nodesize code
  btrfs-progs: Fix msgs in check_node_or_leaf_size
  btrfs-progs: btrfs-convert: Allow setting nodesize
  btrfs-progs: Add nodesize test for btrfs-convert

 Documentation/btrfs-convert.txt |    4 +++
 btrfs-convert.c                 |   60 ++++++++++++++++++++++++++++++++++-----
 mkfs.c                          |   26 ++---------------
 tests/convert-tests.sh          |   15 ++++++----
 utils.c                         |   21 ++++++++++++++
 utils.h                         |    2 ++
 6 files changed, 92 insertions(+), 36 deletions(-)

-- 
1.7.10.4
