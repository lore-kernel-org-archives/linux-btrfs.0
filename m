Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54233 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933219AbaGUSb6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 14:31:58 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:57008 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X9INR-003KKc-8f
	for linux-btrfs@vger.kernel.org; Mon, 21 Jul 2014 12:31:57 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com>
Date: Mon, 21 Jul 2014 12:31:55 -0600
Message-Id: <07A98FF5-6EE9-4C93-B34B-17EDCC61FA15@colorremedies.com>
References: <loom.20140720T102642-239@post.gmane.org> <53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu> <37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net> <pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net> <CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 21, 2014, at 10:46 AM, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> On Sun, Jul 20, 2014 at 7:48 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> ashford posted on Sun, 20 Jul 2014 12:59:21 -0700 as excerpted:
>> 
>>> If you assume a 12ms average seek time (normal for 7200RPM SATA drives),
>>> an 8.3ms rotational latency (half a rotation), an average 64kb write and
>>> a 100MB/S streaming write speed, each write comes in at ~21ms, which
>>> gives us ~47 IOPS.  With the 64KB write size, this comes out to ~3MB/S,
>>> DISK LIMITED.
>> 
>>> The 5MB/S that TM is seeing is fine, considering the small files he says
>>> he has.
>> 
>> Thanks for the additional numbers supporting my point. =:^)
>> 
>> I had run some of the numbers but not to the extent you just did, so I
>> didn't know where 5 MiB/s fit in, only that it wasn't entirely out of the
>> range of expectation for spinning rust, given the current state of
>> optimization... or more accurately the lack thereof, due to the focus
>> still being on features.
>> 
> 
> That is actually nonsense.
> Raid rebuild operates on the block/stripe layer and not on the filesystem layer.

Not on Btrfs. It is on the filesystem layer. However, a rebuild is about replicating metadata (up to 256MB) and data (up to 1GB) chunks. For raid10, those are further broken down into 64KB strips. So the smallest size "unit" for replication during a rebuild on Btrfs would be 64KB.

Anyway 5MB/s seems really low to me, so I'm suspicious something else is going on. I haven't done a rebuild in a couple months, but my recollection is it's always been as fast as the write performance of a single device in the btrfs volume.

I'd be looking in dmesg for any of the physical drives being reset, having read or write errors, and I'd do some individual drive testing to see if the problem can be isolated. And if that's not helpful, well, this is really tedious and verbose amounts of information but it might reveal some issue is to capture actual commands going to physical devices:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg34886.html

My expectation (i.e. I'm guessing) based on previous testing is that whether raid1 or raid10, the actual read/write commands will each be 256KB in size. Btrfs rebuild is basically designed to be a sequential operation. This could maybe fall apart if there were somehow many minimally full chunks, which is probably unlikely.

Chris Murphy

