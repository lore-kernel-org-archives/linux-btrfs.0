Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:56498 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab3C2Fl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 01:41:26 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: minimum kernel version for btrfsprogs.0.20?
Message-Id: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
Date: Thu, 28 Mar 2013 23:41:02 -0600
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Creating a btrfs file system using btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19, and either kernel 3.6.10-4.fc18 or 3.9.0-0.rc3.git0.3.fc19, makes a file system that cannot be mounted by kernel 3.6.10-4.fc18. It can be mounted by kernel 3.8.4. I haven't tested any other 3.8, or any 3.7 kernels.

Is this expected?

dmesg reports:
[  300.014764] btrfs: disk space caching is enabled
[  300.024137] BTRFS: couldn't mount because of unsupported optional features (40).
[  300.034148] btrfs: open_ctree failed


Chris Murphy