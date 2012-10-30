Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:33185 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965234Ab2J3SdO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 14:33:14 -0400
Date: Tue, 30 Oct 2012 18:32:40 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, cwillu <cwillu@cwillu.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC][V2] New attempt to a better "btrfs fi df"
Message-ID: <20121030183240.GU2381@yeono.kjorling.se>
References: <50899151.1070503@inwind.it>
 <508F015F.5090507@gmail.com>
 <20121030094253.GA20662@yeono.kjorling.se>
 <50901937.80002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <50901937.80002@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 Oct 2012 19:15 +0100, from kreijack@gmail.com (Goffredo Baroncelli):
> On 2012-10-30 10:42, Michael Kjörling wrote:
>> what is the difference between "unused" and "unallocated"? If there
>> is no difference, I feel the same word should be used throughout.
> 
> I had to use "Unused" instead of "Unallocated" because the first one is
> shorter. In the tabular output of the command "btrfs fi disk-usage" I
> have 10 columns available for every fields. 1 columns is used by the
> space character, so I have only 9 characters available for the
> description. "Unused" is 6 chars, "Unallocated" is 11 chars....
> The only options is to use "Unalloc." (8 chars)...

Or to simply use "unused" (or some other word like "free",
"available", ...) throughout.

I'm not so much concerned about the exact word being used as I feel
the same word should be used throughout a UI to describe the same
concept. Whether it's called "free" space, "unused" space,
"unallocated" space or "fuzzbar'd" space is really beside the point.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
