Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40063 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752120AbbFWHOZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jun 2015 03:14:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5N7CjBs014872
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2015 15:12:45 +0800
Message-ID: <5589078B.2090806@cn.fujitsu.com>
Date: Tue, 23 Jun 2015 15:15:23 +0800
From: Cao jin <caoj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Question about "btrfs send/receive"
Content-Type: text/plain; charset="gbk"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
     I am considering implement the btrfs send/receive command in 
libguestfs(http://libguestfs.org/), and found that incremental send 
seems pretty complicated. So my questions is:
1. What is the most usually usage of btrfs send/receive?
2. Does it make sense to implement the simplest form?
      $ btrfs send -f sent_file subvol

Could anyone give a introduction and suggestions?
Thanks in advance

-- 
Yours Sincerely,

Cao Jin
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
