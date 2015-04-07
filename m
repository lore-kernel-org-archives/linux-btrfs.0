Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17153 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbDGX5O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 19:57:14 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NMG00ANONVCPW80@mailout3.samsung.com> for
 linux-btrfs@vger.kernel.org; Wed, 08 Apr 2015 08:57:12 +0900 (KST)
Date: Tue, 07 Apr 2015 23:57:11 +0000 (GMT)
From: =?euc-kr?B?wM7BpL3E?= <js7.in@samsung.com>
Subject: Re: Re: Porting BTRFS to user space
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-to: js7.in@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <455311443.534051428451031043.JavaMail.weblogic@epmlwas09b>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the information.
I just found that btrfs-progs includes several files that seem modified from btrfs kernel source.
I am not sure exactly what they are.
Web pages say libbtrfs is to provide interface for apps that use btrfs.
Why should there be duplicated codes between kernel and user space?
Is it an on-going effort to port whole btrfs to user space?

Could you lead me to some more information about libbtrfs or how to port btrfs to user space?

Thank you,
Jeongsik


------- Original Message -------
Sender : Austin S Hemmelgarn<ahferroin7@gmail.com> 
Date   : 2015-04-08 02:50 (GMT+09:00)
Title  : Re: Porting BTRFS to user space

On 2015-04-06 21:28, ÀÎÁ¤½Ä wrote:
> Hello BTRFS developers,
> 
> I am requesting your opion.
> 
> I am planning to design and implement DFS version of BTRFS.
> Roughly it will be done by
>     1. Extending current DeviceID to NodeID:DeviceID to support multi-node, and
>     2. Implementing inter-node data and meta-data access over TCP.
> Do you think it would be feasible?
> 
> For development, I would like to port the kernel code to user space.
> It could continue to run in user mode or be ported back to kernel space.
> But I don't know how can I start to porting the kernel code to user space.
> Is there anyone who can help?
> 
> Thanks,
> JeongsikN?²æ?r?yúè?b?¬¶Ç§v?^?)Şº{.n?+??{?Úß?)?æèw*jg¬±?????/??z¹Ş??2??è­?&?)ß¡?¶Ú????h??j:+v???Ù¥
> 
Personally, my suggestion would be to start with a port to FUSE, and
then start implementing your modifications off of that.  That said, much
of the code should already be available in userspace through libbtrfs,
which is packaged with btrfs-progs.

<p>&nbsp;</p><p>&nbsp;</p>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
