Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:47138 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbcF0DWz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 23:22:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 27 Jun 2016 13:22:51 +1000
From: Steven Haigh <netwiz@crc.id.au>
To: Hugo Mills <hugo@carfax.org.uk>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
In-Reply-To: <20160626223813.GA10223@carfax.org.uk>
References: <8695beeb-f991-28c4-cf6b-8c92339e468f@inwind.it>
 <CAJCQCtTXJhgKsmQGUXrppntYj8u6vk3jzP9Q4UMBomJ255QTQw@mail.gmail.com>
 <pan$60ea0$54eb541$a3b060fc$181835e5@cox.net>
 <CAN05THQCJS8x0yF6DjDFfsNWzp1u4edv5dH-BMb1TTofZdtjgA@mail.gmail.com>
 <20160626223813.GA10223@carfax.org.uk>
Message-ID: <1fbebd33fa43328a14548e2c4f61f420@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-27 08:38, Hugo Mills wrote:
> On Sun, Jun 26, 2016 at 03:33:08PM -0700, ronnie sahlberg wrote:
>> On Sat, Jun 25, 2016 at 7:53 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> > Could this explain why people have been reporting so many raid56 mode
>> > cases of btrfs replacing a first drive appearing to succeed just fine,
>> > but then they go to btrfs replace a second drive, and the array crashes
>> > as if the first replace didn't work correctly after all, resulting in two
>> > bad devices once the second replace gets under way, of course bringing
>> > down the array?
>> >
>> > If so, then it looks like we have our answer as to what has been going
>> > wrong that has been so hard to properly trace and thus to bugfix.
>> >
>> > Combine that with the raid4 dedicated parity device behavior you're
>> > seeing if the writes are all exactly 128 MB, with that possibly
>> > explaining the super-slow replaces, and this thread may have just given
>> > us answers to both of those until-now-untraceable issues.
>> >
>> > Regardless, what's /very/ clear by now is that raid56 mode as it
>> > currently exists is more or less fatally flawed, and a full scrap and
>> > rewrite to an entirely different raid56 mode on-disk format may be
>> > necessary to fix it.
>> >
>> > And what's even clearer is that people /really/ shouldn't be using raid56
>> > mode for anything but testing with throw-away data, at this point.
>> > Anything else is simply irresponsible.
>> >
>> > Does that mean we need to put a "raid56 mode may eat your babies" level
>> > warning in the manpage and require a --force to either mkfs.btrfs or
>> > balance to raid56 mode?  Because that's about where I am on it.
>> 
>> Agree. At this point letting ordinary users create raid56 filesystems
>> is counterproductive.
>> 
>> 
>> I would suggest:
>> 
>> 1, a much more strongly worded warning in the wiki. Make sure there
>> are no misunderstandings
>> that they really should not use raid56 right now for new filesystems.
> 
>    I beefed up the warnings in several places in the wiki a couple of
> days ago.

Not to sound rude - but I don't think these go anywhere near far enough. 
It needs to be completely obvious that its a good chance you'll lose 
everything. IMHO that's the only way that will stop BTRFS from getting 
the 'data eater' reputation. It can be revisited and reworded when the 
implementation is more tested and stable.

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
