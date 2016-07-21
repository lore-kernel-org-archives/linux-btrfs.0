Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36746 "EHLO
	mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbcGUMqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 08:46:35 -0400
Received: by mail-it0-f68.google.com with SMTP id j124so1094673ith.3
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 05:46:35 -0700 (PDT)
Subject: Re: Status of SMR with BTRFS
To: Chris Murphy <lists@colorremedies.com>,
        Hendrik Friedel <hendrik@friedels.name>
References: <b2b863cf-214a-6774-27a4-c41208a578ff@friedels.name>
 <56C7BB16-91D2-42AB-B81A-33403CAFE0ED@gmail.com>
 <9d52a64a-eb5a-e626-2c62-2ff9bede2eef@friedels.name>
 <CAKinxcUBhsh_b6en_4B9cQ77UPMTtbYPusedPegucW3ZP0Fkuw@mail.gmail.com>
 <0e3dfcb6-c635-5904-9e97-1aa11a84dcd4@friedels.name>
 <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
Cc: Tomasz Kusmierz <tom.kusmierz@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, dave@jikos.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bf3f40ff-cb91-d0b3-e60d-27f4e14cbb37@gmail.com>
Date: Thu, 21 Jul 2016 08:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQNt6fBR85opSHfWuKCzH=-2-pF3ctsWsTF-Eb=JwezWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-20 15:58, Chris Murphy wrote:
> On Sun, Jul 17, 2016 at 3:08 AM, Hendrik Friedel <hendrik@friedels.name> wrote:
>
>> Well, btrfs does write data very different to many other file systems. On
>> every write the file is copied to another place, even if just one bit is
>> changed. That's special and I am wondering whether that could cause
>> problems.
>
> It depends on the application. In practice, the program most
> responsible for writing the file often does a faux-COW by writing a
> whole new (temporary) file somewhere, when that operation completes,
> it then deletes the original, and move+renames the temporary one into
> place where the original one, doing fsync in between each of those
> operations. I think some of this is done via VFS also. It's all much
> more metadata centric than what Btrfs would do on its own.
I'm pretty certain that the VFS itself does not do replace by rename 
type stuff.  BTRFS by nature technically does though, it's the same idea 
as a COW update, just at a higher level, so we're technically doing the 
same thing for every single block that changes.  The only issue I can 
think of in this context with a replace by rename is that you end up 
hitting the metadata trees twice.
>
> I'd expect the write pattern of Btrfs to be similar to f2fs, with
> respect to sequentiality of new writes.
Not necessarily, F2FS is log structured, and while not as much like 
traditional log structured filesystems, it still has a similar long-term 
write pattern to stuff like NILFS2 or LFS.  I've not done as much with 
F2FS specifically, but I can say based on comparison to other log 
structured filesystems that outside of WORM write patterns in userspace, 
BTRFS does not have a similar write pattern to a log structured 
filesystem.  We try to pack stuff into existing allocations pretty 
aggressively, so we end up with most of our writes condensed in a small 
area of the disk.  The only cases I've seen where we get long sequential 
writes are when writing out single files one by one, without having 
anything else running at the same time on the FS.

