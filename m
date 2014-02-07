Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54835 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaBGW04 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 17:26:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBtst-0000c4-8v
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 23:26:55 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 23:26:55 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 23:26:55 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Fri, 07 Feb 2014 23:26:34 +0100
Message-ID: <r53gsa-d85.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com> <6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com> <qhufsa-27u.ln1@hurikhan77.spdns.de> <D3E4553E-C9D8-4D94-A124-506961946360@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

> 
> On Feb 7, 2014, at 2:07 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> 
>> Chris Murphy <lists@colorremedies.com> schrieb:
>> 
>>>> If the database/virtual machine/whatever is crash safe, then the
>>>> atomic state that a snapshot grabs will be useful.
>>> 
>>> How fast is this state fixed on disk from the time of the snapshot
>>> command? Loosely speaking. I'm curious if this is < 1 second; a few
>>> seconds; or possibly up to the 30 second default commit interval? And
>>> also if it's even related to the commit interval time at all?
>> 
>> Such constructs can only be crash-safe if write-barriers are passed down
>> through the cow logic of btrfs to the storage layer. That won't probably
>> ever happen. Atomic and transactional updates cannot happen without
>> write- barriers or synchronous writes. To make it work, you need to
>> design the storage-layers from the ground up to work without
>> write-barriers, like having battery-backed write-caches, synchronous
>> logical file-system layers etc. Otherwise, database/vm/whatever
>> transactional/atomic writes are just having undefined status down at the
>> lowest storage layer.
> 
> This explanation makes sense. But I failed to qualify the "state fixed on
> disk". I'm not concerned about when bits actually arrive on disk. I'm
> wondering what state they describe. So assume no crash or power failure,
> and assume writes eventually make it onto the media without a problem.
> What I'm wondering is, what state of the subvolume I'm snapshotting do I
> end up with? Is there a delay and how long is it, or is it pretty much
> instant? The command completes really quickly even when the file system is
> actively being used, so the feedback is that the snapshot state is
> established very fast but I'm not sure what bearing that has in reality.

I think from that perspective it is more or less the same taking a snapshot 
or cycling the power. For the state of the file consistency it means the 
same, I suppose. I got your argument about "state fixed on disk", but I 
implied from perspective of the writing process it is just the same 
situation: in the moment of the snapshot the data file is in a crashed 
state. That is like cycling the power without having a mechanism to support 
transactional guarantees.

So the question is: Do btrfs snapshots give the same guarantees on the 
filesystem level that write-barriers give on the storage level which exactly 
those processes rely upon? The cleanest solution would be if processes could 
give btrfs hints about what belongs to their transactions so in the moment 
of a snapshot the data file would be in clean state. I guess snapshots are 
atomic in that way, that pending writes will never reach the snapshots just 
taken, which is good.

But what about the ordering of writes? Maybe some younger write requests 
already made it to the disk, while older ones didn't. The file system 
usually only has to care about its own transactional integrity, not those of 
its writing processes, and that is completely unrelated to what the writing 
process expects. Or in other words: A following crash only guarantees that 
the active subvolume being written to is clean from the transactional 
perspective of the process, but the snapshot may be broken. As far as I 
know, user processes cannot tell the filesystem when to issue write-
barriers, it could only issue fsyncs (which hurts performance). Otherwise 
this discussion would be a whole different story.

Did you test how btrfs snapshots perform while running fsync with a lot of 
data to be committed? Could give a clue...

-- 
Replies to list only preferred.

