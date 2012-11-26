Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57472 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab2KZB0d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 20:26:33 -0500
MIME-Version: 1.0
Date: Mon, 26 Nov 2012 09:26:31 +0800
Message-ID: <CAPxxNQ=SRZ33U8nLjK8a3+MPfy3Qz98ALcALXWK_x=dmW9+BoA@mail.gmail.com>
Subject: How to run xfstests against btrfs on multipath disks on SuSE?
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I tried to kick off xfstests against btrfs on multipath device,
e.g I set TEST_DEV="/dev/mapper/mpatha", which is a
symlink to "/dev/dm-0". I mkfs.btrfs mpatha beforehand.

When I run "./check 001", it said:
"
common.rc: Error: $TEST_DEV (/dev/dm-0) is not a MOUNTED btrfs filesystem
"

The I checked the script common.rc, and found that it uses
df to determine the filesystem type and it uses the realpath
"/dev/dm-0" instead of "/dev/mapper/mpatha", while df always
shows "devtmpfs" instead of "btrfs" for /dev/dm-0.

I run "mount" and found that devtmpfs is mount on /dev/ ***by default***
in SuSE.
Even though  I run "mount -t btrfs /dev/dm-0 /somedir", df still showed
devtmpfs.

Any ideas to kick off the xfstests?

thanks,
