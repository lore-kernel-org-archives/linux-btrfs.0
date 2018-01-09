Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35336 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754010AbeAIMqw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 07:46:52 -0500
Received: by mail-it0-f45.google.com with SMTP id f143so11786153itb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 04:46:52 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Marat Khalili <mkh@rqc.ru>, Martin Raiber <martin@urbackup.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
 <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
Date: Tue, 9 Jan 2018 07:46:48 -0500
MIME-Version: 1.0
In-Reply-To: <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-09 03:33, Marat Khalili wrote:
> On 08/01/18 19:34, Austin S. Hemmelgarn wrote:
>> A: While not strictly necessary, running regular filtered balances 
>> (for example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 
>> -mlimit=4`, see `man btrfs-balance` for more info on what the options 
>> mean) can help keep a volume healthy by mitigating the things that 
>> typically cause ENOSPC errors. 
> 
> The choice of words is not very fortunate IMO. In my view volume 
> stopping being "healthy" during normal operation presumes some bugs (at 
> least shortcomings) in the filesystem code. In this case I'd prefer to 
> have detailed understanding of the situation before copy-pasting 
> commands from wiki pages. Remember, most users don't run cutting-edge 
> kernels and tools, preferring LTS distribution releases instead, so one 
> size might not fit all.
I will not dispute that the tendency of BTRFS to end up in bad 
situations is a shortcoming of the filesystem code.  However, that isn't 
likely to change any time soon (fixing it is going to be a lot of work 
that will likely reduce performance for quite a few people), so there is 
absolutely no reason that people should not be trying to mitigate the 
problem.

As far as the exact command, the one I quoted has worked for at least 2 
years worth of btrfs-progs and kernels, and I think far longer than that 
(the usage and limit filters were implemented pretty early on).  I agree 
that detailed knowledge would be better, but that doesn't exactly fit 
with the concept of a FAQ in most cases, and most people really don't 
care about the details as long as it works.
> 
> On 08/01/18 23:29, Martin Raiber wrote:
>> There have been reports of (rare) corruption caused by balance (won't be
>> detected by a scrub) here on the mailing list. So I would stay a away
>> from btrfs balance unless it is absolutely needed (ENOSPC), and while it
>> is run I would try not to do anything else wrt. to writes simultaneously.
> 
> This is my opinion too as a normal user, based upon reading this list 
> and own attempts to recover from ENOSPC. I'd rather re-create filesystem 
> from scratch, or at least make full verified backup before attempting to 
> fix problems with balance.
While I'm generally of the same opinion (and I have a feeling most other 
people who have been server admins are too), it's not a very user 
friendly position to recommend that.  Keep in mind that many (probably 
most) users don't keep proper backups, and just targeting 'sensible' 
people as your primary audience is a bad idea.  It also needs to work at 
at least a basic level anyway though simply because you can't always 
just nuke the volume and rebuild it from scratch.

Personally though, I don't think I've ever seen issues with balance 
corrupting data, and I don't recall seeing complaints about it either 
(though I would love to see some links that prove me wrong).
