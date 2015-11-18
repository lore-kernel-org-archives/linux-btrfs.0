Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39957 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750810AbbKRFbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Nov 2015 00:31:09 -0500
Subject: Re: Transaction aborted (error -17) after crash
To: Mordechay Kaganer <mkaganer@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <CA+xOVSMpsSNfBxOghUe8H2QhzLDTC8EAABwkvrE12hUOFmfDig@mail.gmail.com>
 <564BEA55.4040209@gmx.com>
 <CA+xOVSMN+_H546rx3UCQht1yYd6F9KLr1vzAfK+JVHJXUF0rOw@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564C0D18.6040802@cn.fujitsu.com>
Date: Wed, 18 Nov 2015 13:31:04 +0800
MIME-Version: 1.0
In-Reply-To: <CA+xOVSMN+_H546rx3UCQht1yYd6F9KLr1vzAfK+JVHJXUF0rOw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Mordechay Kaganer wrote on 2015/11/18 07:18 +0200:
> B.H.
>
> On Wed, Nov 18, 2015 at 5:02 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>> 在 2015年11月17日 13:12, Mordechay Kaganer 写道:
>>>
>>> B.H.
>>>
>>>
>>> [  836.026606] BTRFS warning (device md1): block group 12969790406656
>>> has wrong amount of free space
>>> [  836.026610] BTRFS warning (device md1): failed to load free space
>>> cache for block group 12969790406656, rebuild it now
>>> [ 1033.619798] BTRFS warning (device md1): block group 15322358743040
>>> has wrong amount of free space
>>> [ 1033.619801] BTRFS warning (device md1): failed to load free space
>>> cache for block group 15322358743040, rebuild it now
>>
>>
>> Block group seems to be corrupted, maybe some other place in extent tree is
>> also corrupted.
>>
>> Personally speaking, this would not be a huge problem and can be fix by
>> btrfsck --init-extent-tree --repair to fix it.
>
> Thanks. That's what i get so far (it takes several hours to complete
> because the partition is huge):
>
> # btrfsck --init-extent-tree --repair /dev/md1
> enabling repair mode
> Checking filesystem on /dev/md1
> UUID: e16cc571-d897-473a-91d3-7673ea91d4cc
> Creating a new extent tree
> Failed to find [12968716681216, 168, 16384]
> btrfs unable to find ref byte nr 12968927035392 parent 0 root 1  owner
> 1 offset 0
> Failed to find [12968716730368, 168, 16384]
> btrfs unable to find ref byte nr 12969060089856 parent 0 root 1  owner
> 0 offset 1
> parent transid verify failed on 1103806464 wanted 19 found 13821
> Ignoring transid failure
> Failed to find [12968716779520, 168, 16384]
> btrfs unable to find ref byte nr 12968933851136 parent 0 root 1  owner
> 0 offset 1
>
> Does it mean something screwed up and unrecoverable?

Hard to say yet.

Is that the only error?

And did you tried btrfsck --init-extent-tree alone?
Although IIRC --init-extent-tree implies --repair, but it seems that 
extent tree is not correctly rebuilt at least.

>
>>
>> But you must ensure other tree is not corrupted, by using btrfsck without
>> any option to check the filesystem.
>
> I did run btrfs check --repair without other options.

Oh, I was meant to execute "btrfs check" without any other options, 
especially exclude "--repair"...


> Finished without
> problems as far as i understand the output.

That's a good news, at least it doesn't make the problem worse.

And, it would be quite helpful if you can post all the output(for both 
btrfsck --init-extent-tree, and btrfsck), to give us a better view of 
what's going wrong.

Thanks,
Qu

> Also tried mount with -o
> clear_cache. All this doesn't seem to help - tried rsync after that
> and the FS went read only with the same error message.
>
