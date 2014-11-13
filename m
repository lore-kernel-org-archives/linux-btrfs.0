Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48767 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751013AbaKMIYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 03:24:17 -0500
Message-ID: <54646AA9.1030707@cn.fujitsu.com>
Date: Thu, 13 Nov 2014 16:24:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <mikhail.v.gavrilov@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check --repair couldn't solve problem with btrfs partition
References: <CABXGCsMQMmPGa4sFGfeTUpiGeJUZ=6yN=J3Ueh4x-e3cwktc3A@mail.gmail.com> <54646A11.1020408@cn.fujitsu.com>
In-Reply-To: <54646A11.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Hi!
>
> Several times I try repair my btrfs partition with follow commands:
> [root@localhost ~]# umount /home
>
> root@localhost ~]# btrfs check --repair /dev/sdb1
> enabling repair mode
> Fixed 0 roots.
> Checking filesystem on /dev/sdb1
> UUID: 82df2d84-bf54-46cb-84ba-c88e93677948
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> root 5 inode 14121739 errors 2000, link count wrong
> unresolved ref dir 12843363 index 36917 namelen 11 name Preferences
> filetype 0 errors 3, no dir item, no dir index
> root 5 inode 14121759 errors 2000, link count wrong
> unresolved ref dir 139955 index 340700 namelen 18 name
> session_state.xspf filetype 0 errors 3, no dir item, no dir index
> found 2897923331138 bytes used err is 1
The problem seems not hard to repair in btrfs-progs.

But I'm also curious about why this happens.
Is there any ungraceful shutdown or things like that?

Also, would you mind sending us the btrfs-image dump?
btrfs-debug-tree output would also help, although it may be bigger than
output of btrfs-image.

Thanks,
Qu
> total csum bytes: 3100962412
> total tree bytes: 4638130176
> total fs tree bytes: 950992896
> total extent tree bytes: 142475264
> btree space waste bytes: 608962027
> file data blocks allocated: 33183423946752
>   referenced 3177308782592
>
> Btrfs v3.17
>
>
> # rpm -q btrfs-progs
> btrfs-progs-3.17-1.fc21.x86_64
>
>
> And every time I see this messages.
>
>
>
> --
> Best Regards,
> Mike Gavrilov.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
