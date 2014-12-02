Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42437 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077AbaLBAhr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 19:37:47 -0500
Message-ID: <547D09D8.1060103@cn.fujitsu.com>
Date: Tue, 2 Dec 2014 08:37:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com> <547C64B4.2050802@gmail.com>
In-Reply-To: <547C64B4.2050802@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs 
<linux-btrfs@vger.kernel.org>
Date: 2014年12月01日 20:53
> On 2014-11-30 20:58, Qu Wenruo wrote:
>> [snipped]
>>
> So, I think this does a good job of highlighting one of the bigger 
> issues with btrfsck when it is compared to ext* and/or xfs. Despite 
> this being a problem, I really don't think using a rdbms is the way to 
> fix it, both for reasons outlined in other responses, and because fsck 
> should be as fast as possible when nothing is wrong with the fs.
>
>
Although I am not stick to the crazy idea, I think it is still needed to 
point out that,
even btrfsck is ran on a clean btrfs, it still needs to iterate all the 
extents, metadata.
So it may not be as fast as you thought even with the current implement.

Anyway thanks for the feedback.

Thanks,
Qu
