Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:34116 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdHPPID (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 11:08:03 -0400
Received: by mail-io0-f171.google.com with SMTP id o9so14082570iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 08:08:03 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <1502890308.5446.5.camel@scientia.net>
 <152c3e70-72e2-0d26-e145-979f602257b7@gmail.com>
 <1502892678.5446.7.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4ab82797-a2fb-4c5e-2778-e711d192e0d0@gmail.com>
Date: Wed, 16 Aug 2017 11:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <1502892678.5446.7.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-16 10:11, Christoph Anton Mitterer wrote:
> On Wed, 2017-08-16 at 09:53 -0400, Austin S. Hemmelgarn wrote:
>> Go try BTRFS on top of dm-integrity, or on a
>> system with T10-DIF or T13-EPP support
> 
> When dm-integrity is used... would that be enough for btrfs to do a
> proper repair in the RAID+nodatacow case? I assume it can't do repairs
> now there, because how should it know which copy is valid.
dm-integrity is functionally a 1:1 mapping target (it uses a secondary 
device for storing the integrity info, but it requires one table per 
target).  It takes one backing device, and gives one mapped device.  The 
setup I'm suggesting would involve putting that on each device that you 
have BTRFS configured to use.  When the checksum there fails, you get a 
read error (AFAIK at least), which will trigger the regular BTRFS 
recovery code just like a failed checksum.  So in this case, it should 
recover just fine if one copy is bogus (assuming it's a media issue and 
not something between the the block device and the filesystem.

In all honesty, putting BTRFS on dm-integrity is going to be slow.  If 
you can find some T10 DIF or T13 EPP hardware, that will almost 
certainly be faster.
> 
> 
>>   (which you should have access to
>> given the amount of funding CERN gets)
> Hehe, CERN may get that funding (I don't know),... but the universities
> rather don't ;-)
Point taken, I often forget that funding isn't exactly distributed in 
the most obvious ways.
> 
> 
>> Except it isn't clear with nodatacow, because it might be a false
>> positive.
> 
> Sure, never claimed the opposite... just that I'd expect this to be
> less likely than the other way round, and less of a problem in
> practise.
Any number of hardware failures or errors can cause the same net effect 
as an unclean shutdown, and even some much more complicated issues (a 
loose data cable to a storage device is probably one of the best 
examples, as it's trivial to explain and not as rare as most people think).
> 
> 
> 
>> SUSE is pathological case of brain-dead defaults.  Snapper needs to
>> either die or have some serious sense beat into it.  When you turn
>> off
>> the automatic snapshot generation for everything but updates and set
>> the
>> retention policy to not keep almost everything, it's actually not bad
>> at
>> all.
> 
> Well, still, with CoW (unless you have some form of deduplication,
> which in e.g. their use case would have to be on the layers below
> btrfs), your storage usage will grow probably more significantly than
> without.
Yes, and for most VM use cases I would advocate not using BTRFS 
snapshots inside the VM and instead using snapshot functionality in the 
VM software itself.  That still has performance issues in some cases, 
but at least it's easier to see where the data is actually being used.
> 
> And as you've mentioned yourself in the other mail, there's still the
> issue with fragmentation.
> 
> 
>> Snapshots work fine with nodatacow, each block gets CoW'ed once when
>> it's first written to, and then goes back to being NOCOW.  The only
>> caveat is that you probably want to defrag either once everything
>> has
>> been rewritten, or right after the snapshot.
> 
> I thought defrag would unshare the reflinks?
Which is exactly why you might want to do it.  It will get rid of the 
overhead of the single CoW operation, and it will make sure there is 
minimal fragmentation.  IOW, when mixing NOCOW and snapshots, you either 
have to use extra space, or you deal with performance issues.  Aside 
from that though, it works just fine and has no special issues as 
compared to snapshots without NOCOW.
