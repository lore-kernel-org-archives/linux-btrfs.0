Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32234 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753181Ab3HaWfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Aug 2013 18:35:13 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:51822 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VFtlA-001lTQ-LO
	for linux-btrfs@vger.kernel.org; Sat, 31 Aug 2013 16:35:12 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Unmountable BTRFS with parent transid verify failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$4b543$3168e754$1bbb4d2b$27429757@cox.net>
Date: Sat, 31 Aug 2013 16:35:09 -0600
Message-Id: <DB0E1DD9-3A39-401F-B3DA-9E582621AA05@colorremedies.com>
References: <CAN05THSnkRsRytfPZcn8eBqD_Y4BgjQTmJ9CsZC6h03xHzXJLA@mail.gmail. com> <pan$4b543$3168e754$1bbb4d2b$27429757@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 31, 2013, at 4:01 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> ronnie sahlberg posted on Sat, 31 Aug 2013 14:50:36 -0700 as excerpted:
> 
>> And while btrfsck eventually does complete  the filesystem remains
>> unmountable.
>> 
>> Any advice ?
> 
> This isn't specific to your question, but in general...
> 
> In the "Question: How can I recover this partition? (unable to find 
> logical $hugenum len 4096)" thread about a week ago, there's a post from 
> Hugo Mills, listing the general troubleshooting steps he recommends and 
> in what order.  I'd try that.
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999

I was about to suggest the same thing, but also to use something newer than 3.8.0, and before getting to any of the btrfs specific commands to make sure a recent btrfs-progs is being used. There have been lots of fixes between 3.8 and 3.10.


Chris Murphy