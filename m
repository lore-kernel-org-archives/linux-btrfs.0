Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:56403
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab3AaBuj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 20:50:39 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Poor performance of btrfs. Suspected unidentified btrfs housekeeping process which writes a lot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5109C2A8.7090005@statystyka.net>
Date: Wed, 30 Jan 2013 18:50:36 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <150353F1-2795-4FDD-A1F4-8F544813E7A0@colorremedies.com>
References: <510934E6.7080302@statystyka.net> <6F302998-3D6E-4E91-9DDA-C475344B51BF@colorremedies.com> <5109C2A8.7090005@statystyka.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2013, at 6:02 PM, Adam Ryczkowski <adam.ryczkowski@statystyka.net> wrote:

>  I didn't take precise measurements, but I can tell, that reading 500 50-byte files (ca. 25kB of data) took way longer that reading one 3MB file, so I suspect the problem is with metadata access times rather than with data.

For 50 byte files, btrfs writes the data with metadata. Depending on their location relative to each other, this could mean 250MB of reads because of the large raid6 chunk size, yet only ~ 2MB is needed by btrfs.


> I am aware, that reading 1MB distributed in small files takes longer than 1MB of sequential reading. The problem is that _suddenly_ this speed  got at least 20 times longer than usual.

How does dedup work on 50 byte files? How does it contribute to fragmentation? And then how does that fragmentation turn into gross read inefficiencies at the md chunk level?


> And from what iotop and systat told me, the harddrives were busy _writing_ something, not _reading_!

Seems like you need to find out what's being written, how many and how big the requests are. Small writes mean huge RWM penalty on raid6, especially a 4 disk raid 6 where you're practically guaranteed to have either data or metadata request halted for a parity rewrite.

> 
> Anyway, I synchronize only the "working copy" part of my file system. All the backup subvolumes sit in a separate path, not seen by the unison.

You're syncing what to what, in physical terms? I know one of the what's is a btrfs volume on top of LVM, on top of LUKs, on top of md raid6, on top of partitions located on four 3TB drives. YOu said there are other partitions on these drives so are there other read/writes occurring on those drives at the same time? It doesn't look like that's the case from iotop, the md0


> Moreover, once I wait long enough for the system to finish scanning the file system, file access speeds are back to normal, even after I drop read cache or even reboot the system. It is only after making another snapshot, when the problems recurs.
>> Another thing, I'd expect this to scale very poorly if the 35 subvolumes contain any appreciable uniqueness, because searches can't be done in parallel. So the more subvolumes you add, the more disk contention you get, but also enormous amounts of latency as possibly 35 locations on the disk are being searched if they happen to be unique.
> 
> *The severity of my problem is proportional to time*. It happens immediately after making snaphot, and persists for each file until I try to read its contents. Than, even after the reboot, timing is back to normal. With my limited knowledge about the internals of btrfs I suspect, that the bedup has messed my metadata somehow. Maybe I should balance only the metadata part (if that is possible at all)?

It's possible to balance just metadata chunks. But I think this is a spaghetti on the wall approach, rather than understanding how all of these layers are interacting with each other.
https://btrfs.wiki.kernel.org/index.php/Balance_Filters

>>> 
>> Why are you using raid6 for four disks, instead of raid10?
> Because I plan to add another 4 in the future. It's way easier to add another disk to the array, than to change the RAID layout.

If this is happening imminently perhaps, in the meantime you have a terribly inefficient raid setup.

>> What's the chunk size for the raid 6? What's the btrfs leaf size? What's the dedup chunk size?
> I'll tell you tomorrow, but I hardly think that the misalignment could be any problem here. As I said, everything was fine and the problem didn't appear in gradual fashion.

It also depends on what mysterious stuff is being written during what's ostensibly a read only event.


>> Why are you using LVM at all, while the /dev/dm-1 is the same size as the LV? You say the btrfs volume on LV is on dm-1 which means they're all the same size, obviating the need for LVM in this case entirely.
> Yes, I agree, that at the moment I don't need it. But when partition sits on logical volume I keep the option to extend the filesystem, when I the need comes.

This is not an ideal way to extend a btrfs file system however. You're adding unnecessarily layers and complexity while also not taking advantage of what LVM can do that btrfs cannot when it comes to logical volume management.


> My current needs are more complex, I don't keep all the date in the same redundancy and security level. It is also hard to tell in advance the relative sizes of each combination of redundancy and security levels. So I allocate only as much space on the GPT partitions as I immediately need, and in the future, when need comes, I can relatively easily make more partitions, arrange them in the appropriate raid/mdcrypt combination, and expand the filesystem that ran out space.

It sounds unnecessarily complex, but what do I know. Hopefully you have everything backed up to something that is comparatively simple. There are more failure points here than I can count.

> 
> I am aware, that this setup is very complex. I can say, that my application is not life-critical, and this complexity serves me well on another Linux server, which I am using over 5 years (without the btrfs, of course).

Well the with btrfs plus dedup adds a lot. And if the problem is disk contention, you may find drive heads dying a lot sooner than you'd otherwise expect.

When this problem is happening, with the low bandwidth writing, can you hear disk chatter? On all of the drives at the same time or just one or two at a time?


Chris Murphy