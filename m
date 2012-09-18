Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48011 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2IRB1P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 21:27:15 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A66CC3EE0BC
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:27:13 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 898AD45DE53
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:27:13 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 720CD45DE4D
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:27:13 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 604111DB8041
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:27:13 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 198E51DB803A
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 10:27:13 +0900 (JST)
Message-ID: <5057CDA7.3090201@jp.fujitsu.com>
Date: Tue, 18 Sep 2012 10:25:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] Btrfs: set mount options permanently
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following patches are going to implement one of unclaimed features
listed in the btrfs wiki:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Set_mount_options_permanently

Special thanks to Kazuhiro Yamashita for his time and efforts.
Your comments/reviews are welcomed.

Thanks,
H.Seto

