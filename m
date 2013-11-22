Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav4.altibox.net ([81.167.36.153]:36458 "EHLO
	asav4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab3KVAcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Nov 2013 19:32:13 -0500
Message-ID: <528EA609.9060702@hesbynett.no>
Date: Fri, 22 Nov 2013 01:32:09 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
CC: Andrea Mazzoleni <amadvance@gmail.com>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, hpa@zytor.com, creamyfish@gmail.com
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com> <20131119181237.GA3666@lazy.lzy> <528C9297.9030801@hesbynett.no> <20131120215939.GA2622@lazy.lzy> <528DDCC9.7050701@hesbynett.no> <20131121200545.GB1916@lazy.lzy> <528E6DB2.6050005@hesbynett.no> <20131121205229.GA2458@lazy.lzy>
In-Reply-To: <20131121205229.GA2458@lazy.lzy>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/11/13 21:52, Piergiorgio Sartor wrote:
> Hi David,
> 
> On Thu, Nov 21, 2013 at 09:31:46PM +0100, David Brown wrote:
> [...]
>> If this can all be done to give the user an informed choice, then it
>> sounds good.
> 
> that would be my target.
> To _offer_ more options to the (advanced) user.
> It _must_ always be under user control.
> 
>> One issue here is whether the check should be done with the filesystem
>> mounted and in use, or only off-line.  If it is off-line then it will
>> mean a long down-time while the array is checked - but if it is online,
>> then there is the risk of confusing the filesystem and caches by
>> changing the data.
> 
> Currently, "raid6check" can work with FS mounted.
> I got the suggestion from Neil (of course).
> It is possible to lock one stripe and check it.
> This should be, at any given time, consistent
> (that is, the parity should always match the data).
> If an error is found, it is reported.
> Again, the user can decide to fix it or not,
> considering all the FS consequences and so on.
> 

If you can lock stripes, and make sure any old data from that stripe is
flushed from the caches (if you change it while locked), then that
sounds ideal.

>> Most disk errors /are/ detectable, and are reported by the underlying
>> hardware - small surface errors are corrected by the disk's own error
>> checking and correcting mechanisms, and larger errors are usually
>> detected.  It is (or should be!) very rare that a read error goes
>> undetected without there being a major problem with the disk controller.
>>  And if the error is detected, then the normal raid processing kicks in
>> as there is no doubt about which block has problems.
> 
> That's clear. That case is an "erasure" (I think)
> and it is perfectly in line with the usual operation.
> I'm not trying to replace this mechanism.
>  
>> If you can be /sure/ about which data block is incorrect, then I agree -
>> but you can't be /entirely/ sure.  But I agree that you can make a good
>> enough guess to recommend a fix to the user - as long as it is not
>> automatic.
> 
> One typical case is when many errors are
> found, belonging to the same disk.
> This case clearly shows the disk is to be
> replaced or the interface checked...
> But, again, the user is the master, not the
> machine... :-)

I don't know what sort of interface you have for the user, but I guess
that means you'll have to collect a number of failures before showing
them so that the user can see the correlation on disk number.

>  
>> For most ECC schemes, you know that all your blocks are set
>> synchronously - so any block that does not fit in, is an error.  With
>> raid, it could also be that a stripe is only partly written - you can
> 
> Could it be?
> I would consider this an error.

It could occur as the result of a failure of some sort (kernel crash,
power failure, temporary disk problem, etc.).  More generally, md raid
doesn't have to be on local physical disks - maybe one of the "disks" is
an iSCSI drive or something else over a network that could have failures
or delays.  I haven't thought through all cases here - I am just
throwing them out as possibilities that might cause trouble.

> The stripe must always be consistent, there
> should be a transactional mechanism to make
> sure that, if read back, the data is always
> matching the parity.
> When I write "read back" I mean from whatever
> the data is: physical disk or cache.
> Otherwise, the check must run exclusively on
> the array (no mounted FS, no other things
> running on it).
> 
>> have two different valid sets of data mixed to give an inconsistent
>> stripe, without any good way of telling what consistent data is the best
>> choice.
>>  
>> Perhaps a checking tool can take advantage of a write-intent bitmap (if
>> there is one) so that it knows if an inconsistent stripe is partly
>> updated or the result of a disk error.
> 
> Of course, this is an option, which should be
> taken into consideration.
> 
> Any improvement idea is welcome!!!
> 
> bye,
> 

