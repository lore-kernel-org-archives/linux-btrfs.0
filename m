Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17544 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756789AbbLBJXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 04:23:23 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Russell Coker <russell@coker.com.au>, Eric Sandeen <sandeen@redhat.com>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au> <565EB480.4010509@cn.fujitsu.com>
CC: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565EB878.9090501@cn.fujitsu.com>
Date: Wed, 2 Dec 2015 17:23:04 +0800
MIME-Version: 1.0
In-Reply-To: <565EB480.4010509@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/12/02 17:06 +0800:
>
>
> Russell Coker wrote on 2015/12/02 17:25 +1100:
>> On Wed, 2 Dec 2015 06:05:09 AM Eric Sandeen wrote:
>>> yes, xfs does; we have "-o norecovery" if you don't want that, or need
>>> to mount a filesystem with a dirty log on a readonly device.
>>
>> That option also works with Ext3/4 so it seems to be a standard way of
>> dealing
>> with this.  I think that BTRFS should do what Ext3/4 and XFS do in this
>> regard.
>>
> BTW, does -o norecovery implies -o ro?
>
> If not, how does it keep the filesystem consistent?
>
> I'd like to follow that ext2/xfs behavior, but I'm not familiar with
> those filesystems.
>
> Thanks,
> Qu
>

OK, norecovery implies ro.

So I think it's possible to do the same thing for btrfs.
I'll try to do it soon.

Thanks,
Qu

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


