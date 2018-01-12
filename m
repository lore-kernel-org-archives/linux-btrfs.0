Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:44672 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964862AbeALSYn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 13:24:43 -0500
Received: by mail-io0-f169.google.com with SMTP id k18so6778571ioc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 10:24:42 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 6sm12623238iow.55.2018.01.12.10.24.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jan 2018 10:24:40 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
Message-ID: <c4908bdb-cd9c-929d-e681-16311b6adbc5@gmail.com>
Date: Fri, 12 Jan 2018 13:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-08 10:55, Austin S. Hemmelgarn wrote:
> So, for a while now I've been recommending small filtered balances to 
> people as part of regular maintenance for BTRFS filesystems under the 
> logic that it does help in some cases and can't really hurt (and if done 
> right, is really inexpensive in terms of resources).  This ended up 
> integrated partially in the info text next to the BTRFS charts on 
> netdata's dashboard, and someone has now pointed out (correctly I might 
> add) that this is at odds with the BTRFS FAQ entry on balances.
> 
> For reference, here's the bit about it in netdata:
> 
> You can keep your volume healthy by running the `btrfs balance` command 
> on it regularly (check `man btrfs-balance` for more info).
> 
> 
> And here's the FAQ entry:
> 
> Q: Do I need to run a balance regularly?
> 
> A: In general usage, no. A full unfiltered balance typically takes a 
> long time, and will rewrite huge amounts of data unnecessarily. You may 
> wish to run a balance on metadata only (see Balance_Filters) if you find 
> you have very large amounts of metadata space allocated but unused, but 
> this should be a last resort.
> 
> 
> I've commented in the issue in netdata's issue tracker that I feel that 
> the FAQ entry could be better worded (strictly speaking, you don't 
> _need_ to run balances regularly, but it's usually a good idea). Looking 
> at both though, I think they could probably both be improved, but I 
> would like to get some input here on what people actually think the best 
> current practices are regarding this (and ideally why they feel that 
> way) before I go and change anything.
> 
> So, on that note, how does anybody else out there feel about this?  Is 
> balancing regularly with filters restricting things to small numbers of 
> mostly empty chunks a good thing for regular maintenance or not?
OK, I've gotten a lot of good feedback on this, and the general 
consensus seems to be:

* If we're going to recommend regular balance, we should explain how it 
actually helps things.
* We should mention the performance interactions with qgroups, as well 
as warning people off of running other things like scrubs or defrag 
concurrently.
* The filters should be reasonably tame in terms of chunk selection.
* BTRFS should ideally get smarter about this kind of thing so the user 
doesn't have to be.

To that end, I propose the following text for the FAQ:

Q: Do I need to run a balance regularly?

A: While not strictly necessary for normal operations, running a 
filtered balance regularly can help prevent your filesystem from ending 
up with ENOSPC issues.  The following command run daily on each BTRFS 
volume should be more than sufficient for most users:

`btrfs balance start -dusage=25 -dlimit=2..10 -musage=25 -mlimit=2..10`

If you are running a kernel older than version 4.4 and can't upgrade, 
the following should be used instead:

`btrfs balance start -dusage=25 -musage=25`

Both of these commands will effectively compact partially full chunks on 
the filesystem so that new chunks have more space to be allocated.  For 
more information on what the commands actually mean, check out `man 
btrfs-balance`

When run regularly, both of these should complete extremely fast on most 
BTRFS volumes.  Note that these may run significantly slower on volumes 
which have quotas enabled.  Additionally, it's best to make sure other 
things aren't putting a lot of load on the filesystem while running a 
balance, so try to make sure this doesn't run at the same time as a 
scrub or defrag.

A full, unfiltered balance (one without any options passed in) is 
completely unnecessary for normal usage of a filesystem.
