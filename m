Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:34248 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbIXSsY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 14:48:24 -0400
Received: by lacdq2 with SMTP id dq2so18895615lac.1
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 11:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5604427D.1000708@gmail.com>
References: <mu1e38$io1$1@ger.gmane.org> <5604427D.1000708@gmail.com>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Thu, 24 Sep 2015 21:48:02 +0300
Message-ID: <CAJs94EbJV+VX16dnkFqH21OMV=uLYSCKnG9KNUCrs7B=rULYLg@mail.gmail.com>
Subject: Re: btrfs: obtain block checksums from user space
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-09-24 21:35 GMT+03:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> On 2015-09-24 14:06, Matwey V. Kornilov wrote:
>>
>>
>> Hello,
>>
>> I would like to read the list of the checksums for the specific file
>> stored onto btrfs filesystem. I think I could use the checksums in the
>> manner like rsync does, but safe both CPU (because csums are already
>> calculated for the file) and I/O (because I don't need to reread all the
>> file from the hard drive).
>
> As of right now, there is no way to do this from userspace without just
> directly parsing the on-disk format (which isn't safe or reliable if the
> filesystem is mounted). It has been discussed before, but the discussions
> haven't really gotten anywhere.
>
> It's worth noting that the way btrfs does checksums isn't per-file, it's
> per-block. This means that:
> a. I think (I'm not 100% certain about this) that the checksum in btrfs
> includes the padding up to the end of the block for blocks that aren't full.
> b. Files that get stored in-line in their metadata block won't have a
> checksum just for the file data (because the checksum will cover the whole
> metadata block).
> c. While it is possible with some checksum algorithms (if I remember right,
> CRC32c is one such algorithm, and that is what btrfs uses for it's
> checksums) to combine the checksums from a group of data blocks to get the
> checksum for data as a whole, this in and of itself takes a significant
> amount of CPU time for large amounts of data.
>
> All in all, this means that if you just want a checksum of the contents of
> the file, it's almost certainly better to just do it in userspace.
> If you're trying to figure out what changed, using send/receive and
> snapshots is more efficient (usually).

I want the checksums of the every block of the file to see which part
has been changed.
I cannot use send/receive because my other file replica is on the
remote host but not on the same filesystem. Compare with how rsync
works. It calculates checksums of the chunks of both versions of the
file and then syncs different chunks over the network. I just want to
utilize the fact that btrfs already has the data I need to calculate.

>>
>>
>> I've looked through linux kernel sources and not found appropriate ioctl
>> to do this. Frankly speaking, I've not found good documentations for all
>> available btrfs ioctls.
>
> I agree that this documentation really needs to be improved (if you want to
> take the time to figure out how it all works, patches for the documentation
> would be greatly appreciated).
>



-- 
With best regards,
Matwey V. Kornilov
http://blog.matwey.name
xmpp://0x2207@jabber.ru
