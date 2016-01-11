Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36659 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883AbcAKMva (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 07:51:30 -0500
Received: by mail-ig0-f172.google.com with SMTP id z14so99621572igp.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 04:51:30 -0800 (PST)
Subject: Re: send/receive for encrypted backup purposes
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-btrfs@vger.kernel.org
References: <1827847.pVfOzZHEoP@merkaba> <568FCF45.1060007@gmail.com>
 <1452365502@msgid.manchmal.in-ulm.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5693A512.3000109@gmail.com>
Date: Mon, 11 Jan 2016 07:50:26 -0500
MIME-Version: 1.0
In-Reply-To: <1452365502@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-09 14:05, Christoph Biedl wrote:
> Austin S. Hemmelgarn wrote...
>
>> (...) If you only ever
>> need to access the device locally on the network served by the router
>> however, I'd actually suggest ATAoE over iSCSI or NBD, it's a lot more
>> efficient and technically more secure because it's non-routable (it runs
>> directly over the link layer, which means you avoid the overhead of IP and
>> TCP, and has the added advantage that you technically don't need anything
>> but the kernel driver on the client side).
>
> Although pretty offtopic ... AoE is not routable but don't sell this
> as a security feature. If you cannot configure ACLs, you're doomed
> anyway. The only security model AoE provides is the client's MAC
> address but spoofing is really not a problem.
I should have qualified this, I meant it's more secure against 
accidental leaks off network.  I've had issues with this in the past 
with iSCSI where the initiator got confused and tried to contact 
something across the internet.  In addition to that, NBD and iSCSI still 
are no more secure against data loss if your network is actually 
compromised (because of how most home routers are configured (and in may 
cases, are forced to be configured), it's trivial to read all the 
traffic on the network if the router is compromised, and only slightly 
more difficult if you get admin access on a system on the network), they 
just provide better protection against DoS attacks.
>
> So in short:
>
> * AoE is really simple to set up but if there's even a remote chance
>    some evil guy is in your network (i.e. ethernet broadcast domain),
>    just forget it. Also AoE completely relies on the ethernet checksums
>    to detect data curruption, and I had some funny experiences because
>    of that.
Except that if you run BTRFS on it too, that provides further 
protection.  And, if you've got properly working hardware, this degree 
of data protection should be perfectly fine (if you're getting Ethernet 
frames with bad checksums that get through on the recipient, then 
something is wrong with your network).
>
> * NBD has (or had the last time I checked some 15 months ago) some
>    serious issues on client side if the server becomes unavailable,
>    including data loss. Yes, I should debug this one day.
It still has issues, but I don't think they're as bad as they used to 
be.  The only cases I would advocate it's usage for is exposing stuff 
temporarily to VM's that don't allow run-time reconfiguration of block 
storage, and using qemu-nbd to expose disk images to a system as block 
devices.
>
> * iSCSI probably provides everything you want. At the price of having
>    to understand how to set it up. I failed several times and
>    eventually gave up, your mileage may vary.
And the price of efficiency.  iSCSI is over-engineered for 
non-enterprise usage, and largely impractical for people who have no 
experience with it (as you found out several times).

