Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60298 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbbLAXrr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Dec 2015 18:47:47 -0500
Subject: Re: Bug/regression: Read-only mount not read-only
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151130164801.GD2162@ret.masoncoding.com> <565D4248.8060502@cn.fujitsu.com>
 <20151201185420.GC8918@ret.masoncoding.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565E3197.8050209@gmx.com>
Date: Wed, 2 Dec 2015 07:47:35 +0800
MIME-Version: 1.0
In-Reply-To: <20151201185420.GC8918@ret.masoncoding.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/02/2015 02:54 AM, Chris Mason wrote:
> On Tue, Dec 01, 2015 at 02:46:32PM +0800, Qu Wenruo wrote:
>>
>>
>> Chris Mason wrote on 2015/11/30 11:48 -0500:
>>> On Sat, Nov 28, 2015 at 01:46:34PM +0000, Hugo Mills wrote:
>>>>     We've just had someone on IRC with a problem mounting their FS. The
>>>> main problem is that they've got a corrupt log tree. That isn't the
>>>> subject of this email, though.
>>>>
>>>>     The issue I'd like to raise is that even with -oro as a point
>>>> option, the FS is trying to replay the log tree. The dmesg output from
>>>> mount -oro is at the end of the email.
>>>>
>>>>     Now, my memory, experience and understanding is that the FS
>>>> doesn't, and shouldn't replay the log tree on a RO mount, because the
>>>> FS should still be consistent even without the reply, and
>>>> RO-means-actually-RO is possible and desirable. (Compared to a
>>>> journalling FS, where journal replay is required for a consistent,
>>>> usable FS).
>>>>
>>>>     So, this looks to me like a regression that's come in somewhere.
>>>>
>>>>     (Just for completeness, the system in question usually runs 4.2.5,
>>>> but the live CD the OP is using is 4.2.3).
>>>
>>> We do need to replay the log tree, even on readonly mounts.  Otherwise
>>> files created and fsunk before crashing may not even exist.
>>>
>>> We'll bail out of the log replay on readonly media, but otherwise the
>>> replay always happens.
>>>
>>> -chris
>>
>> Or disable log_tree (making fsync as slow as sync).
>> And there will be no log replay, making RO mount real RO.
>> I think we can add it to kernel btrfs documentation.
>
> True, without the log tree there's nothing to replay.
>
>>
>>
>> Or, in my wildest dream, introduce a per-inode tree to record file
>> extents/dir items.
>>
>> Then fsync will only need to sync the inode file extent/dir item tree.(and
>> its direct parent maybe)
>> And better random read/write performance.
>>
>> Although that's just my dream....
>>
>> But I'm a little curious about why btrfs choose to pack dir items and file
>> extents into the same subvolume tree at design time.
>> Unlike most of other file systems(ext4 for example).
>>
>> Is it just designed for simplicity?
>
> It's partially simplicity, but it also helps with locality.  When you're
> working with lots of files in a single directory, we're able to do many operations
> faster because we're not jumping around to other indexes for individual
> file extents.
>
> The cost is contention at the top of the btree, which I'm still hoping
> to fix without having to go all the way down to per-file trees.
>

Thanks for the information.

I'll just forget the crazy idea to do such per-file trees until we don't 
have better fix for the slow metadata operation.

Thanks,
Qu

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
