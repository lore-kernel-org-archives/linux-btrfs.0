Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:59839 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbaAQP5b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 10:57:31 -0500
Received: from mawa.ruf.uni-freiburg.de ([132.230.1.30]) port 57966
	by mailgateway3.uni-freiburg.de with esmtp
	(Exim 4.80.1 #2 built 22-Apr-2013 16:36:34 running on Gentoo)
	id 1W4AFu-0002uE-QN
	for linux-btrfs@vger.kernel.org; Fri, 17 Jan 2014 15:18:42 +0100
Date: Fri, 17 Jan 2014 15:18:41 +0100
From: Martin Walter <mawa@uni-freiburg.de>
To: linux-btrfs@vger.kernel.org
Subject: usrquota
Message-ID: <20140117141841.GA2838@rz.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Our problem is a zfs with 20,000 quota-enabled homedirectories and 100 snapshots.
We would really like to do the same with btrfs, but we don't know how to replace the
zfs quotas with btrfs subvolume quotas. It seems unfeasible to handle 2,000,000 subvolumes.
e.g. we would have to create every hour 20,000 snapshots and delete the same amount.

Is there any chance to get real user quotas with btrfs?

Martin
