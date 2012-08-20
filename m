Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47563 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2HTQWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 12:22:34 -0400
Received: by yhmm54 with SMTP id m54so5160110yhm.19
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2012 09:22:33 -0700 (PDT)
From: Curtis Jones <curtis.jones@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs and mdadm raid 6
Message-Id: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com>
Date: Mon, 20 Aug 2012 12:22:31 -0400
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi. I'm considering an imminent switch from ext4 to btrfs and I'm hoping that someone can lend me advice before I do something unsupported.

I have a software raid 6 array configured via mdadm. It was sitting at 8 x 3TB until I recently doubled that, grew the array and found that ext4 doesn't want to resize. So, I'm looking to:

	1. convert from ext4 to btrfs
	2. grow the fs to the full array size

My concerns are:

	1. is btrfs-convert on /dev/md0 stable/reliable/tested/not-a-stupid-thing-to-do?
	2. based on the reading I've done, resizing btrfs is supported. can you confirm?
	3. there aren't any known compatibility or other issues with running btrfs on top of mdadm (raid 6)
	4. any other caveats I might want to consider?

I just upgraded from kernel v3.5.1 to v3.5.2 and I have the btrfs-tools (v0.19) compiled straight from git.

Any words of wisdom would be appreciated.

Thanks!

--
Curtis Jones

