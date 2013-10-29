Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57927 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3J2Qms (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 12:42:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VbCNR-0004tM-Jl
	for linux-btrfs@vger.kernel.org; Tue, 29 Oct 2013 17:42:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 17:42:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 17:42:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: memory leak in <=3.11.6
Date: Tue, 29 Oct 2013 16:42:23 +0000 (UTC)
Message-ID: <pan$d5444$ef292b25$154f150a$c91a6fe4@cox.net>
References: <9c53ka-otf.ln1@hurikhan77.spdns.de>
	<CALJXSJr0sjzFwCT=w1WdDX+-CWS-CjDhYBArVpvTeUNBM88Mdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jérôme Poulin posted on Mon, 28 Oct 2013 23:24:10 -0400 as excerpted:

> On Mon, Oct 28, 2013 at 6:34 PM, Kai Krakow <hurikhan77+btrfs@gmail.com>
> wrote:
>>
>> If I close all my desktop programs, my system stays at +12 GB RAM usage
>> while after a fresh boot it has 12+ GB free (of 16 GB). Cache stays low
>> at 2 GB while after a few minutes uptime cache is about 5 GB.
> 
> I probably have the same problem over here, after about 2 weeks of
> random read/write it seems my memory and swap get almost full and even
> after killing all process and getting in single user mode, memory won't
> free up.  Would you happen to have quota enabled too? Kernel is 3.11.4

FWIW, seeing nothing like that here, no quota/qgroups enabled.

But there's definitely something not right with qgroups at this time.  
First, a lot of folks with it enabled are reporting negative numbers 
which shouldn't be there, and second, all or very nearly all the huge 
memory usage issues reported seem to be from qgroups-enabled people.

So I'd call the qgroups feature broken at this time.  Don't use it if you 
can avoid it (but be aware that turning it off triggers the memory issue 
and ultimate crashing for some, so preferably turn it off when you're 
rebooting anyway), and if you really do need quotas for your use-case, 
you may be better off on a non-btrfs filesystem for the time being.

(Of course btrfs is still listed as experimental in any case, so one 
shouldn't be surprised if this sort of thing happens from time to time or 
with some features.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

