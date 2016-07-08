Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:42757 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbcGHUKu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 16:10:50 -0400
Subject: Re: rollback to a snapshot and delete old top volume - missing of "@"
To: Chris Murphy <lists@colorremedies.com>
References: <96f8022e-4209-2498-62e4-50ccbee46e37@freenet.de>
 <CAPmG0jZZ7FB0teBGGHojPoGctRyVC3D2cS56q1kYDMFrC=fOnA@mail.gmail.com>
 <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Kai Herlemann <nesadaw@freenet.de>
Message-ID: <0e0dcbb3-73a4-0c5f-9978-67109d505b79@freenet.de>
Date: Fri, 8 Jul 2016 22:08:19 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQt2A7w4JNUuhU7YOHTyj_z8M_RqsZCDw0G2YEENXaBvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 07.07.2016 um 19:40 schrieb Chris Murphy:
> And very clearly from the OP's output from 'btrfs sub list' there are
> no subvolumes with @ in the path, so there is no subvolume @, nor are
> there any subvolumes contained in a directory @.
>
> [...]
>
> Anyway the reason why the command fails is stated in the error
> message. The system appears to be installed in the top level of the
> file system (subvolid=5), and that can't be deleted. First it's the
> immutable first subvolume of a Btrfs file system, and second it's
> populated with other subvolumes which would inhibit its removal even
> if it weren't the top level subvolume.
>
> What can be done is delete the directories in the top level, retaining
> the subvolumes that are there.
Thank you, that was it: there was really no subvolume named @ existing. 
Thank you to Henk and Andrei, too.
I didn't believed that, although there was no @ from ot the output of 
"btrfs sub list", because all websites that dealt with this topic and 
which I used for research statet that a subvolume named @ would 
automatically be created (or I misunderstood the sites), and secondly, 
because the ID of the top level volume is in my case 5, and I 
(mis)understand, in cases where's the subvolume "@" automatically 
created, the ID of that subvolume would be also 5.
I created now myself a subvolume "@" on the top level volume, moved then 
all the data from the snapshot, which I used the last days, to the new 
subvolume, and deleted then all data from the top level volume, except 
the sub level volume @ of course, and made previously a backup snapshot 
from the top level volume. Other users who reading later here and want 
to move their data from top level volume should able to do the same.

If here any developers read along: I'd like to suggest that there's 
automatically made a subvolume "@" by default, which is set as default 
subvolume, or a tip to the distribution, that it would made sense to do 
that with the installation. It would protect other users against 
confusion and work like I had it.

Thank you,
Kai
