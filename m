Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:32946 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766AbaKRKkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 05:40:02 -0500
Message-ID: <546B21F4.8060203@pobox.com>
Date: Tue, 18 Nov 2014 02:39:48 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem show _exact_ freaking size?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Howdy,

How does one get the exact size (in blocks preferably, but bytes okay) 
of the filesystem inside a partition? I know how to get the partition 
size, but that's not useful when shrinking a partition...

So, for example, you successfully do

btrfs filesystem resize -32G /dev/sdz2

now you've got "some space" zero idea how many sectors can be trimmed 
off the end of the partition, you can do the math but thats a little 
iffy, especially if the file system didn't originally fill the partition 
to begin with.

The current methodology for most such actions is to way over-trim the 
file system, then reallocate the space using your partition tool of 
choice, then re-grow the filesystem to fit. This has been the way of 
things forever and it blows...

There needs to be an option to btrfs filesystem show that will tell you 
XXXXXblocks, not Y.ZZ terabytes.

