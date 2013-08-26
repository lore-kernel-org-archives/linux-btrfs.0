Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:46016 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab3HZSZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 14:25:22 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 94428386CBB
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 20:25:17 +0200 (CEST)
Received: from localhost (srv1.virtall.com [78.46.87.16])
	by mail.virtall.com (Postfix) with ESMTPSA id 88669386C30
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 20:25:16 +0200 (CEST)
Date: Tue, 27 Aug 2013 02:25:09 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: failed to read log tree, open_ctree failed
Message-ID: <20130827022509.57de1ab2@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a RAID-1 btrfs filesystem with Linux 3.10.

After hard reset, I'm no longer able to mount it:

[   35.254122] Btrfs loaded
[   35.254577] device label test-btrfs devid 1 transid 97966 /dev/sda4
[   35.254819] device label test-btrfs devid 3 transid 97966 /dev/sdb4
[   35.255032] device label test-btrfs devid 3 transid 97966 /dev/sdb4
[   35.255552] btrfs: force zlib compression
[   35.255645] btrfs: disk space caching is enabled
[   35.379806] btrfs: bdev /dev/sda4 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
[   56.209412] parent transid verify failed on 3321036099584 wanted 97967 found 97966
[   56.225990] parent transid verify failed on 3321036099584 wanted 97967 found 97966
[   56.226128] btrfs: failed to read log tree
[   56.344483] btrfs: open_ctree failed


I've tried with 3.11-rc7, but it gives the same result.

Any hints how to recover from that?
I have backups, but it would be nice if the filesystem just mounted.


-- 
Tomasz Chmielewski
http://wpkg.org
