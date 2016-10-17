Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:35661 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934292AbcJQXuC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 19:50:02 -0400
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <komukadze@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-btrfs@vger.kernel.org>; 18 Oct 2016 01:43:20 +0200
Date: Tue, 18 Oct 2016 01:43:20 +0200
From: "Komu Kadze" <komukadze@wp.pl>
To: linux-btrfs@vger.kernel.org
Subject: Recovering from disk failure (RAID5)
Message-ID: <5805621878adb6.84965706@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a BTRFS setup with 8 HDD stripped with RAID5. I know it&#x2019;s mark as experimental, as it has problem with power failures. I decided to give it a shot. Last night one of the disks in the array failed, the OS decided to remount the FS into read-only mode. The data was still accessible. I started backing things up, but few hours later I started getting I/O errors.

Currently I&#x2019;m stuck at this: http://pastebin.com/n9cGVqJB

With  dmesg giving me this: http://pastebin.com/F5626BAc while trying to mount the FS (even with &#x2013;o degraded)

Kernel version: 4.4.0-42-generic
Btrfs progs version: v4.7.2
Btrfs fi show: http://pastebin.com/X7Hpw2tb
btrfs fi df: currently the file system is not mountable

--
Komu



