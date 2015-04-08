Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbbDHMDa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 08:03:30 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NMH00HDJLHT5Q60@mailout3.samsung.com> for
 linux-btrfs@vger.kernel.org; Wed, 08 Apr 2015 21:03:29 +0900 (KST)
Date: Wed, 08 Apr 2015 12:03:29 +0000 (GMT)
From: =?euc-kr?B?wM7BpL3E?= <js7.in@samsung.com>
Subject: Re: Re: Porting BTRFS to user space
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-to: js7.in@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1463140364.591861428494608421.JavaMail.weblogic@epmlwas09b>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the advise.
I am still wonder why there are same-name files in btrfs(kernel source) and btrfs-progs.
They are quite many as follows.
    backref.{c, h}
    ctree.{c, h}
    dir-item.c
    disk-io.{c, h}
    extent_io.{c, h}
    extent-tree.c
    file.c
    file-item.c
    free-space-cashe.{c, h}
    hash.h
    inode.c
    inode-item.c
    inode-map.c
    print-tree.{c, h}
    props.{c, h}
    qgroup.{c, h}
    root-tree.c
    send.h
    ulist.{c, h}
    uuid-tree.c
    volumes.{c, h}

It seems btrfs-progs files have been ported from kernel files.
Are they the result of efforts to port btrfs from kernel to user space?
Or at least can I utilize the them so that I have to only port the remaining files?

------- Original Message -------
Sender : Austin S Hemmelgarn<ahferroin7@gmail.com> 
Date   : 2015-04-08 20:37 (GMT+09:00)
Title  : Re: Porting BTRFS to user space

On 2015-04-07 19:57, ÀÎÁ¤½Ä wrote:
> Thank you for the information.
> I just found that btrfs-progs includes several files that seem modified from btrfs kernel source.
> I am not sure exactly what they are.
> Web pages say libbtrfs is to provide interface for apps that use btrfs.
> Why should there be duplicated codes between kernel and user space?
> Is it an on-going effort to port whole btrfs to user space?
> 
> Could you lead me to some more information about libbtrfs or how to port btrfs to user space?
> 
> Thank you,
> Jeongsik
> 
> 
As far as I understand it, the intent is to allow things like btrfs
check and btrfs restore to still work even if the kernel doesn't have
btrfs support.  From what I can tell, you are the first person to
actually be serious about getting BTRFS running in userspace, so there
probably isn't much BTRFS specific literature out there.

I would, however suggest looking at the FUSE drivers for ext4 and ZFS,
as those are both ported from kernel space, and should give some good
examples of where to start.

<p>&nbsp;</p><p>&nbsp;</p>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
