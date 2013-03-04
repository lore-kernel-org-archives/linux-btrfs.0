Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:15309 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932516Ab3CDVkb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 16:40:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/14] btrfs-progs: more Coverity cleanups
Date: Mon,  4 Mar 2013 16:39:50 -0600
Message-Id: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This gets the coverity issue count down to 33.  Before Zach started this
process, we were over 150, IIRC.  So it's almost to the point where the
scans will be manageable going forward.

Not a lot of real bugfixes here, but a bit better error handling in
places.  I sent out 2 dumb patches  (elsewhere) on Friday, though,
so feel free to take a close & skeptical look at these ;)

Thanks,
-Eric

