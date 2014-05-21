Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45005 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaEUCv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 22:51:28 -0400
From: Russell Coker <russell@coker.com.au>
To: ashford@whisperpc.com
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
Date: Wed, 21 May 2014 12:51:23 +1000
Message-ID: <1795587.Ol58oREtZ7@xev>
In-Reply-To: <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net>
References: <2308735.51F3c4eZQ7@xev> <4483661.BdmCOR8JR5@xev> <57f050e2a37907d810b40c5e115b28ff.squirrel@webmail.wanet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 20 May 2014 07:56:41 ashford@whisperpc.com wrote:
> 1.  There will be more disk space used by the metadata.  I've been aware
> of space allocation issues in BTRFS for more than three years.  If the use
> of ditto blocks will make this issue worse, then it's probably not a good
> idea to implement it.  The actual increase in metadata space is probably
> small in most circumstances.

Data, RAID1: total=2.51TB, used=2.50TB
System, RAID1: total=32.00MB, used=376.00KB
Metadata, RAID1: total=28.25GB, used=26.63GB

The above is my home RAID-1 array.  It includes multiple backup copies of a 
medium size Maildir format mail spool which probably accounts for a 
significant portion of the used space, the Maildir spool has an average file 
size of about 70K and lots of hard links between different versions of the 
backup.  Even so the metadata is only 1% of the total used space.  Going from 
1% to 2% to improve reliability really isn't a problem.

Data, RAID1: total=140.00GB, used=139.60GB
System, RAID1: total=32.00MB, used=28.00KB
Metadata, RAID1: total=4.00GB, used=2.97GB

Above is a small Xen server which uses snapshots to backup the files for Xen 
block devices (the system is lightly loaded so I don't use nocow) and for data 
files that include a small Maildir spool.  It's still only 2% of disk space 
used for metadata, again going from 2% to 4% isn't going to be a great 
problem.

> 2.  Use of ditto blocks will increase write bandwidth to the disk.  This
> is a direct and unavoidable result of having more copies of the metadata.
> The actual impact of this would depend on the file-system usage pattern,
> but would probably be unnoticeable in most circumstances.  Does anyone
> have a “worst-case” scenario for testing?

The ZFS design involves ditto blocks being spaced apart due to the fact that 
corruption tends to have some spacial locality.  So you are adding an extra 
seek.

The worst case would be when you have lots of small synchronous writes, 
probably the default configuration of Maildir delivery would be a good case.

As an aside I've been thinking of patching a mail server to do a sleep() 
before fsync() on mail delivery to see if that improves aggregate performance.  
My theory is that if you have dozens of concurrent delivery attempts then if 
they all sleep() before fsync() then the filesystem could write out metadata 
for multiple files in one pass in the most efficient manner.

> 3.  Certain kinds of disk errors would be easier to recover from.  Some
> people here claim that those specific errors are rare.

All errors are rare.  :-#

Seriously you can run Ext4 on a single disk for years and probably not lose 
data.  It's just a matter of how many disks and how much reliability you want.

> I have no opinion
> on how often they happen, but I believe that if the overall disk space
> cost is low, it will have a reasonable return.  There would be virtually
> no reliability gains on an SSD-based file-system, as the ditto blocks
> would be written at the same time, and the SSD would be likely to map the
> logical blocks into the same page of flash memory.

That claim is unproven AFAIK.  On SSD the performance cost of such things is 
negligible (no seek cost) and losing 1% of disk space isn't a problem for most 
systems (admittedly the early SSDs were small).

> 4.  If the BIO layer of BTRFS and the device driver are smart enough,
> ditto blocks could reduce I/O wait time.  This is a direct result of
> having more instances of the data on the disk, so it's likely that there
> will be a ditto block closer to where the disk head is currently.  The
> actual benefit for disk-based file-systems is likely to be under 1ms per
> metadata seek.  It's possible that a short-term backlog on one disk could
> cause BTRFS to use a ditto block on another disk, which could deliver
> >20ms of performance.  There would be no performance benefit for SSD-based
> file-systems.

That is likely with RAID-5 and RAID-10.

> My experience is that once your disks are larger than about 500-750GB,
> RAID-6 becomes a much better choice, due to the increased chances of
> having an uncorrectable read error during a reconstruct.  My opinion is
> that anyone storing critical information in RAID-5, or even 2-disk RAID-1,
> with disks of this capacity, should either reconsider their storage
> topology, or verify that they have a good backup/restore mechanism in
> place for that data.

http://research.cs.wisc.edu/adsl/Publications/corruption-fast08.html

The NetApp research shows that the incidence of silent corruption is a lot 
greater than you would expect.  RAID-6 doesn't save you from this.  You need 
BTRFS or ZFS RAID-6.


On Tue, 20 May 2014 22:11:16 Brendan Hide wrote:
> Extra replication on leaf nodes will make relatively little difference 
> in the scenarios laid out in this thread - but on "trunk" nodes (folders 
> or subvolumes closer to the filesystem root) it makes a significant 
> difference. "Plain" N-way replication doesn't flexibly treat these two 
> nodes differently.
> 
> As an example, Russell might have a server with two disks - yet he wants 
> 6 copies of all metadata for subvolumes and their immediate subfolders. 
> At three folders deep he "only" wants to have 4 copies. At six folders 
> deep, only 2. Ditto blocks add an attractive safety net without 
> unnecessarily doubling or tripling the size of *all* metadata.

Firstly I don't think that doubling all metadata is a real problem.

Next the amount of duplicate metadata can't be determined by depth.  For 
example I have a mail server where an outage of the entire server is 
preferable to losing email.  I would set more ditto blocks for /mail than for 
the root subvol.  In that case I'd want the metadata for the root directory to 
have the same replication as /mail but for /home etc nothing special.

Hypothetically if metadata duplication consumed any significant disk space 
then I'd probably want to only enable it on /lib* /sbin, /etc, and whatever 
data the server is designed to hold.  But really it's small enough to just 
duplicate everything.

Currently I only run two systems for which I can't more than double the disk 
space at a moderate cost.  One is my EeePC 701 and the other is a ZFS archive 
server (which already has the ditto blocks).  For all the other systems there 
is no shortage of space at all.  Disk just keeps getting bigger and cheaper, 
for most of my uses disk size increases faster than data storage.

Currently the smallest SATA disk I can buy new is 500G.  The smallest SSD is 
60G for $63 but I can get 120G for $82, 240G for $149, or 480G for $295.  All 
the workstations I run use a lot less than 120G of storage.  Storage capacity 
isn't an issue for most users.

It seems to me that the only time when an extra 1% disk space usage would 
really matter is when you have an array of 100 disks that's almost full.  But 
that's the time when you REALLY want extra duplication of metadata.

> It is a good idea. The next question to me is whether or not it is 
> something that can be implemented elegantly and whether or not a 
> talented *dev* thinks it is a good idea.

Absolutely.  Hopefully this discussion will inspire the developers to consider 
this an interesting technical challenge and a feature that is needed to beat 
ZFS.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

