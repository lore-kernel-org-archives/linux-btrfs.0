Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:40422 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbeAXMbB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 07:31:01 -0500
Received: by mail-io0-f196.google.com with SMTP id t22so4661319ioa.7
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 04:31:01 -0800 (PST)
Subject: Re: bad key ordering - repairable?
To: Chris Murphy <lists@colorremedies.com>
Cc: Claes Fransson <claes.v.fransson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
 <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com>
 <CAJCQCtSTeNmL=uk_j6Wt1CXC9HOdRDCKGiO+U-9ovt0CHNijFg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1ad78ca9-f0bd-1420-4a92-27a453ea7540@gmail.com>
Date: Wed, 24 Jan 2018 07:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSTeNmL=uk_j6Wt1CXC9HOdRDCKGiO+U-9ovt0CHNijFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-23 19:44, Chris Murphy wrote:
> On Tue, Jan 23, 2018 at 5:51 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>> This is extremely important to understand.  BTRFS and ZFS are essentially
>> the only filesystems available on Linux that actually validate things enough
>> to notice this reliably (ReFS on Windows probably does, and I think whatever
>> Apple is calling their new FS does too).
> 
> ReFS always checksums metadata, optionally can checksum data.
Good to know, I've not actually dealt with ReFS myself yet (we're mostly 
a Linux shop where I work, and the two Windows servers we do have aren't 
using ReFS simply because it wasn't beyond the technology preview level 
when we installed them and we don't want to screw anything up).
> 
> APFS is really vague on this front, it may be checksumming metadata,
> it's not checksumming data and with no option to. Apple proposes their
> branded storage devices do not return bogus data. OK so then why
> checksum the metadata?
Even aside from the fact that it might be checksumming data, Apple's 
storage engineers are still smoking something pretty damn strong if they 
think that they can claim their storage devices _never_ return bogus 
data.  Either they're running some kind of checksumming _and_ 
replication below the block layer in the storage device itself (which 
actually might explain the insane cost of at least one piece of their 
hardware), or they think they've come up with some fail-safe way to 
detect corruption and return errors reliably, and in either case things 
can still fail.  I smell a potential future lawsuit in the works...
> 
>> Even if ext4 did notice it, it
>> would just mark the filesystem for a check and then keep going without doing
>> anything else about it (seriously, the default behavior for internal errors
>> on ext4 is to just continue like nothing happened and mark the FS for fsck).
> 
> I haven't used ext4 with metadata checksumming enabled, and have no
> idea how it behaves when it starts encountering checksum errors during
> normal use. For sure XFS will complain a lot and will go read only
> when it gets confused. I'd expect any file system going to the trouble
> of checksumming would have to have some means of bailing out, rather
> than just continuing on.
Actually, I forgot about the (newer) metadata checksumming feature in 
ext4, and was just basing my statement on behavior the last time I used 
it for anything serious.  Having just checked mkfs.ext4, it appears that 
the metadata in the SB that tells the kernel what to do when it runs 
into an error for the FS still defaults to continuing on as if nothing 
happens, even if you enable metadata checksumming (which still seems to 
be disabled by default).  Whether or not that actually is honored by 
modern kernels, I don't know, but I've seen no evidence to suggest that 
it isn't.
> 
> Btrfs (and maybe ZFS) COW everything except supers. So ostensibly a
> future feature might let them continue on with a kind of
> integrated/single volume variation on seed/sprout device. I'd like to
> see something like this just for undoable and testable offline
> repairs, rather than offline repair only being predicated on
> overwritting metadata.Agreed.
