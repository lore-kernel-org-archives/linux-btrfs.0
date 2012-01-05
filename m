From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 15:40:18 +0100
Message-ID: <201201051540.18764.Martin@lichtvoll.de>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <CABVOS0_3O8qZTEOuAvdbsCKfMJNKYS1C0dU2CL5=h5MVSWDe+A@mail.gmail.com> <86174C7E-A954-416E-8A05-A4D58CF65BC8@gmail.com> (sfid-20120105_153050_134074_33A25932)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <86174C7E-A954-416E-8A05-A4D58CF65BC8@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 5. Januar 2012 schrieb Fabian Zeindl:
> On Jan 5, 2012, at 14:35 , Roman Kapusta wrote:
> > you have still 4GB free of non RAID-1 (single) space, which is
> > currently unavailable, but it is planned that BTRFS will support
> > mixed storage:
> > some files can be RAID-1, some files can be RAID-0 and rest is basic
> > (single) storage
> 
> Understood. So to clarify things i think it would be good if btrfs
> could print out more detailled information.
> 
> Available raw space: 10GB
> 	7G on drive A
> 	3G on drive B
> Assignable space for raid1: 3GB
> 	 3G on drive A
> 	 3G on drive B
> 
> Or maybe the other way round: show which different "raid
> configurations" there are and how the use which space.

As far as I see these informations can already be derived from btrfs 
filesystem df / show by combining values together. But it involves some 
manual calculations.

> I understand that "free space" is a difficult concept, if you do
> per-file or per-chunk redundancy, but i think there are a lot of users
> out there who just want to do a "standard" replication with their
> whole disk. Maybe with the special ability of the 2x500G +1TB, which
> mdadm, AFAIK, can't do.

It should be able to do that if you concatenate the two 2x500 GB via 
device mapper or the LVM layer above it.

> This would be just a subset of what btrfs can do, of course, but it's a
> frequently used subset, so maybe there could be some kind of saved
> "profile" on how the user "intends" to use the filesystem. Output
> could then be clarified using that profile and it could also give
> warnings or prevent actions that make no sense.

That makes sense to me.

As a default I would say that -d raid1 and -m raid1 just creates a RAID-1. 
And then BTRFS should put out the usable space for that RAID-1. I.e. when 
I have two 500 GB disks with 100 GB allocated it should return about 400 
GB free space. And when it uses one 1 TB disk as well as one 500 GB disk 
and two 250 GB disk with 100 GB allocated, it should return about 900GB 
free space. Only when it has one disk with 500 GB and one with 1 TB with 
100 GB allocated, it should return 400 GB free space.

IMHO this also should be what BTRFS reports to the regular df command.

This should only change if a mixed policy is in place. I do not know what 
to report to the OS then. Should it add the RAID-1 and the RAID-0 space? 
Should it only report the RAID-1 space? IMHO that depends on the 
allocation policy. If new files are enforced to be on RAID-1 space it 
should do the latter and if new files are created on RAID-0 space if RAID-1 
space is full it should report the former.

For more details, btrfs filesystem df / show still need to be used. Maybe 
with a revised and even more informative output like you suggested.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
