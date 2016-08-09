Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:36042 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbcHINk0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 09:40:26 -0400
Received: by mail-qk0-f180.google.com with SMTP id l2so12457172qkf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 06:40:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1b31f650-6c29-7b46-eafb-0434a26f15d6@gmail.com>
References: <e4671ca6-38bc-ce32-0bc9-c1e7bc9873cd@web.de> <1b31f650-6c29-7b46-eafb-0434a26f15d6@gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 9 Aug 2016 09:39:45 -0400
Message-ID: <CADfjVrgzMNrsfv=S9+zPBZEcvkfiP=fg-Pi8gB+W1gYaJTxcRA@mail.gmail.com>
Subject: Re: Issue: errno:28 (No space left on device)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Thomas <c.monty@web.de>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 8:56 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-08-09 07:50, Thomas wrote:
>>
>> Hello!
>
> First things first:
> Mailing lists are asynchronous.  You will almost _never_ get an immediate
> response, and will quite often not get a response for a few hours at least.
> Sending a message more than once when you don't get a response does not make
> it more likely you get a response quickly, and in fact is a good way to
> seriously annoy people and make them less willing to help you.
>>
>>
>> I'm facing a severe issue with Debian installation using BTRFS:
>> errno:28 (No space left on device)
>>
>> After a few minutes of system usage I get this error message for any
>> action, means there's really no disk space left.
>>
>> However, the output of btrfs fi usage / reports that ~10% of disk space
>> should be free.
>>
>> I have 2 questions:
>> 1. Why is the OS reporting an error "Issue: errno:28 (No space left on
>> device)" whereas "btrfs fi usage" reports free space?
>
> BTRFS allocates disk space in two stages.  In the first stage, it allocates
> large chunks that then get used only for metadata or data. Within those
> chunks, it then allocates blocks for the given type of data on-demand.  In
> your case, the filesystem has no room to allocate new chunks, but has some
> free space in existing chunks.  This shouldn't result in allocation failures
> for new files, but for currently unknown reasons it sometimes does, and this
> is a known issue that we have been unable to completely fix so far (we've
> technically 'fixed' this about 5 or 6 times already, but there appear to be
> lots of odd corner cases that haven't been found yet).
>>
>> 2. How can I solve this issue w/o the possibility of extending the
>> partition?
>
> Right now, you have three options:
> 1. Extend the partition, run a full balance, and then shrink the partition
> again.
> 2. Temporarily add another device (make sure it's at least 4GB), run a full
> balance, and then remove the device.
> 3. Recreate the filesystem from scratch and restore from a backup.
>

A quick note recreating the filesystem:
Since your data and metadata profiles are both 'single', you may want
to consider creating the filesystem with the --mixed option, which
allows / forces BTRFS to use a single collection of data blocks for
both data and metadata.
This can help with ENOMEM errors when all space is allocated, but the
allocation does not match the currently required type.

~ Noah
