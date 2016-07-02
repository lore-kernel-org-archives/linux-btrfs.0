Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35261 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbcGBTSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Jul 2016 15:18:07 -0400
Received: by mail-oi0-f43.google.com with SMTP id r2so151286598oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Jul 2016 12:18:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <acd41233-2895-fbfc-8277-5ca2a07c3eef@mendix.com>
References: <472f47d4-b6c9-072d-3fe4-a1ec2af141c7@mendix.com> <acd41233-2895-fbfc-8277-5ca2a07c3eef@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 2 Jul 2016 13:18:05 -0600
Message-ID: <CAJCQCtQGOynjitChtzk4kxzut4_qFOXGNR8xvoOA9Q7tcUvQ7w@mail.gmail.com>
Subject: Re: Filesystem locks up, also with older kernel on any action after
 booting into 4.7-rc4 once
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 2, 2016 at 11:34 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 07/02/2016 07:14 PM, Hans van Kranenburg wrote:
>>
>> I just rebooted a VM into a 4.7 kernel. The joy didn't last long. After
>> 177 seconds the btrfs data partition (root is on ext4) locked up. Worse,
>> it keeps locking up on any action performed even when  rebooting it with
>> older kernels again. D: The filesystem initially mounts fine, but then
>> locks up again immediately.
>>
>> Linux stacheldraht 4.7.0-rc4-amd64 #1 SMP Debian 4.7~rc4-1~exp1
>> (2016-06-20) x86_64 GNU/Linux
>>
>> ps output shows [btrfs-transaction] in D state:
>>
>> root      1108  0.0  0.0      0     0 ?        D    17:42   0:00  \_
>> [btrfs-transacti]
>>
>> From dmesg:
>>
>> [blah blah blah]
>>
>> So, something happened inside the fs that makes it lock up every time I
>> try to do anything with it...
>
>
> I force-rebooted the poor thing again, and mounted the filesystem ro. It
> mounts without any complaint. I can see all files now, I can do sub list
> etc...
>
> So I think I'm going to copy some data to a new filesystem on a new block
> device just in case. The thing has to move to new storage anyway it's about
> 100 subvolumes with about 150GB of data, so that's a nice excercise with
> send/receive.

Two things might be interesting:
1. btrfs check (without repair) to add to the above and see whether it
finds any problems.
2. For send, to try -e option, if you have related subvolume
snapshots. See if this bug is really a bug or user error or maybe it's
fixed.

https://bugzilla.kernel.org/show_bug.cgi?id=111221


-- 
Chris Murphy
