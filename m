Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33948 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbcGUNe6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 09:34:58 -0400
Received: by mail-oi0-f68.google.com with SMTP id c199so7710181oig.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 06:34:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bf3f40ff-cb91-d0b3-e60d-27f4e14cbb37@gmail.com>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com> <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name> <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
 <bf3f40ff-cb91-d0b3-e60d-27f4e14cbb37@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 21 Jul 2016 07:34:57 -0600
Message-ID: <CAJCQCtRGtax_ovqA8Xb3DzmeTp=pJkpS0J1hGpe2PongFhfSpg@mail.gmail.com>
Subject: Re: Status of SMR with BTRFS
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Hendrik Friedel <hendrik@friedels.name>,
        Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 21, 2016 at 6:46 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-20 15:58, Chris Murphy wrote:
>>
>> On Sun, Jul 17, 2016 at 3:08 AM, Hendrik Friedel <hendrik@friedels.name>
>> wrote:
>>
>>> Well, btrfs does write data very different to many other file systems. On
>>> every write the file is copied to another place, even if just one bit is
>>> changed. That's special and I am wondering whether that could cause
>>> problems.
>>
>>
>> It depends on the application. In practice, the program most
>> responsible for writing the file often does a faux-COW by writing a
>> whole new (temporary) file somewhere, when that operation completes,
>> it then deletes the original, and move+renames the temporary one into
>> place where the original one, doing fsync in between each of those
>> operations. I think some of this is done via VFS also. It's all much
>> more metadata centric than what Btrfs would do on its own.
>
> I'm pretty certain that the VFS itself does not do replace by rename type
> stuff.

I can't tell what does it. But so far every program I've tried: vi,
gedit, GIMP, writes out a new file - as in, it has a different inode
number and every extent has a different address. That every program
reimplements this faux-COW would kinda surprise me rather than just
letting the VFS do it for everyone. I think since ancient times
literally overwriting files is just a bad idea that pretty much
guarantees data loss of old and new data if something interrupts that
overwrite.


>BTRFS by nature technically does though, it's the same idea as a COW
> update, just at a higher level, so we're technically doing the same thing
> for every single block that changes.  The only issue I can think of in this
> context with a replace by rename is that you end up hitting the metadata
> trees twice.

Do programs have a way to communicate what portion of a data file is
modified, so that only changed blocks are COW'd? When I change a
single pixel in a 400MiB image and do a save (to overwrite the
original file), it takes just as long to overwrite as to write it out
as a new file. It'd be neat if that could be optimized but I don't see
it being the case at the moment.


-- 
Chris Murphy
