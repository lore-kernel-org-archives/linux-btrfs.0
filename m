From: Fabian Zeindl <fabian.zeindl@gmail.com>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 14:47:02 +0100
Message-ID: <86174C7E-A954-416E-8A05-A4D58CF65BC8@gmail.com>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com> <20120105094444.GF27122@carfax.org.uk> <DFD486DD-C324-43EE-82BC-87DDCF432DB6@gmail.com> <201201051139.20334.Martin@lichtvoll.de> <82FEA956-FFE4-4A00-B895-AA381A35FEE7@gmail.com> <CABVOS0_3O8qZTEOuAvdbsCKfMJNKYS1C0dU2CL5=h5MVSWDe+A@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABVOS0_3O8qZTEOuAvdbsCKfMJNKYS1C0dU2CL5=h5MVSWDe+A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Jan 5, 2012, at 14:35 , Roman Kapusta wrote:
> you have still 4GB free of non RAID-1 (single) space, which is
> currently unavailable, but it is planned that BTRFS will support mixed
> storage:
> some files can be RAID-1, some files can be RAID-0 and rest is basic
> (single) storage

Understood. So to clarify things i think it would be good if btrfs could print out
more detailled information.

Available raw space: 10GB
	7G on drive A
	3G on drive B
Assignable space for raid1: 3GB
	 3G on drive A
	 3G on drive B

Or maybe the other way round: show which different "raid configurations" there are and how the use which space.

I understand that "free space" is a difficult concept, if you do per-file or per-chunk redundancy, but i think there are 
a lot of users out there who just want to do a "standard" replication with their whole disk.
Maybe with the special ability of the 2x500G +1TB, which mdadm, AFAIK, can't do. 

This would be just a subset of what btrfs can do, of course, but it's a frequently used subset, so maybe there could be some kind of 
saved "profile" on how the user "intends" to use the filesystem.
Output could then be clarified using that profile and it could also give warnings or prevent actions that make no sense.

fabian