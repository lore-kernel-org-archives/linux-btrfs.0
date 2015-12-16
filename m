Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25552 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753486AbbLPBgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 20:36:40 -0500
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5670C017.5010104@cn.fujitsu.com>
Date: Wed, 16 Dec 2015 09:36:23 +0800
MIME-Version: 1.0
In-Reply-To: <20151214173200.GO4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/12/14 18:32 +0100:
> On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>
>> Since the new parse_options() need to check new flags at remount time,
>> so add a new parameter for parse_options().
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
> I've read the discussions around the change and from the user's POV I'd
> suggest to add another mount option that would be just an alias for any
> mount options that would implement the 'hard-ro' semantics.
>
> Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
> more options in the future.
>
>   mount -o ro,nowr /dev/sdx /mnt
>
> would work when switching kernels.
>
>
That would be nice.

I'd like to forward the idea/discussion to filesystem ml, not only btrfs 
maillist.

Such behavior should better be coordinated between all(at least xfs and 
ext4 and btrfs) filesystems.

One sad example is, we can't use 'norecovery' mount option to disable 
log replay in btrfs, as there is 'recovery' mount option already.

So I hope we can have a unified mount option between mainline filesystems.

Thanks,
Qu


