Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37205 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab2JLN40 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 09:56:26 -0400
From: nirbheek.chauhan@collabora.co.uk
To: linux-btrfs@vger.kernel.org
Cc: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>
Subject: [PATCH] Btrfs-progs: loopback files cannot be used if the path is too long
Date: Fri, 12 Oct 2012 19:25:33 +0530
Message-Id: <1350050134-12151-1-git-send-email-nirbheek.chauhan@collabora.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nirbheek Chauhan <nirbheek.chauhan@collabora.co.uk>

If the path to a given loopback file is longer than 64 characters, none of the
Btrfs-progs tools can use it. This is because the size of loopinfo.lo_name
returned by the LOOP_GET_STATUS ioctl is 64.

The attached patch fixes this by fetching the backing file for a loopback device
from /sys/block; which is how `losetup` from util-linux does it as well.

Nirbheek Chauhan (1):
  Btrfs-progs: fix resolving of loop devices

 utils.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

-- 
1.7.8.6

