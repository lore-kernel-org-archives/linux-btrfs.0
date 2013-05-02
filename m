Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385Ab3EBP5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 May 2013 11:57:53 -0400
Message-ID: <1367510414.32396.90.camel@sauron.fi.intel.com>
Subject: imperfect FIEMAP results on btrfs
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: linux-btrfs@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>
Date: Thu, 02 May 2013 19:00:14 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a rather extensive FIEMAP test which works fine on ext4 but fails
on btrfs. I've took a look at one of the failures, and simplified it to
the following:

1. create a 4KiB non-sparse file
2. truncate it to 8KiB
3. truncate it to 4KiB + 1 byte

IOW:

$ dd if=/dev/urandom of=file bs=4096 count=1
$ truncate -s 8192 file
$ truncate -s 4097 file

Let's assume that the FS block size is 4KiB, as it is returned the
FIGETBSZ ioctl. These actions result in:

1. the file will have only 1 block mapped on ext4
2. the file will have 2 blocks mapped on btrfs

IOW, on ext4:

$ stat file
  File: ‘file’
  Size: 4097            Blocks: 8          IO Block: 4096   regular file

and on btrfs

$ stat file
  File: ‘file’
  Size: 4097            Blocks: 16         IO Block: 4096   regular file

Notice 8 vs 16 blocks.

Interesting enough that just creating a 4KiB file and then truncating it
to 4097 bytes works as I expect in btrfs - results in a file with only
the first block mapped.

It looks like ext4 is "perfect" in detecting sparse 4KiB blocks while
btrfs sometimes maps seemingly sparse 4KiB blocks. Is this considered to
be a defect or this is fine since the FS does not probably give any
guarantees WRT mapped and unmapped blocks?

Thanks!

-- 
Best Regards,
Artem Bityutskiy

