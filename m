Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36663 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbbLOQDc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 11:03:32 -0500
Received: by mail-io0-f174.google.com with SMTP id o67so24076892iof.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 08:03:32 -0800 (PST)
Subject: Re: attacking btrfs filesystems via UUID collisions?
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5668A1CB.1020007@anonym.com>
 <CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
 <1449872498.31388.74.camel@fo>
 <CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
 <1450052868.30943.27.camel@scientia.net> <566EC2D7.3000101@gmail.com>
 <CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
 <56701B79.8030105@gmail.com> <20151215141813.GG26782@carfax.org.uk>
 <56702340.2090908@gmail.com> <20151215144210.GH26782@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <567039D4.70400@gmail.com>
Date: Tue, 15 Dec 2015 11:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <20151215144210.GH26782@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-15 09:42, Hugo Mills wrote:
> On Tue, Dec 15, 2015 at 09:27:12AM -0500, Austin S. Hemmelgarn wrote:
>> On 2015-12-15 09:18, Hugo Mills wrote:
>>> On Tue, Dec 15, 2015 at 08:54:01AM -0500, Austin S. Hemmelgarn wrote:
>>>> On 2015-12-14 16:26, Chris Murphy wrote:
>>>>> On Mon, Dec 14, 2015 at 6:23 AM, Austin S. Hemmelgarn
>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>
>>>>>> Agreed, if yo9u can't substantiate _why_ it's bad practice, then you aren't
>>>>>> making a valid argument.  The fact that there is software that doesn't
>>>>>> handle it well would say to me based on established practice that that
>>>>>> software is what's broken, not common practice.
>>>>>
>>>>> The automobile is invented and due to the ensuing chaos, common
>>>>> practice of doing whatever the F you wanted came to an end in favor of
>>>>> rules of the road and traffic lights. I'm sure some people went
>>>>> ballistic, but for the most part things were much better without the
>>>>> brokenness or prior common practice.
>>>> Except for one thing:  Automobiles actually provide a measurable
>>>> significant benefit to society.  What specific benefit does
>>>> embedding the filesystem UUID in the metadata actually provide?
>>>
>>>     That one's easy to answer. It deals with a major issue that
>>> reiserfs had: if you have a filesystem with another filesystem image
>>> stored on it, reiserfsck could end up deciding that both the metadata
>>> blocks of the main filesystem *and* the metadata blocks of the image
>>> were part of the same FS (because they're on the same block device),
>>> and so would splice both filesystems into one, generally complaining
>>> loudly along the way that there was a lot of corruption present that
>>> it was trying to fix.
>> IIRC, that was because of the way the SB was designed, and is why
>> other filesystems have a UUID in the superblock.
>>
>> I probably should have been clearer with my statement, what I meant was:
>> What specific benefit does using the UUID for multi-device
>> filesystems to identify the various devices provide?
>
>     Well, given a bunch of block devices, how do you identify which
> ones to use for each of the (unknown number of) filesystems in the
> system?
>
>     You can either use some kind of config file, which is going to get
> out of date as device enumeration orders change or as devices are
> added/deleted from the FS, or you can try to identify the devices that
> belong together automatically in some way. btrfs uses the latter
> option (with the former option kind of supported using the device=
> mount option). The use of a UUID isn't fundamental to the latter
> process, but anything that you replaced the UUID with would have the
> same issues that we're seeing here -- make a duplicate of the device
> at the block level, and you get additional devices that look like they
> should be part of the FS.
>
>     The question is not how you avoid duplicating the UUIDs, but how
> you identify that there are duplicates present, and how you deal with
> that issue once you've detected them. This is complicated by the fact
> that it's perfectly legitimate to have two block devices in the system
> that identify themselves as the same device for the same filesystem --
> this happens when they're different views of the same underlying
> storage through multipathing.
>
>     I would suggest trying to migrate to a state where detecting more
> than one device with the same UUID and devid is cause to prevent the
> FS from mounting, unless there's also a "mount_duplicates_yes_i_
> know_this_is_dangerous_and_i_know_what_im_doing" mount flag present,
> for the multipathing people. That will break existing userspace
> behaviour for the multipathing case, but the migration can probably be
> managed. (e.g. NFS has successfully changed default behaviour for one
> of its mount options in the last few(?) years).
May I propose the alternative option of adding a flag to tell mount to 
_only_ use the devices specified in the options?  That would allow 
people to work around the common issues (multipath, dm-cache, etc), and 
would provide people who have stable device enumeration to mitigate the 
possibility of an attack.

