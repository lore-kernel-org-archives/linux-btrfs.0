Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:42474 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757930AbeAHVvv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 16:51:51 -0500
Received: from smtp37.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp37.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 51AA7641D
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 16:43:03 -0500 (EST)
Received: by smtp37.relay.iad3a.emailsrvr.com (Authenticated sender: fsb-AT-thefsb.org) with ESMTPSA id 38CE25AB4
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 16:43:03 -0500 (EST)
From: "Tom Worster" <fsb@thefsb.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Mon, 08 Jan 2018 16:43:02 -0500
Message-ID: <C11AC11F-C4CC-41B8-BE2F-52486E42C987@thefsb.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:

> On 2018-01-08 11:20, ein wrote:
>
> > On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:
> >
> > > [...]
> > >
> > > And here's the FAQ entry:
> > >
> > > Q: Do I need to run a balance regularly?
> > >
> > > A: In general usage, no. A full unfiltered balance typically takes 
> a
> > > long time, and will rewrite huge amounts of data unnecessarily. 
> You may
> > > wish to run a balance on metadata only (see Balance_Filters) if 
> you find
> > > you have very large amounts of metadata space allocated but 
> unused, but
> > > this should be a last resort.
> >
> > IHMO three more sentencens and the answer would be more useful:
> > 1. BTRFS balance command example with note check the man first.
> > 2. What use case may cause 'large amounts of metadata space 
> allocated
> > but unused'.
>
> That's kind of what I was thinking as well, but I'm hesitant to get 
> too heavily into stuff along the lines of 'for use case X, do 1, for 
> use case Y, do 2, etc', as that tends to result in pigeonholing 
> (people just go with what sounds closest to their use case instead of 
> trying to figure out what actually is best for their use case).
>
> Ideally, I think it should be as generic as reasonably possible, 
> possibly something along the lines of:
>
> A: While not strictly necessary, running regular filtered balances 
> (for example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 
> -mlimit=4`, see `man btrfs-balance` for more info on what the options 
> mean) can help keep a volume healthy by mitigating the things that 
> typically cause ENOSPC errors. Full balances by contrast are long and 
> expensive operations, and should be done only as a last resort.

As the BTRFS noob who started the conversation on netdata's Github 
issues, I'd like to describe my experience.

I got an alert that unallocated space on a BTRFS filesystem on one host 
was low. A netdata caption suggested btrfs-balance and directed me to 
its man page. But I found it hard to understand since I don't know how 
BTRFS works or its particular terminology. The FAQ was easier to 
understand but didn't help me find a solution to my problem.

It's a 420GiB NVMe with single data and metadata. It has a MariaDB 
datadir with an OLTP workload and a small GlusterFS brick for 
replicating filesystem with little activity. I recall that unallocated 
space was under 2G, metadata allocation was low, a few G and about 1/3 
used. Data allocation was very large, almost everything else, with ~25% 
used.

Given the documentation and the usage stats, I did not know what options 
to use with balance. I spent some time reading and researching and 
trying to understand the filters and how they should relate to my 
situation. Eventually I abandoned that effort and ran balance without 
options.

While general recommendations about running balance would be welcome, 
what I needed was a dummy's guide to what the output of btrfs usage 
_means_ and how to use balance to tackle problems with it.

The other mystery is how the data allocation became so large.

Tom
