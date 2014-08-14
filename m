Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35158 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752879AbaHNTKH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:10:07 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62853 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XI0PW-003hol-LO
	for linux-btrfs@vger.kernel.org; Thu, 14 Aug 2014 13:10:07 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-zero-log fails, can't mount FS
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140814172743.GC27531@merlins.org>
Date: Thu, 14 Aug 2014 13:10:05 -0600
Message-Id: <CED1BA77-2F2E-4ABF-AE56-5896FA377627@colorremedies.com>
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com> <20140814172743.GC27531@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 14, 2014, at 11:27 AM, Marc MERLIN <marc@merlins.org> wrote:

> On Thu, Aug 14, 2014 at 12:52:35PM -0400, Austin S Hemmelgarn wrote:
>> I don't think it is likely that the Samsung SSD is to blame, in my
>> experience Samsung's SSD's are better than almost every other brand
>> except Intel, and I know that they honor write-barriers correctly.
>> The likely issue is that the system hung during the process of a commit,
>> which is one of the few things that I know of that consistently corrupts
>> the filesystem.  There isn't really anything I know of to prevent it,
>> except for making your system as stable as possible.
>> Interestingly, this type of thing is the only issue I've ever had with
>> BTRFS that wasn't traceable to hardware problems.
> 
> That was my understanding too, thanks for confirming.
> 
> Until this bug gets fixed, I'm perplexed as to why btrfs-zero-log isn't
> fixing this.
> Can't I unroll the last commits until I get to a stable one?

What do you get for btrfs-debug-tree -R <dev>


Chris Murphy
