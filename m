Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35396 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbcGUOMs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 10:12:48 -0400
Received: by mail-qk0-f193.google.com with SMTP id q62so6464266qkf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 07:12:47 -0700 (PDT)
Subject: Re: Status of SMR with BTRFS
To: Chris Murphy <lists@colorremedies.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
 <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
 <bf3f40ff-cb91-d0b3-e60d-27f4e14cbb37@gmail.com>
 <CAJCQCtRGtax_ovqA8Xb3DzmeTp=pJkpS0J1hGpe2PongFhfSpg@mail.gmail.com>
Cc: Hendrik Friedel <hendrik@friedels.name>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <13fa8f24-0290-7162-7919-4ecd219c10fd@gmail.com>
Date: Thu, 21 Jul 2016 10:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRGtax_ovqA8Xb3DzmeTp=pJkpS0J1hGpe2PongFhfSpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-21 09:34, Chris Murphy wrote:
> On Thu, Jul 21, 2016 at 6:46 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2016-07-20 15:58, Chris Murphy wrote:
>>>
>>> On Sun, Jul 17, 2016 at 3:08 AM, Hendrik Friedel <hendrik@friedels.name>
>>> wrote:
>>>
>>>> Well, btrfs does write data very different to many other file systems. On
>>>> every write the file is copied to another place, even if just one bit is
>>>> changed. That's special and I am wondering whether that could cause
>>>> problems.
>>>
>>>
>>> It depends on the application. In practice, the program most
>>> responsible for writing the file often does a faux-COW by writing a
>>> whole new (temporary) file somewhere, when that operation completes,
>>> it then deletes the original, and move+renames the temporary one into
>>> place where the original one, doing fsync in between each of those
>>> operations. I think some of this is done via VFS also. It's all much
>>> more metadata centric than what Btrfs would do on its own.
>>
>> I'm pretty certain that the VFS itself does not do replace by rename type
>> stuff.
>
> I can't tell what does it. But so far every program I've tried: vi,
> gedit, GIMP, writes out a new file - as in, it has a different inode
> number and every extent has a different address. That every program
> reimplements this faux-COW would kinda surprise me rather than just
> letting the VFS do it for everyone. I think since ancient times
> literally overwriting files is just a bad idea that pretty much
> guarantees data loss of old and new data if something interrupts that
> overwrite.
This really isn't fake COW, it's COW, just at a higher level than most 
programmers would think of it.  The rename to replace is the pointer 
update, and the copy granularity is variable based on the size of the file.

The whole practice is used by just about everything, and dates back to 
before even SVR4, because traditional filesystems will corrupt files if 
they're being written when a power loss or crash occurs.  It's also 
popular because it breaks hard links, which have often be used as a poor 
man's form of deduplication.  Even on newer journaled filesystems, 
things aren't always safe across a power loss if you don't do this.  It 
can't be done legitimately in the VFS though, because POSIX requires 
that the inode not change if the file is just overwritten or rewritten 
in place.  Vi (which is probably vim on your system, although all other 
implementations I know of do likewise) does the this by itself.  Most 
graphical applications have it happen through libraries they link to (I 
know for a fact that Qt has an option to do this, and I'm pretty certain 
Glib does too, but I don't know if they do by default or not).  In 
general though, it's really not all that much duplicated code, maybe 20 
lines tops, assuming they don't use predictable file names and open code 
the temporary name generation.
>
>> BTRFS by nature technically does though, it's the same idea as a COW
>> update, just at a higher level, so we're technically doing the same thing
>> for every single block that changes.  The only issue I can think of in this
>> context with a replace by rename is that you end up hitting the metadata
>> trees twice.
>
> Do programs have a way to communicate what portion of a data file is
> modified, so that only changed blocks are COW'd? When I change a
> single pixel in a 400MiB image and do a save (to overwrite the
> original file), it takes just as long to overwrite as to write it out
> as a new file. It'd be neat if that could be optimized but I don't see
> it being the case at the moment.
AFAIUI, in BTRFS (and also ZFS), whatever blocks get rewritten get 
COW'ed.  So, rewriting the whole file will COW the whole file, not just 
the blocks that are different.  Trying to check in the FS itself what 
changed is actually rather inefficient (you will almost always spend 
more time comparing data than you will save by writing it all out if 
your using fast storage, and every write potentially implies a huge 
number of reads), and relying on the application to tell us is 
dangerous.  That said, most of the required infrastructure is already 
present in the in-band deduplication stuff, and in fact, it may do this 
for files that get rewritten frequently enough that they don't get 
pushed out of it's cache (I haven't tested for this, and I don't have 
the time or expertise to read through the code to see if it will, but 
based on my current understanding of how it works, it should do this 
implicitly).  The whole thing is a trade off though, because only 
COW'ing the parts that changed leads to higher levels of fragmentation, 
and that's part of why database and disk image files have such issues 
with fragmentation and making them NOCOW helps with these issues, they 
only get spot rewrites.
