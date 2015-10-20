Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63183 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893AbbJTCdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 22:33:42 -0400
Subject: Re: [devel branch]Btrfs-convert assert at volumes.c:1846
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <dsterba@suse.cz>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <5624B828.80405@cn.fujitsu.com> <20151019112108.GU27761@suse.cz>
 <5624E445.3040203@gmx.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5625A801.8060704@cn.fujitsu.com>
Date: Tue, 20 Oct 2015 10:33:37 +0800
MIME-Version: 1.0
In-Reply-To: <5624E445.3040203@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Qu Wenruo wrote on 2015/10/19 20:38 +0800:
> 在 2015年10月19日 19:21, David Sterba 写道:
>> On Mon, Oct 19, 2015 at 05:30:16PM +0800, Qu Wenruo wrote:
>>> Recently I'm reworking the btrfs-convert chunk allocater to make it able
>>> to separate data and meta chunk.
>>>
>>> But when I was testing, I found that, your devel branch, with the
>>> following commit just fails to convert an empty ext4 filesystem:
>>>
>>> commit 0002085c53a5ac9ad1c538bfc3e39c80891c4a1a
>>> Author: Zhao Lei <zhaolei@cn.fujitsu.com>
>>> Date:   Mon Oct 12 21:23:04 2015 +0800
>>>
>>>       btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments
>>> command
>>
>> That's the top commit, but it's not causing the breakage. I've bisected
>> the breakage to the patch
>>
>> commit 893b7a6815a735449613afbb4040f486a4a4e1d0
>> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date:   Wed May 13 17:15:34 2015 +0800
>>
>>      btrfs-progs: Read the whole superblock instead of struct
>> btrfs_super_block.
>>
>> Looks familiar? :)
>>
>> The patch caused some trouble in the past (on ppc64 machines) and I've
>> been holding it back due to that. The plan is to add it to 4.3 devel
>> branch and get it fixed before the final release, so the convert could
>> fail in the meantime. I'm trying to put together all pending branches
>> for the next release so I can't say when the convert will be fixed.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Thanks for the bisect, David.
>
> Very interesting, I'll try to fix it in recent days at least to make
> sure that btrfs-convert can be executed without assert.
>
> Hopes the convert rework for separated chunk profile will arrive in time.
>
> Thanks,
> Qu

Finally, the bug is found.

A SUPER AWKWARD TYPO....

See the patch just submitted:
[PATCH] btrfs-progs: Fix a typo which causes super_copy corrupted

And, I think that's also the reason why PPC64 report errors.
But unfortunately, there is no PPC64 machine here for me to test.

Hopes someone can help testing it on PPC64.

Thanks,
Qu
