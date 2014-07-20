Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob02.myregisteredsite.com ([209.17.115.40]:40004 "EHLO
	atl4mhob02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbaGTVxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 17:53:30 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail03pod1.mgt.hosting.qts.netsol.com [10.30.71.115])
	by atl4mhob02.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s6KLrSg5011872
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 17:53:28 -0400
Message-ID: <53CC3A9A.70109@chinilu.com>
Date: Sun, 20 Jul 2014 14:54:34 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org>	<53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu> <53CC3478.8060503@shiftmail.org>
In-Reply-To: <53CC3478.8060503@shiftmail.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2014 02:28 PM, Bob Marley wrote:
> On 20/07/2014 21:36, Roman Mamedov wrote:
>> On Sun, 20 Jul 2014 21:15:31 +0200
>> Bob Marley <bobmarley@shiftmail.org> wrote:
>>
>>> Hi TM, are you doing other significant filesystem activity during this
>>> rebuild, especially random accesses?
>>> This can reduce performances a lot on HDDs.
>>> E.g. if you were doing strenous multithreaded random writes in the
>>> meanwhile, I could expect even less than 5MB/sec overall...
>> I believe the problem here might be that a Btrfs rebuild *is* a 
>> strenuous
>> random read (+ random-ish write) just by itself.
>>
>> Mdadm-based RAID would rebuild the array reading/writing disks in a 
>> completely
>> linear manner, and it would finish an order of magnitude faster.
>
> Now this explains a lot!
> So they would just need to be sorted?
> Sorting the files of a disk from lowest to highers block number prior 
> to starting reconstruction seems feasible. Maybe not all of them 
> together because they will be millions, but sorting them in chunks of 
> 1000 files would still produce a very significant speedup!
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
As I understand the problem, it has to do with where btrfs is in the 
overall development process.  There are a LOT of opportunities for 
optimization, but optimization cannot begin until btrfs is feature 
complete, because any work done beforehand would be wasted effort in 
that it would likely have to be repeated after being broken by feature 
enhancements.  So now it is a waiting game for completion of all the 
major features (like additional RAID levels and possible n-way options, 
etc) before optimization efforts can begin.  Once that happens we will 
likely see HUGE gains in efficiency and speed, but until then we are 
kind of stuck in this position where it "works" but leaves somewhat to 
be desired.  I think this is one reason developers often caution users 
not to expect too much from btrfs at this point.  Its just not there yet 
and it will still be some time yet before it is.
