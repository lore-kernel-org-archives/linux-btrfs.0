Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33809 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHZJo3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 05:44:29 -0400
Received: by widdq5 with SMTP id dq5so40794693wid.1
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 02:44:28 -0700 (PDT)
Subject: Re: [BUG] kernel BUG at fs/btrfs/scrub.c:1956!, when scrubbing
 freshly converted ext4
To: Zhao Lei <zhaolei@cn.fujitsu.com>,
        "'Chris Murphy'" <lists@colorremedies.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSGRU6x2g3Asy42q76YtO8p=8DTaOwEchaWjzB23BX8xA@mail.gmail.com>
 <04eb01d0c4f9$80e42300$82ac6900$@cn.fujitsu.com>
Cc: "'Qu Wenruo'" <quwenruo@cn.fujitsu.com>
From: Yurii Kolesnykov <yurikoles@gmail.com>
Message-ID: <55DD8A7A.9030804@gmail.com>
Date: Wed, 26 Aug 2015 12:44:26 +0300
MIME-Version: 1.0
In-Reply-To: <04eb01d0c4f9$80e42300$82ac6900$@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Zhao Lei

> 
> I reproduced above bug too, with following command:
>   mkfs.ext4 /dev/vdh
>   btrfs-convert /dev/vdh
>   mount /dev/vdh /mnt/tmp1
>   btrfs scrub start -B /dev/vdh
>   (panic)
> 
> The reason is:
> 1: In some case, metadata(leaf) created by btrfs-convert was split into 2 strips.
> 2: Then scrub bypassed part of leaf data, and left data caused panic in
>   scrub_checksum_tree_block().
> 
> For above 1:
> we can get following information after some simple operation.
> a. mkfs.ext4 /dev/vdh
>   btrfs-convert /dev/vdh
> b. btrfs-debug-tree /dev/vdh
>   we can see following item in extent tree:
>   item 25 key (27054080 METADATA_ITEM 0) itemoff 15083 itemsize 33
>   Its logical address is [27054080, 27070464)
>   and acrossed 2 strips:
>   [27000832, 27066368)
>   [27066368, 27131904)
> Qu Wenruo <quwenruo@cn.fujitsu.com> is fixing above problem.
> 
> For above 2:
> scrub is trying to do a "bypass" in this case, but the result is "panic".
> I'll fix it.
> 
> Thanks
> Zhaolei

Could you please share an update on this bug status?
Also, please use bugzilla.
