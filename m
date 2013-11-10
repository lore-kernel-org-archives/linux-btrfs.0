Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:27872 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3KJQPS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 11:15:18 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <yzb3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-btrfs@vger.kernel.org>; 10 Nov 2013 17:15:15 +0100
Date: Sun, 10 Nov 2013 17:15:14 +0100
From: yzb3@wp.pl
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: BTRFS error after clearing cache
Message-ID: <527fb112ee75b5.68693988@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I wanted to make sure that my boot slowdown was related to space_cache so I rebooted the PC several times and it did become slower again. What is more, it doesn't seem like I even need to generate any actual IO traffic to trigger this.

I thought I might give clear_cache a shot again and to test the boot speed with nospace_cache as well. After first booting with clear_cache,nospace_cache and nospace_cache afterwards I was unhappy about the boot speed, so I decided to clear the nospace_cache argument so that the cache would be rebuilt. However, even though my boot speed did improve (not well enough, though), I received 2 errors (this is also the output of dmesg | grep BTRFS):

[    5.528707] BTRFS error (device sda2): block group 1103101952 has wrong amount of free space
[    5.529630] BTRFS error (device sda2): failed to load free space cache for block group 1103101952

It comes up after every reboot now. The output of dmesg | grep trfs (no 'b', because it is inconsistent) is:

[    1.225343] Btrfs loaded
[    1.245586] btrfs: disk space caching is enabled
[    1.245588] btrfs: has skinny extents

Any ideas on how I can remove this error? This doesn't break my boot or anything, but it probably slows things down, leaves some fs garbage etc. By the way, it would be a good idea to be able to search for a consistent value in dmesg.


