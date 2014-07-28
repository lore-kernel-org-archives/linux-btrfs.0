Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbaG1A3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jul 2014 20:29:03 -0400
Message-ID: <53D5994F.4010605@cn.fujitsu.com>
Date: Mon, 28 Jul 2014 08:29:03 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, Chris Mason <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC] btrfs: Use backup superblocks if and only if the
 first superblock is valid but corrupted.
References: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com> <53D17A88.5090905@fb.com> <53D46A8B.2030002@gmail.com>
In-Reply-To: <53D46A8B.2030002@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH RFC] btrfs: Use backup superblocks if and only if 
the first superblock is valid but corrupted.
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
<linux-btrfs@vger.kernel.org>
Date: 2014年07月27日 10:57
> On 07/24/2014 05:28 PM, Chris Mason wrote:
>>
>> On 06/26/2014 11:53 PM, Qu Wenruo wrote:
>>> Current btrfs will only use the first superblock, making the backup
>>> superblocks only useful for 'btrfs rescue super' command.
>>>
>>> The old problem is that if we use backup superblocks when the first
>>> superblock is not valid, we will be able to mount a none btrfs
>>> filesystem, which used to contains btrfs but other fs is made on it.
>>>
>>> The old problem can be solved related easily by checking the first
>>> superblock in a special way:
>>> 1) If the magic number in the first superblock does not match:
>>>     This filesystem is not btrfs anymore, just exit.
>>>     If end-user consider it's really btrfs, then old 'btrfs rescue super'
>>>     method is still available.
>>>
>>> 2) If the magic number in the first superblock matches but checksum does
>>>     not match:
>>>     This filesystem is btrfs but first superblock is corrupted, use
>>>     backup roots. Just continue searching remaining superblocks.
>> I do agree that in these cases we can trust that the backup superblock
>> comes from the same filesystem.
>>
>> But, for right now I'd prefer the admin get involved in using the backup
>> supers.  I think silently using the backups is going to lead to surprises.
> Maybe there could be a mount non-default mount-option to use backup
> superblocks iff the first one is corrupted, and then log a warning
> whenever this actually happens?  Not handling stuff like this
> automatically really hurts HA use cases.
>
>
This seems better and comments also shows this idea.
What about merging the behavior into 'recovery' mount option or adding a 
new mount option?

Thanks,
Qu
