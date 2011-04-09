From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: 09 Apr 2011 20:15:00 +0200
Message-ID: <BjX0wGIi1uB@helmut.hullen.de>
References: <1302370000.23240.10.camel@nayuki>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302370000.23240.10.camel@nayuki>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 09.04.11:

>> Nice picture. But it doesn't solve the problem that I need a
>> reliable information about the free/available space. And I prefer
>> asking with "df" for this information - "df" should work in the same
>> way for all filesystems.

> The problem is that the answer to the seemingly simple question: "How
> much more data can I put onto this filesystem?" gets pretty hard with
> btrfs.

> Your case is one of the simpler ones - To calculate the remaining
> space for files, you take the unused allocated data space (light blue
> on my picture), add the unallocated space (white), divide by the raid
> mode redundancy, and subtract some percentage (this is only an
> estimate, of course...) of that unallocated space for the additional
> metadata overhead.

That's simple?

Maybe I'm simple minded. But I expect the same meaning of the shown date  
with

        df <mointpoint>

regardless what kind of filesystem is mounted.
But no test item for an IQ test.

If the value of "available" is unresolvable then btrfs should not show  
any value.


Ok - there's a problem slightly similar to the "available" value of  
compressed partitions.

Viele Gruesse!
Helmut
