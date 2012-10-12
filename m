Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46080 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2JLDTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 23:19:49 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id A927D3EE0AE
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:47 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 91CE645DE4D
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 7B4D045DD78
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6F2221DB8038
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:47 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 29E911DB802C
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:47 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id ED1319F79A0
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:46 +0900 (JST)
Received: from [127.0.0.1] (unknown [10.124.101.110])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 833349F7986
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 12:19:46 +0900 (JST)
Message-ID: <50778C1D.4060807@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 12:18:53 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] Btrfs: set mount options permanently
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following patches are going to implement one of unclaimed features
listed in the btrfs wiki:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#Set_mount_options_permanently

Previous v1 post and discussion can be referred from:
http://lwn.net/Articles/516898/

v2:
- Allow operator [+-=] like chmod for setting options
- Save options by words instead of internal bits.
  (e.g. kernel code will translate a word "ssd_spread" to 2 internal
   bits "SSD" and "SSD_SPREAD". However this behavior might be changed
   if kernel updates.)

Special thanks to Kazuhiro Yamashita for his time and efforts.
Again, your comments/reviews are welcomed.

Thanks,
H.Seto

