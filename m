Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33262 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030494AbcGKNpR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 09:45:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id B264335ECF6
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 15:45:13 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q7fe8Qr9aPOi for <linux-btrfs@vger.kernel.org>;
	Mon, 11 Jul 2016 15:45:13 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 15:45:13 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 11 Jul 2016 22:45:13 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs won't mount to /home
Message-ID: <b44f915ca2d728f0fde9848f09524ecb@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is kind of strange (kernel 4.6.3, Ubuntu 16.04):

# mount -t btrfs /dev/sda4 /home

# echo $?
0

# dmesg -c
[382148.588847] BTRFS info (device sda4): disk space caching is enabled
[382148.588851] BTRFS: has skinny extents

So it worked?

# ls /home

<empty, should be showing data>

# df | grep home

# mount | grep /home

# lsof -n | grep /home


All give no output.


So, weird, isn't it?

Now, let's try to mount to /home2:

# mkdir /home2

# mount /dev/sda4 /home2

# mount | grep home
/dev/sda4 on /home2 type btrfs 
(rw,relatime,space_cache,subvolid=5,subvol=/)

# dmesg -c
[382190.199363] BTRFS info (device sda4): disk space caching is enabled
[382190.199370] BTRFS: has skinny extents



What's wrong there?


Tomasz Chmielewski
https://wpkg.org
