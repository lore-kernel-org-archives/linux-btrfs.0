Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26869 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750938AbcKHAf5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Nov 2016 19:35:57 -0500
Subject: Re: btrfs support for filesystems >8TB on 32bit architectures
To: Marc MERLIN <marc@merlins.org>
References: <20161107012009.xng7hyhoqwqres3u@merlins.org>
 <8e2407ee-c137-44c3-b9c8-4dec931d6c3a@cn.fujitsu.com>
 <0b840fbb-1a3d-d395-47ad-015e84eac05a@cn.fujitsu.com>
 <20161107053647.uj7df3ppve4pbfms@merlins.org>
 <10ed4e8a-c9a6-961a-fb51-16186da079e4@cn.fujitsu.com>
 <20161107145502.7lahpm6smqsv6s2q@merlins.org>
CC: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cf75cc57-62f9-2d88-a544-72a45aadd674@cn.fujitsu.com>
Date: Tue, 8 Nov 2016 08:35:54 +0800
MIME-Version: 1.0
In-Reply-To: <20161107145502.7lahpm6smqsv6s2q@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/07/2016 10:55 PM, Marc MERLIN wrote:
> On Mon, Nov 07, 2016 at 02:16:37PM +0800, Qu Wenruo wrote:
>>
>>
>> At 11/07/2016 01:36 PM, Marc MERLIN wrote:
>>> (sorry for the bad subject line from the mdadm list on the previous mail)
>>>
>>> On Mon, Nov 07, 2016 at 12:18:10PM +0800, Qu Wenruo wrote:
>>>> I'm totally wrong here.
>>>>
>>>> DirectIO needs the 'buf' parameter of read()/pread() to be 512 bytes
>>>> aligned.
>>>>
>>>> While we are using a lot of stack memory() and normal malloc()/calloc()
>>>> allocated memory, which are seldom aligned to 512 bytes.
>>>>
>>>> So to *workaround* the problem in btrfs-progs, we may need to change any
>>>> pread() caller to use aligned memory allocation.
>>>>
>>>> I really don't think David will accept such huge change for a workdaround...
>>>
>>> Thanks for looking into it.
>>> So basically should we just document that btrfs filesystems past 8TB in
>>> size are not supported on 32bit architectures?
>>> (as in you can mount them and use them I believe, but you cannot create,
>>> or repair them)
>>>
>>> Marc
>>>
>> Add David to this thread.
>>
>> For create, it should be OK. As at create time, we hardly write beyond 3G.
>> So it won't be a big problem.
>>
>> For repair, we do have a possibility that btrfsck can't handle it.
>>
>> Anyway, I'd like to see how David thinks what we should do the handle the
>> problem.
>
> Understood. One big thing (for me) I forgot to confirm:
> 1) btrfs receive

Unfortunately, receive is completely done in userspace.
Only send works inside kernel.

So, receive will fail to reconstruct any file larger beyond 8T.
Despite that, any other normal file smaller than 8T is not affected.

> 2) btrfs scrub

Scrub does work in kernel, so it's unaffected.

Thanks,
Qu

> should both be able to work because the IO operations are done directly
> inside the kernel and not from user space, correct?
>
> Thanks,
> Marc
>


