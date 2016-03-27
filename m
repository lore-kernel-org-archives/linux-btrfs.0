Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47664 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbcC0RGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 13:06:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id E811020BAF
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 13:06:00 -0400 (EDT)
Message-Id: <1459098360.1711683.560870250.0DACC3B5@webmail.messagingengine.com>
From: Stephen Williams <stephenw@veryfast.biz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <CAJCQCtRhbMOV=i+Po9x7QAwVbNiPkCzxq+FU6oH-LRdaaFqATg@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
 <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
 <CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
 <1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
 <CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
 <CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
 <56F5FD42.5010701@oracle.com>
 <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
 <1459000838.655295.560259050.32AD1D24@webmail.messagingengine.com>
 <CAJCQCtRhbMOV=i+Po9x7QAwVbNiPkCzxq+FU6oH-LRdaaFqATg@mail.gmail.com>
Subject: Re: Possible Raid Bug
Date: Sun, 27 Mar 2016 18:06:00 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah I think the Gotchas page would be a good place to give people a
heads up.

-- 
  Stephen Williams
  stephenw@veryfast.biz

On Sat, Mar 26, 2016, at 09:58 PM, Chris Murphy wrote:
> On Sat, Mar 26, 2016 at 8:00 AM, Stephen Williams <stephenw@veryfast.biz>
> wrote:
> 
> > I know this is quite a rare occurrence for home use but for Data center
> > use this is something that will happen A LOT.
> > This really should be placed in the wiki while we wait for a fix. I can
> > see a lot of sys admins crying over this.
> 
> Maybe on the gotchas page? While it's not a data loss bug, it might be
> viewed as an uptime bug because the dataset is stuck being ro and
> hence unmodifiable, until a restore to a rw volume is complete.
