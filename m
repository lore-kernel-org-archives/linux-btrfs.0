Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:53387 "EHLO
        smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751504AbeAJSdV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 13:33:21 -0500
From: "Tom Worster" <fsb@thefsb.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recommendations for balancing as part of regular maintenance?
Date: Wed, 10 Jan 2018 13:33:18 -0500
Message-ID: <3B79EE2F-030E-4B2D-9A1A-8E70D965E6CB@thefsb.org>
In-Reply-To: <3e353e79-3a13-d2cf-e098-6074a3e17918@gmail.com>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
 <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
 <3eae37f6-3776-15c9-84ae-568e56abfa7e@rqc.ru>
 <13b5063c-a7bd-5c95-1f6e-16124d385569@gmail.com>
 <pan$5d0d3$29334af9$ed04365a$f8d9747d@cox.net>
 <BE09A377-4702-4D51-ACB9-44950865D26E@thefsb.org>
 <3e353e79-3a13-d2cf-e098-6074a3e17918@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 Jan 2018, at 12:01, Austin S. Hemmelgarn wrote:

> On 2018-01-10 11:30, Tom Worster wrote:
>
> Also, for future reference, the term we typically use is ENOSPC, as 
> that's the symbolic name for the error code you get when this happens 
> (or when your filesystem is just normally full), but I actually kind 
> of like your name for it too, it conveys the exact condition being 
> discussed in a way that should be a bit easier for non-technical types 
> to understand.

Iiuc, ENOSPC is _exhaustion_ of unallocated space, which is a specific 
case of depletion.

I sought a term to refer to the phenomenon of unallocated space 
shrinking beyond what filesystem use would demand and how it ratchets 
down. Hence a sysop needs to manage DoUS. ENOSPC is likely a failure of 
such management.


>> - Some experienced users say that, to resolve a problem with DoUS, 
>> they would rather recreate the filesystem than run balance.
> This is kind of independent of BTRFS.

Yes. I mentioned it only because it was, to me, a striking statement of 
lack of confidence in balance.


>> But if Duncan is right (which, for me, is practically the same as 
>> consensus on the proposition) that problems with corruption while 
>> running balance are associated with heavy coincident IO activity, 
>> then I can see a reasonable way forwards. I can even see how general 
>> recommendations for BTRFS maintenance might develop.
> As I commented above, I would tend to believe Duncan is right in this 
> case (both because it makes sense, and because he seems to generally 
> be right about this type of thing).  That said, I really do think that 
> normal user I/O is probably not the issue, but low-level filesystem 
> operations are.  That said, there is no reason that BTRFS shouldn't 
> either:
> 1. Handle this just fine without causing corruption.
> or:
> 2. Extend the mutex used to prevent concurrent balances to cover other 
> operations that might cause issues (that is, make it so you can't 
> scrub a filesystem while it's being balanced, or defragment it, or 
> whatever else).

Yes, but backtracking a bit, I think there's another really important 
point here. Assuming Duncan's right, it's not so hard to develop 
guidelines for general BTRFS management that include DoUS among other 
topics. Duncan's other email today contains or implies quite a lot of 
those guidelines.

Or, to put it another way, it's enough for me. I think I know what to do 
now. And that much could be written down for the benefit of others.

Tom

