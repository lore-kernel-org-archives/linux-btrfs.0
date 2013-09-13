Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:65034 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3IMNdT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 09:33:19 -0400
Date: Fri, 13 Sep 2013 06:33:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Mark Fasheh <mfasheh@suse.de>, Zach Brown <zab@redhat.com>
Subject: Build failures due to commit 416161db (btrfs: offline dedupe)
Message-ID: <20130913133314.GA20461@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function '__put_user_unaligned' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [fs/btrfs/ioctl.o] Error 1
make[2]: *** Waiting for unfinished jobs....

Seen with alpha:allmodconfig, arm:allmodconfig, m68k:allmodconfig, and
xtensa:allmodconfig.

Guenter
