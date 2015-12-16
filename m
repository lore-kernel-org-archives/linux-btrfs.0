Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35769 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbbLPMNI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 07:13:08 -0500
Received: by mail-ig0-f176.google.com with SMTP id to4so61414493igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 04:13:07 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz> <5670C017.5010104@cn.fujitsu.com>
 <pan$ecec5$9f9ca76c$f1c4eebd$1e31c111@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56715518.8080808@gmail.com>
Date: Wed, 16 Dec 2015 07:12:08 -0500
MIME-Version: 1.0
In-Reply-To: <pan$ecec5$9f9ca76c$f1c4eebd$1e31c111@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-16 06:10, Duncan wrote:
> Qu Wenruo posted on Wed, 16 Dec 2015 09:36:23 +0800 as excerpted:
>
>> David Sterba wrote on 2015/12/14 18:32 +0100:
>>> On Thu, Dec 10, 2015 at 10:34:06AM +0800, Qu Wenruo wrote:
>>>> Introduce a new mount option "nologreplay" to co-operate with "ro"
>>>> mount option to get real readonly mount, like "norecovery" in ext* and
>>>> xfs.
>>>>
>>>> Since the new parse_options() need to check new flags at remount time,
>>>> so add a new parameter for parse_options().
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>>>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>>>
>>> I've read the discussions around the change and from the user's POV I'd
>>> suggest to add another mount option that would be just an alias for any
>>> mount options that would implement the 'hard-ro' semantics.
>>>
>>> Say it's called 'nowr'. Now it would imply 'nologreplay', but may cover
>>> more options in the future.
>>>
>>>    mount -o ro,nowr /dev/sdx /mnt
>>>
>>> would work when switching kernels.
>>>
>>>
>> That would be nice.
>>
>> I'd like to forward the idea/discussion to filesystem ml, not only btrfs
>> maillist.
>>
>> Such behavior should better be coordinated between all(at least xfs and
>> ext4 and btrfs) filesystems.
>>
>> One sad example is, we can't use 'norecovery' mount option to disable
>> log replay in btrfs, as there is 'recovery' mount option already.
>>
>> So I hope we can have a unified mount option between mainline
>> filesystems.
>
> FWIW, I was just reading the mount manpage in connection with a reply for
> a different thread, and noticed...
>
> mount (8) (from util-linux 2.27.1) says noload and norecovery are the
> same option, for ext3/4 at least.  It refers to the xfs (5) manpage, from
> xfsprogs, for xfs mount options, and that's not installed here, so I
> can't confirm noload for it, but it's there for ext3/4.
Unless it's undocumented, XFS doesn't have it (as much as I hate XFS, I 
have to have xfsprogs installed so that I can do recovery for the few 
systems at work that actually use it if the need arises).
>
> And noload doesn't have the namespace collision problem norecovery does
> on btrfs, so I'd strongly suggest using it, at least as an alias for
> whatever other btrfs-specific name we might choose.
I kind of agree with Christoph here.  I don't think that noload should 
be the what we actually use, although I do think having it as an alias 
for whatever name we end up using would be a good thing.

