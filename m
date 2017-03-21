Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19255 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751792AbdCUHHb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Mar 2017 03:07:31 -0400
Subject: Re: [PATCH v2 0/3] Btrfs in-band de-duplication test cases
To: Eryu Guan <eguan@redhat.com>
References: <20170316090851.21608-1-quwenruo@cn.fujitsu.com>
 <20170321045155.GR14226@eguan.usersys.redhat.com>
 <5a01bd29-d691-24e0-8c8f-3c5dc30370ca@cn.fujitsu.com>
 <20170321060533.GS14226@eguan.usersys.redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <9e55623f-f284-8de0-573a-083859903af3@cn.fujitsu.com>
Date: Tue, 21 Mar 2017 15:07:23 +0800
MIME-Version: 1.0
In-Reply-To: <20170321060533.GS14226@eguan.usersys.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/21/2017 02:05 PM, Eryu Guan wrote:
> On Tue, Mar 21, 2017 at 01:22:33PM +0800, Qu Wenruo wrote:
>>
>>
>> At 03/21/2017 12:51 PM, Eryu Guan wrote:
>>> Hi Qu,
>>>
>>> On Thu, Mar 16, 2017 at 05:08:48PM +0800, Qu Wenruo wrote:
>>>> Btrfs in-band de-duplication test cases for in-memory backend, which covers
>>>> the bugs exposed during the development.
>>>
>>> Do you have a kernel tree that contains the in-band patches so that I
>>> and others could try and run these tests?
>>
>> Of course.
>>
>> Kernel tree:
>> https://github.com/adam900710/linux.git wang_dedupe_latest
>>
>> Btrfs-progs tree:
>> https://github.com/adam900710/btrfs-progs.git dedupe_20170306
>
> Thanks! But I guess it's branch 'dedupe_20170316' of btrfs-progs repo,
> right? There's no dedupe_20170306 branch.

My fault, it's 20170316.

Thanks,
Qu
>
> Thanks,
> Eryu
>
>


