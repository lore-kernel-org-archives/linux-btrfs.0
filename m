Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:42905 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511Ab2LWVLN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Dec 2012 16:11:13 -0500
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: incomplete erase of btrfs with wipefs
Message-Id: <8C039D41-002B-440C-9888-9CAB1BC17190@colorremedies.com>
Date: Sun, 23 Dec 2012 14:11:11 -0700
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm not completely sure if this is a wipefs bug, or a btrfs(-progs) bug. The gist is that after using wipefs on a btrfs formatted partition, then reformatted as ext4, mount sees it as ext4, parted sees it as ext4, but I btrfs fi show sees it as a member device of a btrfs volume. I have filed a bug against util-linux, but perhaps this is a btrfs-progs over confidence in what it thinks is a valid volume. I have included in the bug report the first 5MB of the device.

https://bugzilla.redhat.com/show_bug.cgi?id=889888


Chris Murphy

