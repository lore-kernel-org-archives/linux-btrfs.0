Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr50059.outbound.protection.outlook.com ([40.107.5.59]:65404
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030762AbdKRLsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 06:48:51 -0500
Subject: Re: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
To: Roman Mamedov <rm@romanrm.net>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
 <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
 <20171118144037.0fa8ad4b@natsu>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <2cbd136b-4fa7-fcee-7472-0941efa97047@mendix.com>
Date: Sat, 18 Nov 2017 12:48:44 +0100
MIME-Version: 1.0
In-Reply-To: <20171118144037.0fa8ad4b@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2017 10:40 AM, Roman Mamedov wrote:
> On Sat, 18 Nov 2017 02:08:46 +0100
> Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:
> 
>> It's using send + balance at the same time. There's something that makes
>> btrfs explode when you do that.
>>
>> It's not new in 4.14, I have seen it in 4.7 and 4.9 also, various
>> different explosions in kernel log. Since that happened, I made sure I
>> never did those two things at the same time.
> 
> Shouldn't it prevent send during balance, or balance during send then, if
> that's the case?
> 
> You talk about it "exploding" like it's a normal thing,

No, no, it's absolutely not normal of course. It's pretty scary.

> to have Invalid opcode
> BUGs in kernel log, and the user has to take care to not use two of the
> regular FS features at the same time.
> 
> Seems to be a bug which should be fixed, rather than warning everyone "not to
> send during balance".

Yes, sure. In the meantime, watch out with that combination. And that's
what I quickly typed yesterday, because it was too late already.

My experience with reporting bugs like this is that to get time spent on
it, either a developer himself has to experience the issue, or you have
to be able to provide a reliable reproducer. And yes, I also never got
to doing that myself yet.

So, who wants to help?

1. Find a test system that you can crash.
2. Create a test filesystem with some data.
3. Run with 4.14? (makes the most sense I think)
4. Continuously feed the data to balance and send everything to /dev/null
5. Collect stack traces and borken filesystem images.

-- 
Hans van Kranenburg
