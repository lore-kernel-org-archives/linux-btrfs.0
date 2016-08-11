Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36530 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbcHKBK3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 21:10:29 -0400
Received: by mail-oi0-f66.google.com with SMTP id b22so736951oii.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 18:10:29 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Aug 2016 19:10:28 -0600
Message-ID: <CAJCQCtQhFdtZF2K4H4g7M7hNO+e0w7RcKX80fk1CSiJi5w6JQQ@mail.gmail.com>
Subject: enospc after btrfs-convert(ed) ext4 volume
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=151921

btrfs-progs 4.6.1
kernel-4.8.0-0.rc1.git0.1.fc25.x86_64

Details in the bug, which also includes btrfs-debug-tree and
btrfs-image. I haven't tried to reproduce, so it could be a one off,
and there's no enospc_debug mount option used.

-- 
Chris Murphy
