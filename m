Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39749 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933411AbdCHAmX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 19:42:23 -0500
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <dsterba@suse.com>,
        <clm@fb.com>
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170307151331.GT4662@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e2fe4265-edd0-685e-46b5-b4ae3cf567f9@cn.fujitsu.com>
Date: Wed, 8 Mar 2017 08:28:21 +0800
MIME-Version: 1.0
In-Reply-To: <20170307151331.GT4662@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/07/2017 11:13 PM, David Sterba wrote:
> On Mon, Feb 27, 2017 at 03:10:30PM +0800, Qu Wenruo wrote:
>> Pull request can be fetched from my github:
>> https://github.com/adam900710/linux.git qgroup_fixes_for_4.11
>>
>> The base is 6288d6eabc7505f42dda34a2c2962f91914be3a4.
>> Author: Liu Bo <bo.li.liu@oracle.com>
>> Date:   Tue Feb 21 12:12:58 2017 -0800
>>
>>     Btrfs: use the correct type when creating cow dio extent
>>
>> These patches are already in mail list for almost 3 months.
>> For example the tracepoint patch is last updated at 2016/12/09.
>>
>> With this patchset btrfs can pass all xfstest qgroup tests now.
>>
>> This pull request should be good for 4.11 as they are all bug fixes and
>> has been delayed for several times.
>>
>> I don't know if these patchset will be delayed again if someone wants to
>> cleanup something else, and cause rebase conflicts to delay such fixes.
>
> I have rebased the branch on top of the cleanups and added it as
> separate branch to for-next. For the next dev cycle I'll delay merging the
> intrusive cleanups until the end.
>
>> But I must say, that's very frustrating to see bug fixes just get dropped
>> again and again just due to new cleanups and lack of reviewers.
>
> That's life of a kernel developer.

Right, that's life.

That's also why I like btrfs-progs a little more.

Thanks,
Qu


