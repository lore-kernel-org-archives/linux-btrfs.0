Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:64252 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbDGB2S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 21:28:18 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NME00B4XXF5XY20@mailout2.samsung.com> for
 linux-btrfs@vger.kernel.org; Tue, 07 Apr 2015 10:28:17 +0900 (KST)
Date: Tue, 07 Apr 2015 01:28:16 +0000 (GMT)
From: =?euc-kr?B?wM7BpL3E?= <js7.in@samsung.com>
Subject: Porting BTRFS to user space
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-to: js7.in@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <759287502.475491428370096552.JavaMail.weblogic@epmlwas09d>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello BTRFS developers,

I am requesting your opion.

I am planning to design and implement DFS version of BTRFS.
Roughly it will be done by
    1. Extending current DeviceID to NodeID:DeviceID to support multi-node, and
    2. Implementing inter-node data and meta-data access over TCP.
Do you think it would be feasible?

For development, I would like to port the kernel code to user space.
I could continue to run in user mode or be ported back to kernel space.
But I don't know how can I start to porting the kernel code to user space.
Is there anyone who can help?

Thanks,
Jeongsikÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
