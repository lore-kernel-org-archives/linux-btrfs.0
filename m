Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:37252 "EHLO
        smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751684AbeAIIeO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jan 2018 03:34:14 -0500
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Martin Raiber <martin@urbackup.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
From: Marat Khalili <mkh@rqc.ru>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
Date: Tue, 9 Jan 2018 11:33:36 +0300
MIME-Version: 1.0
In-Reply-To: <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/18 19:34, Austin S. Hemmelgarn wrote:
> A: While not strictly necessary, running regular filtered balances 
> (for example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 
> -mlimit=4`, see `man btrfs-balance` for more info on what the options 
> mean) can help keep a volume healthy by mitigating the things that 
> typically cause ENOSPC errors. 

The choice of words is not very fortunate IMO. In my view volume 
stopping being "healthy" during normal operation presumes some bugs (at 
least shortcomings) in the filesystem code. In this case I'd prefer to 
have detailed understanding of the situation before copy-pasting 
commands from wiki pages. Remember, most users don't run cutting-edge 
kernels and tools, preferring LTS distribution releases instead, so one 
size might not fit all.

On 08/01/18 23:29, Martin Raiber wrote:
> There have been reports of (rare) corruption caused by balance (won't be
> detected by a scrub) here on the mailing list. So I would stay a away
> from btrfs balance unless it is absolutely needed (ENOSPC), and while it
> is run I would try not to do anything else wrt. to writes simultaneously.

This is my opinion too as a normal user, based upon reading this list 
and own attempts to recover from ENOSPC. I'd rather re-create filesystem 
from scratch, or at least make full verified backup before attempting to 
fix problems with balance.

--

With Best Regards,
Marat Khalili
