Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fuz.su ([5.135.162.8]:39570 "EHLO fuz.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbbFCPbp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jun 2015 11:31:45 -0400
Date: Wed, 3 Jun 2015 17:27:04 +0200
From: fuz@fuz.su
To: linux-btrfs@vger.kernel.org
Subject: btrfs refuses to mount rw, access yields ESTALE on ro mount
Message-ID: <20150603152704.GA17845@fuz.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I'm experiencing a problem with a btrfs partition on my system. It
refuses to mount rw, dmesg contains this message and a stack trace [0]
when I try:

    BTRFS info (device sdb1): disk space caching is enabled

I can mount the fs as readonly but then I get a bunch of these errors on
file access:

[121618.400230] BTRFS info (device sdb1): no csum found for inode 3357352 start 0
[121618.400398] BTRFS info (device sdb1): no csum found for inode 3357352 start 4096
[121618.400501] BTRFS info (device sdb1): no csum found for inode 3357352 start 8192
[121618.400603] BTRFS info (device sdb1): no csum found for inode 3357352 start 12288

Here are the results of btrfs checks with two different versions of the
btrfs(8) utility: [1] [2]. I was then advised to run btrfs check --repair
on the file system by users on the #btrfs IRC channel. The log of this
execution and an execution of btrfs check --readonly immediately after
that can be found here: [3] [4]. What's interesting is that the error
count did not went down to 0 and neiher was the problem alleviated.

Before all of this, I performed btrfs-zero-log as suggested in various
articles on the internet.

Meta data from the file system pulled with btrfs-image(8) is available
on request only due to privacy concerns.

Yours sincerely,
Robert Clausecker

[0]: http://fuz.su/~fuz/txt/btrfs.trace
[1]: http://fuz.su/~fuz/txt/btrfs.check
[2]: http://fuz.su/~fuz/txt/btrfs.check2
[3]: http://fuz.su/~fuz/txt/btrfs.check3
[4]: http://fuz.su/~fuz/txt/btrfs.check4

-- 
()  ascii ribbon campaign - for an 8-bit clean world 
/\  - against html email  - against proprietary attachments
