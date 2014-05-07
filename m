Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-shanna.wadns.net ([196.220.39.217]:42395 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932157AbaEGKx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:53:27 -0400
Message-ID: <536A1097.2020508@swiftspirit.co.za>
Date: Wed, 07 May 2014 12:53:11 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: How does "btrfs fi show" show full?
References: <20140505005412.GS9061@merlins.org> <53670F70.1010509@swiftspirit.co.za> <20140505055029.GM10159@merlins.org> <pan$1f225$3bfd5829$2b5ac65b$4bb85dc6@cox.net> <20140507075902.GL10159@merlins.org>
In-Reply-To: <20140507075902.GL10159@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/07 09:59 AM, Marc MERLIN wrote:
> [snip]
>
> Did I get this right?
> I'm not sure I did, since it seems the bigger the -dusage number, the
> more work balance has to do.
>
> If I asked -dsuage=85, it would do all chunks that are more than 15%
> full?

-dusage=85 balances all chunks that up to 85% full. The higher the 
number, the more work that needs to be done.
> So, do I need to change the text above to say "more than 45% full" ?
>
> More generally, does it not make sense to just use the same percentage
> in -dusage than the percentage of total filesytem full?
>
> Thanks,
> Marc

Separately, Duncan has made me realise my "halfway up" algorithm is not 
very good - it was probably just "good enough" at the time and worked 
"well enough" that I wasn't prompted to analyse it further.

Doing a simulation with randomly-semi-filled chunks, "df" at 55%, and 
chunk utilisation at 86%, -dusage=55 balances 30% of the chunks, almost 
perfectly bringing chunk utilisation down to 56%. In my algorithm I 
would have used -dusage=70 which in my simulation would have balanced 
34% of the chunks - but bringing chunk utilisation down to 55% - a bit 
of wasted effort and unnecessary SSD wear.

I think now that I need to experiment with a much lower -dusage value 
and perhaps to repeat the balance with the df value (55 in the example) 
if the chunk usage is still too high. Getting an optimal first value 
algorithmically might prove a challenge - I might just end up picking 
some arbitrary percentage point below the df value.

Pathological use-cases still apply however (for example if all chunks 
except one are exactly 54% full). The up-side is that if the algorithm 
is applied regularly (as in scripted and scheduled) then the situation 
will always be that the majority of chunks are going to be relatively 
full, avoiding the pathological use-case.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

