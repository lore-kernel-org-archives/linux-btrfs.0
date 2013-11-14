Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:32926 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab3KNNth (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 08:49:37 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <yzb3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-btrfs@vger.kernel.org>; 14 Nov 2013 14:49:36 +0100
Date: Thu, 14 Nov 2013 14:49:36 +0100
From: yzb3@wp.pl
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: RE: BTRFS error after clearing cache
Message-ID: <5284d4f01340e9.50736959@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Hello,

>I wanted to make sure that my boot slowdown was related to space_cache so I rebooted the PC several times and
>it did become slower again. What is more, it doesn't seem like I even need to generate any actual IO traffic
>to trigger this.

>I thought I might give clear_cache a shot again and to test the boot speed with nospace_cache as well. After
>first booting with clear_cache,nospace_cache and nospace_cache afterwards I was unhappy about the
>boot speed, so I decided to clear the nospace_cache argument so that the cache would be rebuilt. However,
>even though my boot speed did improve (not well enough, though), I received 2 errors (this is also the
>output of dmesg | grep BTRFS):

>[    5.528707] BTRFS error (device sda2): block group 1103101952 has wrong amount of free space
>[    5.529630] BTRFS error (device sda2): failed to load free space cache for block group 1103101952

>It comes up after every reboot now. The output of dmesg | grep trfs (no 'b', because it is inconsistent) is:

>[    1.225343] Btrfs loaded
>[    1.245586] btrfs: disk space caching is enabled
>[    1.245588] btrfs: has skinny extents

>Any ideas on how I can remove this error? This doesn't break my boot or anything, but it probably slows things
>down, leaves some fs garbage etc. By the way, it would be a good idea to be able to search for a consistent
>value in dmesg.

This is still present under kernel 12.0; during a boot with clear_cache the messages are gone, but right after removing
this option (so that the cache is rebuilt) they appear again.


