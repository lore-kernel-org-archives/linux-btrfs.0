Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:38396 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcCZU6j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 16:58:39 -0400
Received: by mail-ig0-f182.google.com with SMTP id ig19so33061468igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 13:58:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459000838.655295.560259050.32AD1D24@webmail.messagingengine.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
	<CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
	<1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
	<CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
	<CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
	<56F5FD42.5010701@oracle.com>
	<CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
	<1459000838.655295.560259050.32AD1D24@webmail.messagingengine.com>
Date: Sat, 26 Mar 2016 14:58:38 -0600
Message-ID: <CAJCQCtRhbMOV=i+Po9x7QAwVbNiPkCzxq+FU6oH-LRdaaFqATg@mail.gmail.com>
Subject: Re: Possible Raid Bug
From: Chris Murphy <lists@colorremedies.com>
To: Stephen Williams <stephenw@veryfast.biz>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 8:00 AM, Stephen Williams <stephenw@veryfast.biz> wrote:

> I know this is quite a rare occurrence for home use but for Data center
> use this is something that will happen A LOT.
> This really should be placed in the wiki while we wait for a fix. I can
> see a lot of sys admins crying over this.

Maybe on the gotchas page? While it's not a data loss bug, it might be
viewed as an uptime bug because the dataset is stuck being ro and
hence unmodifiable, until a restore to a rw volume is complete.

Since we can ro mount a volume, some way to safely make it a seed
device could be useful. All that's needed to make it rw is adding even
a small USB stick for example, and now at least ro snapshots can be
taken and migrate data off the volume. A larger device that's used for
rw would allow this raid to be brought back online. And then once the
new array is up and has most data restored, a short downtime to get
the latest incremental changes sent over.

Yeah, the alternative to this is a cluster, and you just consider this
one brick a loss and move on. But most regular users don't do
clusters, even with big (for them) storage.


-- 
Chris Murphy
