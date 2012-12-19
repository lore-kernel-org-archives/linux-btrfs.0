Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:46398 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2LSPWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 10:22:14 -0500
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com [209.85.215.48])
	by m199-177.yeah.net (HMail) with ESMTPA id 0D09510023A
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2012 23:12:44 +0800 (CST)
Received: by mail-la0-f48.google.com with SMTP id m13so1546684lah.35
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2012 07:12:42 -0800 (PST)
MIME-Version: 1.0
From: Rock Lee <zimilo@code-trick.com>
Date: Wed, 19 Dec 2012 23:12:01 +0800
Message-ID: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
Subject: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

    Did someone have met this problem before. When doing the tests, I hit

the WARN_ON. Is this log make sense or someone had fixed the problem.

 If needed, I can supply the detail log and the testcase source file.

 Version: the latest codes at linus git tree.


[ 2140.981293] use_block_rsv: 336 callbacks suppressed
[ 2140.981295] ------------[ cut here ]------------
[ 2140.981308] WARNING: at fs/btrfs/extent-tree.c:6339
btrfs_alloc_free_block+0x126/0x330 [btrfs]()
[ 2140.981309] Hardware name: 2356BG6
...

[ 2140.981568] ------------[ cut here ]------------
[ 2140.981574] WARNING: at fs/btrfs/extent-tree.c:6339
btrfs_alloc_free_block+0x126/0x330 [btrfs]()
[ 2140.981574] Hardware name: 2356BG6
[ 2140.981575] btrfs: block rsv returned -28
                                     ^^^^^^^^^^^^^^^^^^^^^^^^
                                     Always this value.

