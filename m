From: "yanhai zhu" <zhu.yanhai@gmail.com>
Subject: Re: [PATH]Some fix for batching extent insert.
Date: Tue, 18 Nov 2008 22:35:10 +0800
Message-ID: <977a2be20811180635u21f4dbbakd9dbc3a6665960d2@mail.gmail.com>
References: <2c3b11250811170748s508ec4ddlfce9ad80bb296d95@mail.gmail.com>
	 <1227010670.15917.2.camel@think.oraclecorp.com>
	 <1227011417.15917.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Liu Hui" <onlyflyer@gmail.com>, linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1227011417.15917.3.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

hello,
   In fact, Before Liu's change, this function maybe don't wait and
insert ALL extents when all=1 in some cases,
please think about the following conditions:

when run to Line 2146
(1) all is set to 1
(2) we have skipped some extents in previous loops (skipped = 1)
(3) we have found nothing yet (num_inserts = 0)
According to Line 2145, we just simplely set skipped=0, continue loop
keeping @search unchanged. In the next loop, find_first_extent_bit()
still checks the @search position and returns 1, but at this time,
since skipped==0
Line 2146 will not be triggered, we break the loop at Line 2152,with
(1) all is 1 (2) skipped is 0 (3) num_inserts is 0
The following procedures with list will be ok since they can survive
from empty list.
But, Line 2220 will not be triggered either because skipped is 0 now.
Line 2285, also not work.
At last, we exit from this function, with (1) skipped some locked
extents (2) insert none extents

Liu Hui's patch did the right thing to fix this problem, and the more
simple way to fix it is just remove Line 2146-2149, so the if
statement at Line 2220 will do right things now.

In fact when we fix it like this, the funtion it self is right in
theory but appears to loop forever.
As I have no test suite, I guess *maybe* we encounter some unlock
extents(which may be forever locked),
this fix function insist on its duty -- which is to make sure all
extents are checked -- so trapped into a
forever loop.

So I think there may be another hidden error triggered by this fix(a
dead lock or a lock leak?)

thanks,
Zhu Yanhai
--

2008/11/18 Chris Mason <chris.mason@oracle.com>:
> On Tue, 2008-11-18 at 07:17 -0500, Chris Mason wrote:
>> On Mon, 2008-11-17 at 23:48 +0800, Liu Hui wrote:
>> > Hi,
>> > When I review the code about batching extent insert, I found some code
>> > could result in problems in some corner cases.
>> > 1)In finish_current_insert(), when it finds nothing to insert and it
>> > has skipped some locked extents, it should try again to see if the
>> > locked extent is unlocked. So, it will re-search the extent_ins
>> > extent_io_tree by reseting 'search' to 0. There is one place forget to
>> > reset the 'search' pointer to 0 which will lead BTRFS not to finish
>> > *all* current insert.
>> >
>>
>> Thanks for spending time on this, but I'm afraid this patch leads to
>> infinite looping in finish_current_insert under stress testing.
>
> Ah, I see there is a check later in finish_current_insert to make sure
> we don't miss anything.  I'm retesting with just that hunk removed.
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Zhu Yanhai
