Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39792 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbaBGVLT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 16:11:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBshi-0000w9-75
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 22:11:18 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 22:11:18 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 22:11:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Fri, 07 Feb 2014 22:07:38 +0100
Message-ID: <qhufsa-27u.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com> <6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

>> If the database/virtual machine/whatever is crash safe, then the
>> atomic state that a snapshot grabs will be useful.
> 
> How fast is this state fixed on disk from the time of the snapshot
> command? Loosely speaking. I'm curious if this is < 1 second; a few
> seconds; or possibly up to the 30 second default commit interval? And also
> if it's even related to the commit interval time at all?

Such constructs can only be crash-safe if write-barriers are passed down 
through the cow logic of btrfs to the storage layer. That won't probably 
ever happen. Atomic and transactional updates cannot happen without write-
barriers or synchronous writes. To make it work, you need to design the 
storage-layers from the ground up to work without write-barriers, like 
having battery-backed write-caches, synchronous logical file-system layers 
etc. Otherwise, database/vm/whatever transactional/atomic writes are just 
having undefined status down at the lowest storage layer.

> I'm also curious what happens to files that are presently writing. e.g.
> I'm writing a 1GB file to subvol A and before it completes I snapshot
> subvol A into A.1. If I go find the file I was writing to, in A.1, what's
> its state? Truncated? Or or are in-progress writes permitted to complete
> if it's a rw snapshot? Any difference in behavior if it's an ro snapshot?

I wondered that many times, too. What happens to files being written to? I 
suppose, at the time of snapshotting it's taking the current state of the 
blocks as they are, ignoring pending writes. This means, the file being 
written to is probably in limbo state.

For example, xfs has an option to freeze the file system to take atomic 
snapshots. You can use that feature to take consistent snapshots of MySQL 
InnoDB files to create a hot-copy backup of it. But: You need to instruct 
MySQL first to complete its transactions and pausing before running 
xfs_freeze, then after that's done, you can resume MySQL operations. That 
clearly tells me that it is probably not safe to take snapshots of online 
databases, even if they are crash-safe (and by what I know, InnoDB is 
designed to be crash-safe).

A solution, probably far-future, could be that a btrfs snapshot would inform 
all current file-writers to complete transactions and atomic operations and 
wait until each one signals a ready state, then take the snapshot, then 
signal the processes to resume operations. For this, the btrfs driver could 
offer some sort of subscription, similar to what inotify offers. Processes 
subscribe to some sort of notification broadcasts, btrfs can wait for every 
process to report an integral file state. If I remember right, reiser4 
offered some similar feature (approaching the problem from the opposite 
side): processes were offered an interface to start and commit transactions 
within reiser4. If btrfs had such information from file-writers, it could 
take consistent snapshots of online databases/vms/whatever (given, that in 
the vm case the guest could pass this information to the host). Whatever 
approach is taken, however, it will make the time needed to create snapshots 
undeterministic, processes may not finish their transactions within a 
reasonable time...

-- 
Replies to list only preferred.

