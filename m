Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35643 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbcCPLkh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 07:40:37 -0400
Received: by mail-qk0-f181.google.com with SMTP id o6so19372148qkc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 04:40:36 -0700 (PDT)
Subject: Re: Snapshots slowing system
To: Peter Chant <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56E945E9.1050005@gmail.com>
Date: Wed, 16 Mar 2016 07:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <56E88CB2.6020300@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-15 18:29, Peter Chant wrote:
> On 03/15/2016 03:52 PM, Duncan wrote:
>> Tho even with autodefrag, given the previous relatime and snapshotting,
>> it could be that the free-space in existing chunks is fragmented, which
>> over time and continued usage would force higher file fragmentation
>> despite the autodefrag, since there simply aren't any large contiguous
>> free-space areas left in which to write files.
>>
>
> Hmm. The following returns instantly as if it were a null operation.
> btrfs fi defrag /
That should return almost immediately, as defrag isn't recursive by 
default, and / should only have at most about 16-20 directory entries.
>
> I thought though that btrfs fi defrag <name> would only defrag the one
> file or directory?
It does, it's just not recursive unless you tell it to be.
>
> btrfs fi defrag /srv/photos/
> Is considerably slower, it is still running.  Disk light is on solid.
> Processes kworker and btrfs-transacti are pretty busy according to iotop.
If you have a lot of items in /srv/photos/ (be it either lots of 
individual files, or lots of directories at the top level), then this is 
normal, if not, then you may have found a bug.
>>
>> Boot is an exception to the usual btrfs raid1, with a separate working
>> boot partition on one device and its backup on the other, so I can point
>> the BIOS at and boot either one.  It's btrfs mixed-bg mode dup, 256 MiB
>> for each of working and backup, which because it's dup means 128 MiB
>> capacity.  That's actually a bit small, and why I'll be shrinking the log
>> partition the next time I repartition.  Making it 384 MiB dup, for 192
>> MiB capacity, would be much better, and since I can shrink the log
>> partition by that and still keep the main partitions GiB aligned, it all
>> works out.
>>
>
> Slackware uses lilo so I need a separate /boot with something that is
> supported by lilo.
I would like to point out that just because the distribution prefers one 
package doesn't mean you can't use another, it's just not quite as easy. 
  It's worth noting that I do similarly to Duncan in this respect 
though, although I provisioned 512MiB when I set things up (and stuck 
the BIOS boot partition (because I use GPT on everything these days) in 
the unaligned slack space between the partition table and /boot).  It 
also has the advantage that I can fall back to old versions of the 
kernel and initrd if need be when an upgrade fails to boot for some reason.
>
> <snip>
>
>> If I had 500 GiB SSDs like the one you're getting, I could put the media
>> partition on SSDs and be rid of the spinning rust entirely.  But I seem
>> to keep finding higher priorities for the money I'd spend on a pair of
>> them...
>
>
> I'm getting one, not two, so the system is raid0.  Data is more
> important (and backed up).
If you don't need the full terabyte of space, I would seriously suggest 
using raid1 instead of raid0.  If you're using SSD's, then you won't get 
much performance gain from BTRFS raid0 (because the I/O dispatching is 
not particularly smart), and it also makes it more likely that you will 
need to rebuild from scratch.

