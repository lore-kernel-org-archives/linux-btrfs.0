Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42440 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3GaHli (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 03:41:38 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 62E663401FA
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 09:41:35 +0200 (CEST)
Received: from localhost (ppp-58-8-50-9.revip2.asianet.co.th [58.8.50.9])
	by mail.virtall.com (Postfix) with ESMTPSA id 67D103401DC
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 09:41:34 +0200 (CEST)
Date: Wed, 31 Jul 2013 14:41:28 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: ERROR: quota command failed: Invalid argument
Message-ID: <20130731144128.08c50a7d@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting "ERROR: quota command failed: Invalid argument" when trying
to run "btrfs quota rescan" - is it expected?

root@bkp010 ~ # btrfs quota rescan /mnt/lxc1
ERROR: quota command failed: Invalid argument

root@bkp010 ~ # btrfs quota rescan /mnt/lxc1
ERROR: quota command failed: Invalid argument


There is nothing in dmesg when I run these commands.

I had these errors logged a few hours earlier:

Jul 31 08:12:59 bkp010 kernel: [260172.744870] BTRFS error (device sdb5): block group 3835502264320 has wrong amount of free space
Jul 31 08:12:59 bkp010 kernel: [260172.744979] BTRFS error (device sdb5): failed to load free space cache for block group 3835502264320

This is running 3.10.


-- 
Tomasz Chmielewski
http://wpkg.org
