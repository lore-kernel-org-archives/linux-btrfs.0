Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29384 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161860AbcEaAie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 20:38:34 -0400
Subject: Re: [PATCH] btrfs: fix check_shared for fiemap ioctl
To: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <1463369030-15434-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <d228d748-2947-a934-8bc1-afd53127e796@cn.fujitsu.com>
 <20160530151528.GB29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <b91c1b77-39ee-1a75-a530-4618f7765bd6@cn.fujitsu.com>
Date: Tue, 31 May 2016 08:38:25 +0800
MIME-Version: 1.0
In-Reply-To: <20160530151528.GB29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/05/30 17:15 +0200:
> On Fri, May 27, 2016 at 09:39:53AM +0800, Qu Wenruo wrote:
>> Any comment?
>>
>> This patch does not fix the submitted generic/352[1] and generic/353[2]
>> test cases, but also introduce a much better structure and design for
>> later backref walk use.
>>
>> Instead of a list and do a O(n^3)~O(n^4) iteration for fiemap ioctl on a
>> reflinked(deduped) file, it's now only O(n)~O(nlogn) for SHARED flag
>> check to pass generic/352.
>
> This is a good improvement, though there's potentially hidden cost in
> the allocations and maintaining the temporary structures. Do you have
> actual performance numbers?
>
>
Test case generic/352 is already the proof.

For a 1G file whose all file extents are pointing to the same 128K file 
extent, fiemap will just soft lockup for backref walk.

Even for case(*) it doesn't hang, it takes about 3~4 seconds to do 
check_shared() for one extent.


With this patch, chech_shared() returned immediately, if found any other 
delayed ref/extent ref, making the whole fiemap ioctl super fast for 
deduped file case.

*: Two 1G file, inside the same subvolume, pointing to the same 128K 
file extent will not cause soft lockup.


We can use such patch to rework current backref walk code, which does 
unneeded list iteration instead of faster rb tree search, but it's too 
aggressive, and we want to do it step by step, starting from these bugs 
exposed by inband dedupe.

Thanks,
Qu


