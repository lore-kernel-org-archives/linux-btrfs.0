Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44916 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbcFFDW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 23:22:59 -0400
To: fsdevel <linux-fsdevel@vger.kernel.org>
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Is it possible to block any writer inside a fs?
Message-ID: <c627c72b-c065-40fd-1cd3-4c12c0f81499@cn.fujitsu.com>
Date: Mon, 6 Jun 2016 11:22:48 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is it possible to block any new writer from a fs?
Just like what we do in remounting fs to readonly, although it's done in 
VFS.

The case is, for example, we have an ioctl to control how buffered write 
works.(inband dedupe)

And when changing/disabling such behavior, we need to ensure that all 
current writer has finished and no new incoming writer until we finished 
the work, just like remount to RO.

In VFS, it's done by sb_prepare_mount_readonly(), while it's an 
internally used function, and shouldn't be directly called by a fs.

So, is there any method for fs to block incomming write inside a fs?

Thanks,
Qu


