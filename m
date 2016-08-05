Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42051 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcHEK4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 06:56:19 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bVcnW-0005EG-80
	for linux-btrfs@vger.kernel.org; Fri, 05 Aug 2016 12:56:14 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the "usual"
 problem
Date: Fri, 05 Aug 2016 12:56:07 +0200
Message-ID: <57A470C7.2080304@5t9.de>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com> <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com> <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com> <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com> <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com> <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com> <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com> <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com> <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com> <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com> <57A372F3.5090400@5t9.de> <CAJCQCtSFcJd+ac+Awfwuzdhuf8xjf8EgMQNwq_aV3udaZmZ=5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <CAJCQCtSFcJd+ac+Awfwuzdhuf8xjf8EgMQNwq_aV3udaZmZ=5A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/04/2016 10:30 PM, Chris Murphy wrote:
> Keep in mind the list is rather self-selecting for problems. People
> who aren't having problems are unlikely to post their non-problems to
> the list.

True, but the number of people inclined to post a bug report to
the list is also a lot smaller than the number of people who
experienced problems.

Personally, I know at least 2 Linux users who happened to
get a btrfs filesystem as part of upgrading to a newer Suse
distribution on their PC, and both of them experienced
trouble with their filesystems that caused them to re-install
without using btrfs. They weren't interested in what filesystem
they use enough to bother investigating what happened
in detail or to issue bug-reports.

I'm afraid that btrfs' reputation has already taken damage
from the combination of "early deployment as a root filesystem
to unsuspecting users" and "being at a development stage where
users are likely to experience trouble at some time".

> c. Take some risk and use 4.8 rc1 once it's out. Just make sure to
> keep backups.

We sure do - actually, the possibility to "run daily backups from a
snapshot while write performance remains acceptable" is the one and
only reason for me to use btrfs rather than xfs for those $HOME dirs.
In every other aspect (stability, performance, suitability for
storing VM-images or database-files) xfs wins for me.
And the btrfs advantage "file system based snapshot being more
performant than block device based snapshot" may fade away
with the replacement of magnetic disks with SSDs in the long run.


Regards,

Lutz Vieweg

