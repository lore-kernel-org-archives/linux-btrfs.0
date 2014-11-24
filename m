Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-maryann.wadns.net ([41.185.62.88]:10805 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754508AbaKXSFb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 13:05:31 -0500
Message-ID: <5473736B.2060009@swiftspirit.co.za>
Date: Mon, 24 Nov 2014 20:05:31 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: Hugo Mills <hugo@carfax.org.uk>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com> <20141122222606.GO8916@merlins.org> <CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com> <20141123000503.GQ32735@carfax.org.uk> <20141123010742.GA16599@merlins.org>
In-Reply-To: <20141123010742.GA16599@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/23 03:07, Marc MERLIN wrote:
> On Sun, Nov 23, 2014 at 12:05:04AM +0000, Hugo Mills wrote:
>>> Which is correct?
>>     Less than or equal to 55% full.
>   
> This confuses me. Does that mean that the fullest blocks do not get
> rebalanced?

"Balance has three primary benefits:
- free up some space for new allocations
- change storage profile
- balance/migrate data to or away from new or failing disks (the 
original purpose of balance)
and one fringe benefit:
- force a data re-write (good if you think your spinning-rust needs to 
re-allocate sectors)

In the regular case where you're not changing the storage profile or 
migrating data between disks, there isn't much to gain from balancing 
full chunks - and it involves a lot of work. For SSDs, it is 
particularly bad for wear. For spinning rust it is merely a lot of 
unnecessary work.

> I guess I was under the mistaken impression that the more data you had the
> more you could be out of balance.
>
>>     A chunk is the part of a block group that lives on one device, so
>> in RAID-1, every block group is precisely two chunks; in RAID-0, every
>> block group is 2 or more chunks, up to the number of devices in the
>> FS. A chunk is usually 1 GiB in size for data and 250 MiB for
>> metadata, but can be smaller under some circumstances.
> Right. So, why would you rebalance empty chunks or near empty chunks?
> Don't you want to rebalance almost full chunks first, and work you way to
> less and less full as needed?

Balancing empty chunks makes them available for re-allocation - so that 
is directly useful and light on workload.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

