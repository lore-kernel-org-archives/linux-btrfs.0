Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:50913 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883AbbBJNPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 08:15:21 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Repair broken btrfs =?iso-8859-1?Q?raid6=3F?=
Date: Tue, 10 Feb 2015 08:15:19 -0500
MIME-Version: 1.0
Message-ID: <486ed2b2-3c80-4856-8701-bcd71a212b18@aei.ca>
In-Reply-To: <ntnoqb-jvq.ln1@hurikhan77.spdns.de>
References: <CAGwxe4gXPEOTPfNc2=0E0HAfDfTRKRcqqPjVJimbWJr5riz4DA@mail.gmail.com>
 <ntnoqb-jvq.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, February 10, 2015 2:17:43 AM EST, Kai Krakow wrote:
> Tobias Holst <tobby@tobby.eu> schrieb:
>
>> and "btrfs scrub status /[device]" gives me the following output:
>>> "scrub status for [UUID]
>>> scrub started at Mon Feb  9 18:16:38 2015 and was aborted after 2008
>>> seconds total bytes scrubbed: 113.04GiB with 0 errors"
>
> Does not look very correct to me:
>
> Why should a scrub in a six-drivers btrfs array which is probably multi-
> terabytes big (as you state a restore from backup would take 
> days) take only 
> ~2000 seconds? And scrub only ~120 GB worth of data. Either your 6 devices 
> are really small (then why RAID-6), or your data is very sparse (then way 
> does it take so long), or scrub prematurely aborts and never checks the 
> complete devices (I guess this is it).
>
> And that's what it actually says: "aborted after 2008" seconds. I'd expect 
> "finished after XXXX seconds" if I remember my scrub runs 
> correctly (which I 
> currently don't do regularly because it takes long and IO performance sucks 
> during running it).

IO perfermance does suffer during a scrub.  I use the following:

ionice -c 3 btrfs scrub start -Bd -n 19 /<target>

The combo of -n19 and ionice makes it workable here.  

Tobias why do you think btrfsck does not work on raid6?  It runs fine
here on raid5.



