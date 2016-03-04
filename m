Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36225 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755473AbcCDAwi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Mar 2016 19:52:38 -0500
Subject: Re: btrfs-progs: btrfs convert v2
To: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAO5K3OcqZTTRr=p==Awd0VVQ507M-CP6dQqgwtrXUYqpUBUu+g@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D8DC31.2070707@cn.fujitsu.com>
Date: Fri, 4 Mar 2016 08:52:01 +0800
MIME-Version: 1.0
In-Reply-To: <CAO5K3OcqZTTRr=p==Awd0VVQ507M-CP6dQqgwtrXUYqpUBUu+g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Vytautas D wrote on 2016/03/03 15:33 +0000:
> Hi Qu, thanks for your work on btrfs convert.
>
> Does your btrfs convert work ( namely
> https://www.spinics.net/lists/linux-btrfs/msg49719.html patches )
> change any caveats described here ->
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3#Before_first_use
>
NO caveats is changed.

The only visible change is, after convert, metadata are all in SINGLE 
profile other than DUP.

The rework is aimed to fix the chunk type mismatch problem.
(A lot of codes just for a workaround-able problem...)

> i.e. does larger than 1 gb files still needs defrag after which
> rollback is not possible ?

Not sure why 1GB files needs defrag.

I assume it's related to ext* block group size, the default size would 
be 128M for each block group, and since each block group will have 
metadata as its beginning, splitting large files into 120+M parts.

Thans,
Qu

>
> Thanks,
> Vytas
>
>


