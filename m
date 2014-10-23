Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:48615 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbaJWFSQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 01:18:16 -0400
Message-ID: <54488F91.6070109@pobox.com>
Date: Wed, 22 Oct 2014 22:18:09 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com> <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net> <20141022200812.GA17395@hungrycats.org> <01D3E7DE-5420-4C97-98C4-BB0414C4972E@colorremedies.com>
In-Reply-To: <01D3E7DE-5420-4C97-98C4-BB0414C4972E@colorremedies.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2014 09:30 PM, Chris Murphy wrote:
> Sure. So if Btrfs is meant to address scalability, then perhaps at the moment it's falling short. As it's easy to add large drives and get very large multiple device volumes, the snapshotting needs to scale also.
>
> I'd say per user, it's reasonable to have 24 hourly (one snapshot per hour for a day), 7 daily, 4 weekly, and 12 monthly snapshots, or 47 snapshots. That's 47,000 snapshots if it's sane for a single Btrfs volume to host 1000 users. Arguably, such a system is better off with a distributed fs: Gluster FS or GFS2 or Ceph.

Is one subvolume per user a rational expectation? Is it even 
particularly smart? Dooable, sure, but as a best practice it doesn't 
seem that useful because it multiplies the maintenace by the user base.

Presuming a linux standard base layout (which is very presumptive) 
having the 47 snapshots of /home instead of the 47,000 snapshots of 
/home/X(1000) is just as workable, if not moreso. A reflink recursive 
copy of /home/X(n) from /home_Backup_date/X(n) is only trivially longer 
than resnapshotting the individual user.

Again this gets into the question not of what exercises well to create 
the snapshot but what functions well during a restore.

People constantly create "backup solutions" without really looking at 
the restore path.

I can't get anybody here to answer the question about "btrfs fi li -s /" 
and setting/resetting the "snapshot" status of a subvolume. I've been 
told "snapshots are subvolumes" which is fine, but since there _is_ a 
classification mechanism things get all caca if you rely on the "-s" in 
your scripting and then promote a snapshot back into prime activity. 
(seriously compare the listing with and without -s, note its natural 
affinity for classifying subvolumes, then imagine the horror of needing 
to take /home_backup_date and make it /home.)

Similar problems obtain as soon as you consider the daunting task of 
shuffling through 47,000 snapshots instead of just 47.

And if you setup each user on their own snapshot what happens the first 
time two users want to hard-link a file betwixt them?

Excessive segmentation of storage is an evil unto itself.

YMMV, of course.

An orthoginal example:

If you give someone six disks and tell them to make an encrypted raid6 
via cryptsetup and mdadm, at least eight out of ten will encrypt the 
drives and then raid the result. But it's _massivly_ more efficent to 
raid the drives and then encrypt the result. Why? Because writing a 
block with the latter involves only one block being encrypted/decrypted. 
The former, if the raid is fine involves several encryptions/decryptions 
and _many_ if the raid is degraded.

The above is a mental constraint, a mistake, that is all to common 
because people expect encrytion to be "better" the closer you get to the 
spinning rust.

So too people expect that segmentation is somehow better if it most 
closely matches the abstract groupings (like per user) but in practical 
terms it is better matched to the modality, where, for instance, all 
users are one kind of thing, while all data stores are another kind of 
thing.

We were just talking about putting all your VMs and larger NOCOW files 
into a separate subvolume/domain because of their radically different 
write behaviors. Thats a sterling reason to subdivide the storage. So is 
/ vs. /var vs. /home as three different domains with radically different 
update profiles.

So while the natural impulse is to give each user its own subvolume it's 
not likely to be that great an idea in practice because... um... 47,000 
snapshots dude, and so on.
