Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:32837 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752975AbdEWLVh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 07:21:37 -0400
Received: by mail-io0-f175.google.com with SMTP id p24so94977970ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 23 May 2017 04:21:37 -0700 (PDT)
Subject: Re: 4.11.1: cannot btrfs check --repair a filesystem, causes heavy
 memory stalls
To: Chris Murphy <lists@colorremedies.com>, Marc MERLIN <marc@merlins.org>
References: <20170521214733.c62v7el4g66jf63x@merlins.org>
 <20170521234557.pu3vs3igdx7mqjzb@merlins.org>
 <20170522013553.hspdrwpmxe5kyoas@merlins.org>
 <20170522163156.5hcuw5tqfavjkmnm@merlins.org>
 <CAJCQCtSO5O7Pi-4oLsZNr6r6PLVEL6EXA6wpWPjBSUKYe9m4Gg@mail.gmail.com>
 <20170522235754.GJ29894@merlins.org>
 <CAJCQCtR52d2EPgEGPNYDMf3zy7vV-5Yud_k3kVFDrb0JD80PKg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fe10e4c5-fa1b-3725-4680-e4daf939dc8c@gmail.com>
Date: Tue, 23 May 2017 07:21:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR52d2EPgEGPNYDMf3zy7vV-5Yud_k3kVFDrb0JD80PKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-22 22:07, Chris Murphy wrote:
> On Mon, May 22, 2017 at 5:57 PM, Marc MERLIN <marc@merlins.org> wrote:
>> On Mon, May 22, 2017 at 05:26:25PM -0600, Chris Murphy wrote:
>>> On Mon, May 22, 2017 at 10:31 AM, Marc MERLIN <marc@merlins.org> wrote:
>>>
>>>>
>>>> I already have 24GB of RAM in that machine, adding more for the real
>>>> fsck repair to run, is going to be difficult and ndb would take days I
>>>> guess (then again I don't have a machine with 32 or 48 or 64GB of RAM
>>>> anyway).
>>>
>>> If you can acquire an SSD, you can give the system a bunch of swap,
>>> and at least then hopefully the check repair can complete. Yes it'll
>>> be slower than with real RAM but it's not nearly as bad as you might
>>> think it'd be, based on HDD based swap.
>>
>> Oh, swap will work, you're sure?
>> I already have an SSD, if that's good enough, I can give it a shot.
>
> Yeah although I have no idea how much swap is needed for it to
> succeed. I'm not sure what the relationship is to fs metadata chunk
> size to btrfs check RAM requirement is; but if it wants all of the
> metadata in RAM, then whatever btrfs fi us shows you for metadata may
> be a guide (?) for how much memory it's going to want.
I think the in-memory storage is a bit more space efficient than the 
on-disk storage, but I'm not certain, and I'm pretty sure it takes up 
more space when it's actually repairing things.  If I'm doing the math 
correctly, you _may_ need up to 50% _more_ than the total metadata size 
for the FS in virtual memory space.
>
> Another possibility is zswap, which still requires a backing device,
> but it might be able to limit how much swap to disk is needed if the
> data to swap out is highly compressible. *shrug*
>
zswap won't help in that respect, but it might make swapping stuff back 
in faster.  It just keeps a compressed copy in memory in parallel to 
writing the full copy out to disk, then uses that compressed copy to 
swap in instead of going to disk if the copy is still in memory (but it 
will discard the compressed copies if memory gets really low).  In 
essence, it reduces the impact of swapping when memory pressure is 
moderate (the situation for most desktops for example), but becomes 
almost useless when you have very high memory pressure (which is what 
describes this usage).
