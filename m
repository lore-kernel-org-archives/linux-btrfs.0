Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbbJXXwZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Oct 2015 19:52:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zq8bh-0001W6-Fq
	for linux-btrfs@vger.kernel.org; Sun, 25 Oct 2015 01:52:17 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2015 01:52:17 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2015 01:52:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs double send
Date: Sat, 24 Oct 2015 23:52:08 +0000 (UTC)
Message-ID: <pan$9ab81$c8b92b5e$46b15e5$edd1116f@cox.net>
References: <20151024173617.GA26012@nbnb1>
	<CAL3q7H5H_Qdq0NAhiDOVw=JLYPJPuHhhSZPgUSQm=oYN+yXK=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Filipe Manana posted on Sat, 24 Oct 2015 18:52:21 +0100 as excerpted:

> On Sat, Oct 24, 2015 at 6:36 PM,  <kolcon@kolcon.net> wrote:
>> Hello,
>>
>> I would like to do backups based on btrfs send/receive.
>>
>> So I though I would do a transfer over portable HDD and then
>> incremental sends (using -p) over network.
>>
>> Initial :
>>
>> btrfs send "all" (primary HDD) →  btrfs receive (portable HDD) →  btrfs
>> send/receive (final HDD)
>>
>> Later :
>>
>> btrfs send -p "all" new →  ssh newhost "btrfs receive … "
>>
>> But I found out that does not work. It complains parent not found.
>>
>> Am I doing something wrong, or is it intended behaviour?
> 
> It's a bug, we got it recently reported and fixed.
> The fix is in Chris' integration branch for the upcoming 4.4 merge
> window:
> 
> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/
commit/?h=integration-4.4&id=b96b1db039ebc584d03a9933b279e0d3e704c528

As a current workaround...

It's worth noting that btrfs send outputs a stream, while btrfs receives 
a stream, but they don't have to be hooked up directly in real-time.  
Both send and receive have parameters that allow sending output to, and 
receiving input from, a file, and of course since they work with STDOUT/
STDIN, even if explicit file options weren't supplied, shell redirection 
can be used to do it.

So it's quite possible to send to a file on the the portable device 
instead of to btrfs receive, then unplug the device and plug it in on the 
target, receiving from the file there.  That avoids the intermediate 
receive/send and thus the problem, since it's ultimately (a copy of) the 
original send stream now being received by receive on the target machine.

That also allows additional flexibility, since the intermediate/portable 
device now doesn't have to have btrfs on it; it can be ext* or whatever.  
In fact, the portable device shouldn't even need a filesystem at all, as 
sending directly to the device-file and receiving from it should work.  
Send/receive works with a stream after all, and anything that can 
accurately store and replay that stream should be sufficient. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

