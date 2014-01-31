Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35222 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaAaHhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 02:37:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W98fN-0006sL-AT
	for linux-btrfs@vger.kernel.org; Fri, 31 Jan 2014 08:37:33 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 08:37:33 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 08:37:33 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: lost with degraded RAID1
Date: Fri, 31 Jan 2014 07:37:09 +0000 (UTC)
Message-ID: <pan$6a9a9$ad39465e$71323c3$6e34f01d@cox.net>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
	<CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
	<pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net>
	<8FF7CD63-3B07-42CB-88C3-E88D39280892@colorremedies.com>
	<pan$7d02a$d46a4ede$2832dda8$da2d2ddd@cox.net>
	<7EDDA59B-B69B-4376-B387-A5FCB3F7263C@colorremedies.com>
	<DD290B24-A1DE-477B-8A73-5507A907F901@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 30 Jan 2014 23:13:36 -0700 as excerpted:

> On Jan 30, 2014, at 11:10 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>> 
>> I'm also seeing many "Error reading 1647012864000, -1" with different
>> block addresses (same -1 though), and also "1659900002304failed to load
>> free space cache for block group" also with different numbers. Maybe
>> hundreds of these. I'm not sure if this is due to the missing device,
>> and it's reporting missing meta data? Or if the working device also has
>> some problem, which depending on the configuration might implicate a
>> single SATA controller.
> 
> Sorry I'm being impatient since I'm away snowboarding tomorrow. The
> above refers to parts of Johan's btrfs check output which hasn't yet
> made it to the list.

Break a leg! =:^)  (If you've done much drama/acting you may know the 
reference; there's a traditional superstition that wishing someone .... 
luck is a hex and they'll forget their lines or worse!  So you wish them 
to break a leg instead!  =:^)


I'm assuming the error reading errors are due to the missing device, with 
the round-robin trying to read the bad device 50% of the time, but if it 
was full raid1, then the existing copy should be found and read instead, 
assuming of course that the checksum verifies, so despite all the 
alarming looking noise, I believe it's harmless... assuming it was indeed 
full raid1 both data and metadata.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

