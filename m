Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34662 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbcHLMFE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 08:05:04 -0400
Received: by mail-qk0-f174.google.com with SMTP id f123so6684152qkd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 05:05:03 -0700 (PDT)
Subject: Re: checksum error in metadata node - best way to move root fs to new
 drive?
To: Dave T <davestechshop@gmail.com>, Duncan <1i5t5.duncan@cox.net>
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
Cc: Nicholas D Steeves <nsteeves@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <35417d9d-c3e4-6a3a-50e0-bdd91bf39f80@gmail.com>
Date: Fri, 12 Aug 2016 08:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-11 16:23, Dave T wrote:
> What I have gathered so far is the following:
>
> 1. my RAM is not faulty and I feel comfortable ruling out a memory
> error as having anything to do with the reported problem.
>
> 2. my storage device does not seem to be faulty. I have not figured
> out how to do more definitive testing, but smartctl reports it as
> healthy.
Is this just based on smartctl -H, or is it based on looking at all the 
info available from smartctl?  Based on everything you've said so far, 
it sounds to me like there was a group of uncorrectable errors on the 
disk, and the sectors in question have now been remapped by the device's 
firmware.  Such a situation is actually more common than people think 
(this is part of the whole 'reinstall to speed up your system' mentality 
in the Windows world).  I've actually had this happen before (and 
correlated the occurrences with spikes in readings from the data-logging 
Geiger counter I have next to my home server).  Most disks don't start 
to report as failing until they get into pretty bad condition (on most 
hard drives, it takes a pretty insanely large count of reallocated 
sectors to mark the disk as failed in the drive firmware, and on SSD's 
you pretty much have to run it out of spare blocks (which takes a _long_ 
time on many SSD's)).
>
> 3. this problem first happened on a normally running system in light
> use. It had not recently crashed. But the root fs went read-only for
> an unknown reason.
>
> 4. the aftermath of the initial problem may have been exacerbated by
> hard resetting the system, but that's only a guess
>
>> The compression-related problem is this:  Btrfs is considerably less tolerant of checksum-related errors on btrfs-compressed data
>
> I'm an unsophisticated user. The argument in support of this statement
> sounds convincing to me. Therefore, I think I should discontinue using
> compression. Anyone disagree?
>
> Is there anything else I should change? (Do I need to provide
> additional information?)
>
> What can I do to find out more about what caused the initial problem.
> I have heard memory errors mentioned, but that's apparently not the
> case here. I have heard crash recovery mentioned, but that isn't how
> my problem initially happened.
>
> I also have a few general questions:
>
> 1. Can one discontinue using the compress mount option if it has been
> used previously? What happens to existing data if the compress mount
> option is 1) added when it wasn't used before, or 2) dropped when it
> had been used.
Yes, it just affects newly written data.  If you want to convert 
existing data to be uncompressed, you'll need to run 'btrfs filesystem 
defrag -r ' on the filesystem to convert things.
>
> 2. I understand that the compress option generally improves btrfs
> performance (via Phoronix article I read in the past; I don't find the
> link). Since encryption has some characteristics in common with
> compression, would one expect any decrease in performance from
> dropping compression when using btrfs on dm-crypt? (For more context,
> with an i7 6700K which has aes-ni, CPU performance should not be a
> bottleneck on my computer.)
I would expect a change in performance in that case, but not necessarily 
a decrease.  The biggest advantage of compression is that it trades time 
spent using the disk for time spent using the CPU.  In many cases, this 
is a favorable trade-off when your storage is slower than your memory 
(because memory speed is really the big limiting factor here, not 
processor speed).  In your case, the encryption is hardware accelerated, 
but the compression isn't, so you should in theory actually get better 
performance by turning off compression.
>
> 3. How do I find out if it is appropriate to use dup metadata on a
> Samsung 950 Pro NVMe drive? I don't see deduplication mentioned in the
> drive's datasheet:
> http://www.samsung.com/semiconductor/minisite/ssd/downloads/document/Samsung_SSD_950_PRO_Data_Sheet_Rev_1_2.pdf
Whether or not it does deduplication is hard to answer.  If it does, 
then you obviously should avoid dup metadata.  If it doesn't, then it's 
a complex question as to whether or not to use dup metadata.  The short 
explanation for why is that the SSD firmware maintains a somewhat 
arbitrary mapping between LBA's and actual location of the data in 
flash, and it tends to group writes from around the same time together 
in the flash itself.  The argument against dup on SSD's in general takes 
this into account, arguing that because the data is likely to be in the 
same erase block for both copies, it's not as well protected. 
Personally, I run dup on non-deduplicationg SSD's anyway, because I 
don't trust higher layers to not potentially mess up one of the copies, 
and I still get better performance than most hard disks.
>
> 4. Given that my drive is not reporting problems, does it seem
> reasonable to re-use this drive after the errors I reported? If so,
> how should I do that? Can I simply make a new btrfs filesystem and
> copy my data back? Should I start at a lower level and re-do the
> dm-crypt layer?
If it were me, I'd rebuild from the ground up just to be sure that 
everything is in a known working state.  That way you can be reasonably 
sure any issues are not left over from the previous configuration.
>
> 5. Would most of you guys use btrfs + dm-crypt on a production file
> server (with spinning disks in JBOD configuration -- i.e., no RAID).
> In this situation, the data is very important, of course. My past
> experience indicated that RAID only improves uptime, which is not so
> critical in our environment. Our main criteria is that we should never
> ever have data loss. As far as I understand it, we do have to use
> encryption.
On a file server?  No, I'd ensure proper physical security is 
established and make sure it's properly secured against network based 
attacks and then not worry about it.  Unless you have things you want to 
hide from law enforcement or your government (which may or may not be 
legal where you live) or can reasonably expect someone to steal the 
system, you almost certainly don't actually need whole disk encryption. 
There are two specific exceptions to this though:
1. If your employer requires encryption on this system, that's their call.
2. Encrypted swap is a good thing regardless, because it prevents 
security credentials from accidentally being written unencrypted to 
persistent storage.

On my personal systems, I only use encryption for swap space and 
security credentials, but I use file based encryption for the 
credentials.  I also don't store any data that needs absolute protection 
against people stealing it though (other than the security credentials, 
but I can remotely deauthorize any of those with minimal effort), so 
there's not much advantage for me as a user to using disk encryption.

Things are pretty similar at work, except the reasoning there is that we 
have good network protection, and restricted access to the server room, 
so there's no way realistically without causing significant amounts of 
damage elsewhere that the data could be stolen (although we're in a 
small enough industry that the only people likely to want to steal our 
data is our competitors, and they don't have the funding to pull off 
industrial espionage).

Now, as far as RAID, I don't entirely agree about it just improving 
up-time.  That's one of the big advantages, but it's not the only one. 
Having a system that will survive a disk failure and keep working is 
good for other reasons too:
1. It makes it less immediately critical that things be dealt with (for 
example, if a disk fails in the middle of the night, you can often wait 
until the next morning to deal with it).
2. When done right with a system that supports hot-swap properly (all 
server systems these days should), it allows for much simpler and much 
safer storage device upgrades.
3. It makes it easier (when done with BTRFS or LVM) to re-provision 
storage space without having to take the system off-line.
I could have almost any of the Linux servers at work back up and running 
correctly from a backup in about 15 minutes, but I still have them set 
up with RAID-1 because it lets me do things like install bigger storage 
devices with minimal chance of data loss.  As for my personal systems, 
my home server is set up with RAID in such a way that I can lose 3 of 
the 4 hard drives and 1 of the 2 SSD's and still not need to restore 
from backup (and still have a working system).
