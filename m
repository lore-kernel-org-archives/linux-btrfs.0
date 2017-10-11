Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:49805 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdJKPRZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 11:17:25 -0400
Received: by mail-ua0-f182.google.com with SMTP id h34so1291385uaa.6
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 08:17:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <edf2cb77-6e85-98ea-f16e-1fa2399cbdc6@suse.com>
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
 <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com> <CAA85sZv2pctgR+yDR7biJO8H-0D4mwR5MhbdcrfG122rphbJ7A@mail.gmail.com>
 <edf2cb77-6e85-98ea-f16e-1fa2399cbdc6@suse.com>
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 11 Oct 2017 17:17:03 +0200
Message-ID: <CAA85sZvo83aaMWnouSEtf2sqpfjPqE+XJm8iapOUWgixE5UdxA@mail.gmail.com>
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 2:42 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 10/11/17 2:20 PM, Ian Kumlien wrote:
>>
>>
>> On Wed, Oct 11, 2017 at 2:10 PM Jeff Mahoney <jeffm@suse.com
>> <mailto:jeffm@suse.com>> wrote:
>>
>>     On 10/11/17 12:41 PM, Ian Kumlien wrote:
>>
>> [--8<--]
>>
>>     > Eventually the filesystem becomes read-only and everything is odd...
>>
>>     Are you still able to mount it?  I'd be surprised if you could if check
>>     can't open the file system.
>>
>>
>> Nope, it's like there never was a filesystem in the first place...
>>
>> But since metadata should be duplicated all over, i'd assume that it
>> would be able to mount it and survive.... =)
>
> If you'd been using RAID1 or something instead, you'd be able to mount
> the file system and replace the disk.

Yep, It wasn't a problem, i had a backup and so on (and the disks had
been odd before)

>>     > Trying to run btrfs check on the disks results in:
>>     > btrfs check -b /dev/disk/by-uuid/8d431da9-dad4-481c-a5ad-5e6844f31da0
>>     > bytenr mismatch, want=912228352, have=0
>>     > Couldn't read tree root
>>     > ERROR: cannot open file system
>>     >
>>     > (For backup and normal)
>>     >
>>     > So even if the data is duplicated on all disks, something in the above
>>     > errors seemed to cause it to abort
>>     > (These disks are seagate sshd disks, never ever buying them again)
>>
>>     If you have metadata: dup, that doesn't mean the metadata is duplicated
>>     on every disk.  It means that there are two copies of the metadata on a
>>     single disk.  If that disk is going bad and returning failures for both
>>     copies of the metadata, you may be out of luck.  It's really intended
>>     for single spinning disks to get a little bit more resiliency in the
>>     face of bad sectors.
>>
>>
>> Oh? it looks like it would be 2 per 1 device, but ok - Then i could have
>> had a issue where the drive that keeps the metadata is gone... I
>> suspected that I did do DUP on multiple devices
>>
>> from the man page:
>>        Note 1: DUP may exist on more than 1 device if it starts on a
>> single device and another one is added. Since version 4.5.1,
>>        mkfs.btrfs will let you create DUP on multiple devices.
>
> I can see how you'd reach that conclusion.  The wording is somewhat
> confusing.  We allocate space in chunks that are usually about 1GB in
> size.  When DUP is used, we allocate two chunks on the same device and
> that is presented as a single usable chunk.  The constituent chunks will
> be allocated on the same device, but which device is used can change
> with each allocation.
>
> Say you have 5 disks and 8 metadata chunks.  They can be allocated like so:
>
> sda: A A D D
> sdb: B B
> sdc: C C
> sde: F F G G
> sdf: H H I I
>
> There is no redundancy in the case of a disk failure, only for sector
> failures.  To spread metadata across disks for redundancy you'll need to
> use a raid mode instead.  If one of those disks is failing and it
> contains a critical part of the metadata, the file system won't be
> mountable.

Yeah, thanks =)

>>     The check error above means that it wasn't able to map a logical address
>>     to a physical address.  Typically that means that the mapping was lost.
>>
>>
>> I was more reporting that it happened and if there was any useful data
>> that we could extract from this if it's a failure that shouldn't happen :)
>>
>> I haven't wiped anything yet - preparing to replace the disks though
>
> Thanks for reporting it, but in this context, it's somewhat of an
> expected failure mode.

Yep, i see that now, thanks =)
