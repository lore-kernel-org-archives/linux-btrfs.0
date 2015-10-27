Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44724 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbbJ0H0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 03:26:09 -0400
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
To: Chris Mason <clm@fb.com>, <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
 <562EF9D7.50101@cn.fujitsu.com> <20151027051403.GA23134@ret.thefacebook.com>
 <562F1032.7040103@cn.fujitsu.com>
 <20151027061203.GA25844@ret.thefacebook.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <562F270C.1030701@cn.fujitsu.com>
Date: Tue, 27 Oct 2015 15:26:04 +0800
MIME-Version: 1.0
In-Reply-To: <20151027061203.GA25844@ret.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote on 2015/10/27 02:12 -0400:
> On Tue, Oct 27, 2015 at 01:48:34PM +0800, Qu Wenruo wrote:
>>>> Are you testing integration-4.4 from Chris repo?
>>>> Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
>>>>
>>>> Although integration-4.4 already merged qgroup reserve patchset, but it's
>>>> causing some strange bug like over decrease data sinfo->bytes_may_use,
>>>> mainly in generic/127 testcase.
>>>>
>>>> But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
>>>> old tests based on that), no generic/127 problem at all.
>>>
>>> Did I mismerge things?
>>>
>>> -chris
>>>
>> Not sure yet.
>>
>> But at least some patches in 4.3 is not in integration-4.4, like the
>> following patch:
>> btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode
>> size
>
> Have you tried testing integration-4.4 merged with current Linus git?
>
> -chris
>
Nice advice, compiling now.

But even rebasing my local old branch(based on 7d35199e15b82a4d1a200, 
with 21 patches) to 4.3-rc7, the result got screwed up...

If things get crazy, I'm afraid it would need to revert all my qgroup 
patchset from integration-4.4. :(

Thanks,
Qu
