Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:53318 "EHLO mail.crc.id.au"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755917AbcIOBNs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 21:13:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 15 Sep 2016 11:13:43 +1000
From: Steven Haigh <netwiz@crc.id.au>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, dsterba@suse.cz,
        Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
In-Reply-To: <20160915010759.GD32452@DigitalMercury.dynalias.net>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
Message-ID: <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 11:07, Nicholas D Steeves wrote:
> On Mon, Sep 12, 2016 at 01:31:42PM -0400, Austin S. Hemmelgarn wrote:
>> In general yes in this case, but performance starts to degrade 
>> exponentially
>> beyond a certain point.  The difference between (for example) 10 and 
>> 20
>> snapshots is not as much as between 1000 and 1010. The problem here is 
>> that
>> we don't really have a BCP document that anyone ever reads.  A lot of 
>> stuff
>> that may seem obvious to us after years of working with BTRFS isn't 
>> going to
>> be to a newcomer, and it's a lot more likely that some random person 
>> will
>> get things write if we have a good, central BCP document than if it 
>> stays as
>> scattered tribal knowledge.
> 
> "Scattered tribal knowledge"...exactly!  :-D

+1 also.

I haven't been following this closely due to other commitments - but I'm 
happy to see the progress on the 'stability matrix' added to the wiki 
page.

It may seem trivial to people who live, eat, and breathe BTRFS, but for 
others, it saves stress, headaches and data loss.

I can't emphasise enough how important getting this part right is until 
some future date where *everything* just works.

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
