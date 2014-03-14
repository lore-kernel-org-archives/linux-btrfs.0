Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from locke.effortlessis.com ([208.53.66.14]:34065 "EHLO
	locke.effortlessis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbaCNBOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 21:14:12 -0400
Received: from tesla.schoolpathways.com (c-50-173-32-49.hsd1.ca.comcast.net [50.173.32.49])
	by locke.effortlessis.com (Postfix) with ESMTPSA id CAF3144AA4
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 01:14:08 +0000 (UTC)
Message-ID: <532257E0.9040104@benjamindsmith.com>
Date: Thu, 13 Mar 2014 18:14:08 -0700
From: Lists <lists@benjamindsmith.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia> <5491122.Fap633Kp83@fuchsia> <0AD708D8-5380-465E-8119-DD6FDD1BF1BA@colorremedies.com> <2106363.nA97oxn4hn@fuchsia> <53224D57.8020308@chinilu.com>
In-Reply-To: <53224D57.8020308@chinilu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See comments at the bottom:

On 03/13/2014 05:29 PM, George Mitchell wrote:
> On 03/13/2014 04:03 PM, Michael Schuerig wrote:
>> On Thursday 13 March 2014 16:04:33 Chris Murphy wrote:
>>> On Mar 13, 2014, at 3:14 PM, Michael Schuerig
>> <michael.lists@schuerig.de> wrote:
>>>> On Thursday 13 March 2014 14:48:55 Andrew Skretvedt wrote:
>>>>> On 2014-Mar-13 14:28, Hugo Mills wrote:
>>>>>> On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
>>>>>>> My backup use case is different from the what has been recently
>>>>>>> discussed in another thread. I'm trying to guard against hardware
>>>>>>> failure and other causes of destruction.
>>>>>>>
>>>>>>> I have a btrfs raid1 filesystem spread over two disks. I want to
>>>>>>> backup this filesystem regularly and efficiently to an external
>>>>>>> disk (same model as the ones in the raid) in such a way that
>>>>>>>
>>>>>>> * when one disk in the raid fails, I can substitute the backup
>>>>>>> and
>>>>>>> rebalancing from the surviving disk to the substitute only
>>>>>>> applies
>>>>>>> the missing changes.
>>>>>>>
>>>>>>> * when the entire raid fails, I can re-build a new one from the
>>>>>>> backup.
>>>>>>>
>>>>>>> The filesystem is mounted at its root and has several nested
>>>>>>> subvolumes and snapshots (in a .snapshots subdir on each subvol).
>>>> [...]
>>>>
>>>>> I'm new; btrfs noob; completely unqualified to write intelligently
>>>>> on
>>>>> this topic, nevertheless:
>>>>> I understand your setup to be btrfs RAID1 with /dev/A /dev/B, and a
>>>>> backup device someplace /dev/C
>>>>>
>>>>> Could you, at the time you wanted to backup the filesystem:
>>>>> 1) in the filesystem, break RAID1: /dev/A /dev/B <-- remove /dev/B
>>>>> 2) reestablish RAID1 to the backup device: /dev/A /dev/C <-- added
>>>>> 3) balance to effect the backup (i.e. rebuilding the RAID1 onto
>>>>> /dev/C) 4) break/reconnect the original devices: remove /dev/C;
>>>>> re-add /dev/B to the fs
>>>> I've thought of this but don't dare try it without approval from the
>>>> experts. At any rate, for being practical, this approach hinges on
>>>> an
>>>> ability to rebuild the raid1 incrementally. That is, the rebuild
>>>> would have to start from what already is present on disk B (or C,
>>>> when it is re-added). Starting from an effectively blank disk each
>>>> time would be prohibitive.
>>>>
>>>> Even if this would work, I'd much prefer keeping the original raid1
>>>> intact and to only temporarily add another mirror: "lazy mirroring",
>>>> to give the thing a name.
>> [...]
>>> In the btfs device add case, you now have a three disk raid1 which is
>>> a whole different beast. Since this isn't n-way raid1, each disk is
>>> not stand alone. You're only assured data survives a one disk failure
>>> meaning you must have two drives.
>> Yes, I understand that. Unless someone convinces me that it's a bad
>> idea, I keep wishing for a feature that allows to intermittently add a
>> third disk to a two disk raid1 and update that disk so that it could
>> replace one of the others.
>>
>>> So the btrfs replace scenario might work but it seems like a bad idea.
>>> And overall it's a use case for which send/receive was designed
>>> anyway so why not just use that?
>> Because it's not "just". Doing it right doesn't seem trivial. For one
>> thing, there are multiple subvolumes; not at the top-level but nested
>> inside a root subvolume. Each of them already has snapshots of its own.
>> If there already is a send/receive script that can handle such a setup
>> I'll happily have a look at it.
>>
>> Michael
>>
> I think the closest thing there will ever be to this is n-way 
> mirroring.  I currently use rsync to a separate drive to maintain a 
> backup copy, but it is not integrated into the array like n-way would 
> be, and is definitely not a perfect solution.  But a 3 drive 3-way 
> would require the 3rd drive to be in the array the whole time or it 
> would run into the same problem requiring a complete rebuild rather 
> than an incremental when reintroduced, UNLESS such a feature was 
> specifically included in the design, and even then, in a 3-way 
> configuration, you would end up simplex on at least some data until 
> the partial rebuild was completed.  Personally, I will be DELIGHTED 
> when n-way appears simply because basic 3-way gets us out of the 
> dreaded simplex trap.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I'm coming from ZFS land, am a BTRFS newbie, and I don't understand this 
discussion, at all. I'm assuming that BTRFS send/receive works similar 
to ZFS's similarly named feature. We use snapshots and ZFS send/receive 
to a remote server to do our backups. To do an rsync of our production 
file store takes days because there are so many files, while 
snapshotting and using ZFS send/receive takes tens of minutes at local 
(Gbit) speeds, and a few hours at WAN speeds, nearly all of that time 
being transfer time.

So just I don't get the "backup" problem. Place btrfs' equivalent of a 
pool on the external drive, and use send/receive of the filesystem or 
snapshot(s). Does BTRFS work so differently in this regard? If so, I'd 
like to know what's different.

My primary interest in BTRFS vs ZFS is two-fold:

1) ZFS has a couple of limitations that I find disappointing, that don't 
appear to be present in BTRFS.
     A) Inability to upgrade a non-redundant ZFS pool/vdev to raidz or 
increase the raidz (redundancy) level after creation. (Yes, you can plan 
around this, but I see no good reason to HAVE to)
     B) Inability to remove a vdev once added to a pool.

2) Licensing: ZFS on Linux is truly great so far in all my testing, 
can't throw enough compliments their way, but I would really like to 
rely on a "first class citizen" as far as the Linux kernel is concerned.

-Ben
