Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:36350 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbcANCWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 21:22:35 -0500
Received: by mail-io0-f173.google.com with SMTP id g73so244286995ioe.3
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jan 2016 18:22:34 -0800 (PST)
Received: from gmail.com (blk-11-122-84.eastlink.ca. [76.11.122.84])
        by smtp.gmail.com with ESMTPSA id kc8sm9111986igb.4.2016.01.13.18.22.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Jan 2016 18:22:32 -0800 (PST)
Date: Wed, 13 Jan 2016 22:22:30 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: input/output errors on btrfs-luks-lvm
Message-ID: <20160114022227.GA18911@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm running kernel 4.3.3-2-ARCH, and I sometimes get 'Input/output
error' when trying to access files.

I haven't found any logs as to why, and nothing appears in dmesg.

I'm running in a subvolume on an encrypted fs running on lvm.

I've tried a scrub, which has worked before , but no luck. I could try a
reboot, but I wanted to see if there's any other suggestions first.

$ stat ./script
  File: ‘./script’
  Size: 142401    	Blocks: 280        IO Block: 4096   regular file
Device: 2bh/43d	Inode: 1251585     Links: 1
Access: (0644/-rw-r--r--)  Uid: ( 1000/   kenny)   Gid: ( 1000/   kenny)
Access: 2016-01-13 20:16:43.308699108 -0400
Modify: 2016-01-06 21:12:02.756840023 -0400
Change: 2016-01-06 21:12:02.756840023 -0400

# btrfs inspect-internal inode-resolve -v 1251585 ./
ioctl ret=0, bytes_left=4047, bytes_missing=0, cnt=1, missed=0
