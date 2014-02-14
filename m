Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36842 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBNAju (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 19:39:50 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE6om-0003Fp-Pq
	for linux-btrfs@vger.kernel.org; Fri, 14 Feb 2014 01:39:48 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:39:48 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 01:39:48 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to wait for snapshot deletion?
Date: Fri, 14 Feb 2014 01:25:57 +0100
Message-ID: <ld40ta-gl3.ln1@hurikhan77.spdns.de>
References: <jfhvsa-unf.ln1@hurikhan77.spdns.de> <52FD1D1B.7080306@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide <brendan@swiftspirit.co.za> schrieb:

>> Is it technically possible to wait for a snapshot completely purged from
>> disk? I imagine an option like "--wait" for btrfs delete subvolume.
>>
>> This would fit some purposes I'm planning to implement:
>>
>> * In a backup scenario
>
> I have a similar use-case for this also involving backups. In my case I
> have a script that uses a btrfs filesystem for the backup store using
> snapshots. At the end of each run, if diskspace usage is below a
> predefined threshold, it will delete old snapshots until the diskspace
> usage is below that threshold again.

Yeah, I thought of that approach first, too... But:

> Of course, the first time I added the automatic deletion, it deleted far
> more than was necessary due to the fact that the actual freeing of
> diskspace is asynchronous from the command completion. I ended up
> setting a small delay (of about 60 seconds) between each iteration and
> also set it to monitor system load. If load is not low enough after the
> delay then it waits another 60 seconds.

Due to btrfs' behavior that cannot reliably work as you also figured out. It 
will need quirky work-arounds totally dependent on system load.

> This complicated (frankly broken) workaround would be completely
> unnecessary with a --wait switch.

That's why I had the idea. ;-)

> Alternatively, perhaps a knob where we can see if a subvolume deletion
> is in progress could help.

Like "btrfs scrub status"...

If you're feeling curious, here's what I've implemented yet (snapshot 
deletion still on the todo list):

https://gist.github.com/kakra/5520370

My idea is to fork-off a background process which constantly removes old 
snapshots (within sane bounds yet to be defined) and then exits. Some 
mechanism has to be found to not run into a deadlock situation here. Then, 
at the end issue a bash "wait" to join the processes again and run a final 
sync. However, I don't like to issue explicit syncs from within the 
subprocess as the filesystem is busy with rsync at the same time.

PS: Yes, I know there's btrfs send/receive - but it doesn't seem ready for 
the big show yet because it still has many strange quirks and should not be 
run unattended yet.

-- 
Replies to list only preferred.

