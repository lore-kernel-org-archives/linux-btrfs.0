Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:53070 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751812AbeAJQbK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 11:31:10 -0500
Received: from smtp25.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp25.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id DBBE325524
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 11:31:09 -0500 (EST)
Received: by smtp25.relay.iad3a.emailsrvr.com (Authenticated sender: fsb-AT-thefsb.org) with ESMTPSA id C2CF42552D
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 11:31:09 -0500 (EST)
From: "Tom Worster" <fsb@thefsb.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Wed, 10 Jan 2018 11:30:58 -0500
Message-ID: <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
In-Reply-To: <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
 <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
 <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
 <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9 Jan 2018, at 22:49, Duncan wrote:

> AFAIK, such corruption reports re balance aren't really balance, per 
> se,
> at all.
>
> Instead, what I've seen in nearly all cases is a number of filesystem
> maintenance commands involving heavy I/O colliding, that is, being run 
> at
> the same time

I hope there is consensus on this because it might be the key to 
resolving the contradictions that appear to me in the following 
propositions that all seem plausible/reasonable:

- Depletion of unallocated space (DoUS, apologies for coining the term 
if there already is one) is a property of BTRFS even if the volume's 
capacity is more than enough for the files on it.

- To a user that isn't a BTRFS expert, DoUS can be unexpected, its 
advance can be surprisingly fast and it can become severe.

- BTRFS does not recycle allocated but unused space to the unallocated 
pool.

- Resolving severe DoUS involves either running `btrfs balance` or 
recreating the filesystem from, e.g. backups.

- People have reported that `btrfs balance` sometimes causes filesystem 
corruption.

- Some experienced users say that, to resolve a problem with DoUS, they 
would rather recreate the filesystem than run balance.

- Some experienced users say you should stop all other use of the 
filesystem while running balance.

- Some experts recommend running balance regularly, even once a day, to 
prevent DoUS.

Without some satisfactory way to resolve the contradictions, I'm not 
sure how to proceed. For example, I'm not willing to offload the 
workload from each filesystem once a day for prophylactic balance. And 
I'm not going to let balance run unattended if those more experienced 
than me say it's known to corrupt filesystems. The best I can do is 
monitor DoUS and respond ad hoc. Or I can use a different fs type.

But if Duncan is right (which, for me, is practically the same as 
consensus on the proposition) that problems with corruption while 
running balance are associated with heavy coincident IO activity, then I 
can see a reasonable way forwards. I can even see how general 
recommendations for BTRFS maintenance might develop.

Tom
