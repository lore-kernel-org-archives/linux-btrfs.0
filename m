Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57251 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbcGBTkc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 15:40:32 -0400
Subject: Re: Filesystem locks up, also with older kernel on any action after
 booting into 4.7-rc4 once
To: Chris Murphy <lists@colorremedies.com>
References: <472f47d4-b6c9-072d-3fe4-a1ec2af141c7@mendix.com>
 <acd41233-2895-fbfc-8277-5ca2a07c3eef@mendix.com>
 <CAJCQCtQGOynjitChtzk4kxzut4_qFOXGNR8xvoOA9Q7tcUvQ7w@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <0d0631a5-cd8a-9a1f-2ce5-0810bc9bf441@mendix.com>
Date: Sat, 2 Jul 2016 21:40:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQGOynjitChtzk4kxzut4_qFOXGNR8xvoOA9Q7tcUvQ7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2016 09:18 PM, Chris Murphy wrote:
> On Sat, Jul 2, 2016 at 11:34 AM, Hans van Kranenburg
> <hans.van.kranenburg@mendix.com> wrote:
>> On 07/02/2016 07:14 PM, Hans van Kranenburg wrote:
>>>
>>> I just rebooted a VM into a 4.7 kernel. The joy didn't last long. After
>>> 177 seconds the btrfs data partition (root is on ext4) locked up. Worse,
>>> it keeps locking up on any action performed even when  rebooting it with
>>> older kernels again. D: The filesystem initially mounts fine, but then
>>> locks up again immediately.
>>>
>>> Linux stacheldraht 4.7.0-rc4-amd64 #1 SMP Debian 4.7~rc4-1~exp1
>>> (2016-06-20) x86_64 GNU/Linux
>>>
>>> ps output shows [btrfs-transaction] in D state:
>>>
>>> root      1108  0.0  0.0      0     0 ?        D    17:42   0:00  \_
>>> [btrfs-transacti]
>>>
>>> From dmesg:
>>>
>>> [blah blah blah]
>>>
>>> So, something happened inside the fs that makes it lock up every time I
>>> try to do anything with it...
>>
>>
>> I force-rebooted the poor thing again, and mounted the filesystem ro. It
>> mounts without any complaint. I can see all files now, I can do sub list
>> etc...
>>
>> So I think I'm going to copy some data to a new filesystem on a new block
>> device just in case. The thing has to move to new storage anyway it's about
>> 100 subvolumes with about 150GB of data, so that's a nice excercise with
>> send/receive.
>
> Two things might be interesting:
> 1. btrfs check (without repair) to add to the above and see whether it
> finds any problems.
> 2. For send, to try -e option, if you have related subvolume
> snapshots. See if this bug is really a bug or user error or maybe it's
> fixed.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=111221

The directory structure is dirvish with my btrfs patches.

These are the subvols:

2016050802/tree
2016051502/tree

So they're all named tree. I cannot just send them all to some location. 
And I cannot rename them, because the fs is mounted ro...

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
