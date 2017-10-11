Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:50507 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbdJKMZb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 08:25:31 -0400
Received: by mail-vk0-f51.google.com with SMTP id q80so814422vka.7
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 05:25:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
 <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 11 Oct 2017 14:25:09 +0200
Message-ID: <CAA85sZsVqzk3S2ACGgr+UXAn5ZLE9w-06EcyoyugOJwy56_2Rw@mail.gmail.com>
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Resent since google inbox is still not doing clear-text emails...

On Wed, Oct 11, 2017 at 2:09 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 10/11/17 12:41 PM, Ian Kumlien wrote:

[--8<---]

>> Eventually the filesystem becomes read-only and everything is odd...
>
> Are you still able to mount it?  I'd be surprised if you could if check
> can't open the file system.

Nope, it's like there never was a filesystem in the first place...

But since metadata should be duplicated all over, i'd assume that it
would be able to mount it and survive.... =)

>> Trying to run btrfs check on the disks results in:
>> btrfs check -b /dev/disk/by-uuid/8d431da9-dad4-481c-a5ad-5e6844f31da0
>> bytenr mismatch, want=912228352, have=0
>> Couldn't read tree root
>> ERROR: cannot open file system
>>
>> (For backup and normal)
>>
>> So even if the data is duplicated on all disks, something in the above
>> errors seemed to cause it to abort
>> (These disks are seagate sshd disks, never ever buying them again)
>
> If you have metadata: dup, that doesn't mean the metadata is duplicated
> on every disk.  It means that there are two copies of the metadata on a
> single disk.  If that disk is going bad and returning failures for both
> copies of the metadata, you may be out of luck.  It's really intended
> for single spinning disks to get a little bit more resiliency in the
> face of bad sectors.

Oh? it looks like it would be 2 per 1 device, but ok - Then i could
have had a issue where
the drive that keeps the metadata is gone... I suspected that I did do
DUP on multiple devices

from the man page:
       Note 1: DUP may exist on more than 1 device if it starts on a
single device and another one is added. Since version 4.5.1,
       mkfs.btrfs will let you create DUP on multiple devices.

> The check error above means that it wasn't able to map a logical address
> to a physical address.  Typically that means that the mapping was lost.

I was more reporting that it happened and if there was any useful data
that we could
extract from this if it's a failure that shouldn't happen :)

I haven't wiped anything yet - preparing to replace the disks though
