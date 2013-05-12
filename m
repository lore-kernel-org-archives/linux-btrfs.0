Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:38380 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493Ab3ELVIJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 May 2013 17:08:09 -0400
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: bug: grubby error updating grub.cfg when /boot is on btrfs
Message-Id: <87D12388-0F4E-468F-84E9-847BE94E79F4@colorremedies.com>
Date: Sun, 12 May 2013 15:08:07 -0600
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

RHBZ Bug 864198

This bug isn't getting much attention possibly because it involves some unique aspects of Btrfs confusing grubby. So I thought I'd post it to this list to see if anyone has ideas how to move forward.


Chris Murphy