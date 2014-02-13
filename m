Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:36930 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaBMQcE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 11:32:04 -0500
Message-ID: <52FCF383.9090304@jrs-s.net>
Date: Thu, 13 Feb 2014 11:32:03 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
References: <52FCEF46.3070306@jrs-s.net> <20140213162140.GW6490@carfax.org.uk>
In-Reply-To: <20140213162140.GW6490@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That is FANTASTIC news.  Thank you for wielding the LART gently. =)

I do a fair amount of public speaking and writing about next-gen 
filesystems (example: 
http://arstechnica.com/information-technology/2014/01/bitrot-and-atomic-cows-inside-next-gen-filesystems/) 
and I will be VERY sure to talk about the upcoming divorce of stripe 
size from array size in future presentations.  This makes me positively 
giddy.

FWIW, after writing the above article I got contacted by a proprietary 
storage vendor who wanted to tell me all about his midmarket/enterprise 
product, and he was pretty audibly flummoxed when I explained how 
btrfs-RAID1 distributes data and redundancy - his product does something 
similar (to be fair, his product also does a lot of other things btrfs 
doesn't inherently do, like clustered storage and synchronous dedup), 
and he had no idea that anything freely available did anything vaguely 
like it.

I have a feeling the storage world - even the relatively well-informed 
part of it that's aware of ZFS - has little to no inclination how 
gigantic of a splash btrfs is going to make when it truly hits the 
mainstream.

>> This could be a pretty powerful setup IMO - if you implemented
>> something like this, you'd be able to arbitrarily define your
>> storage efficiency (percentage of parity blocks / data blocks) and
>> your fault-tolerance level (how many drives you can afford to lose
>> before failure) WITHOUT tying it directly to your underlying disks,
>> or necessarily needing to rebalance as you add more disks to the
>> array.  This would be a heck of a lot more flexible than ZFS'
>> approach of adding more immutable vdevs.
>>
>> Please feel free to tell me why I'm dumb for either 1. not realizing
>> the obvious flaw in this idea or 2. not realizing it's already being
>> worked on in exactly this fashion. =)
>     The latter. :)

