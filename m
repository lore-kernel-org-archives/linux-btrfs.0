Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpcm9-101.freemail.mail.aliyun.com ([115.124.18.1]:41028 "EHLO
	smtpcm9-301.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772Ab3H2CeH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 22:34:07 -0400
Date: Thu, 29 Aug 2013 10:34:00 +0800
From: "lilofile" <lilofile@aliyun.com>
To: <linux-btrfs@vger.kernel.org>
Message-ID: <7c55ea3f-bb6d-4e77-8d2f-6368b437ed6a@aliyun.com>
Subject: =?UTF-8?B?YnVn?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 I made a btrfs on five disks using RAID5 (-d raid5 for mount option). When a power failure occurs, I can not remount btrfs after my system reboots. Dmesg for remount is presented as following:
 
[  192.713953] bio: create slab <bio-1> at 1
[  192.716230] Btrfs loaded
[  192.717177] device fsid a0dff7ea-9354-43fd-8516-0e17f370991d devid 1 transid 6 /dev/sdb
[  192.717712] btrfs: disk space caching is enabled
[  192.720572] btrfs: failed to read the system array on sdb
[  192.723398] btrfs: open_ctree failed
 
linux md raid5 have resync , the test seems btrfs raid5 have not resync,how fix the bug?




