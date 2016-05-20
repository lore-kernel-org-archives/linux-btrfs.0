Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34622 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbcETLqX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 07:46:23 -0400
Received: by mail-io0-f182.google.com with SMTP id 190so142505557iow.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 04:46:23 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id ho7sm1251831igc.16.2016.05.20.04.46.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Fri, 20 May 2016 04:46:21 -0700 (PDT)
Subject: Re: Hot data tracking / hybrid storage
To: linux-btrfs@vger.kernel.org
References: <nh9p2p$cns$1@ger.gmane.org>
 <pan$ae8c7$965ff694$cf73d90e$9e134691@cox.net>
 <20160516010524.7e208f96@jupiter.sol.kaishome.de>
 <nhedk2$dpq$1@ger.gmane.org> <0d68f988-e117-4b61-cb9b-d18a26e2b909@gmail.com>
 <20160517203335.5ff99a05@jupiter.sol.kaishome.de>
 <nhir96$8n4$1@ger.gmane.org>
 <20160519200926.0a2b5dcf@jupiter.sol.kaishome.de>
 <e8ff591f-751b-ac56-45bb-98cdc7b206e7@gmail.com>
 <20160519230140.654daf03@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4abbb0c8-60f0-bba5-c0a6-3e20dd35f1e7@gmail.com>
Date: Fri, 20 May 2016 07:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <20160519230140.654daf03@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-19 17:01, Kai Krakow wrote:
> Am Thu, 19 May 2016 14:51:01 -0400
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> For a point of reference, I've
>> got a pair of 250GB Crucial MX100's (they cost less than 0.50 USD per
>> GB when I got them and provide essentially the same power-loss
>> protections that the high end Intel SSD's do) which have seen more
>> than 2.5TB of data writes over their lifetime, combined from at least
>> three different filesystem formats (BTRFS, FAT32, and ext4), swap
>> space, and LVM management, and the wear-leveling indicator on each
>> still says they have 100% life remaining, and the similar 500GB one I
>> just recently upgraded in my laptop had seen over 50TB of writes and
>> was still saying 95% life remaining (and had been for months).
Correction, I hadn't checked recently, the 250G ones have seen about 
6.336TB of writes (I hadn't checked for multiple months), and report 90% 
remaining life, with about 240 days of power-on time.  This overall 
equates to about 775MBs of writes per-hour, and assuming similar write 
rates for the remaining life of the SSD, I can still expect roughly 9 
years of service from these, which means about 10 years of life given my 
usage, which is well beyond what I typically get from a traditional hard 
disk for the same price, and far exceeds the typical usable life of most 
desktops, laptops, and even some workstation computers.

And you have to also keep in mind, this 775MB/hour of writes is coming 
from a system that is running:
* BOINC distributed computing applications (regularly downloading big 
files, and almost constantly writing data)
* Dropbox
* Software builds for almost a dozen different systems (I use Gentoo, so 
_everything_ is built locally)
* Regression testing for BTRFS
* Basic network services (DHCP, DNS, and similar things)
* A tor entry node
* A local mail server (store and forward only, I just use it for 
monitoring messages)
And all of that (except the BTRFS regression testing) is running 24/7, 
and that's just the local VM's, and doesn't include the file sharing or 
SAN services.  Root filesystems for all of these VM's are all on the 
SSD's, as is the host's root filesystem and swap partition, and many of 
the data partitions.  And I haven't really done any write optimization, 
and it's still less  than 1GB/hour of writes to the SSD.  The typical 
user (including many types of server systems) will be writing much less 
than that most of the time.
>
> The smaller Crucials are much worse at that: The MX100 128GB version I
> had was specified for 85TB writes which I hit after about 12 months (97%
> lifetime used according to smartctl) due to excessive write patterns.
> I'm not sure how long it would have lasted but I decided to swap it for
> a Samsung 500GB drive, and reconfigure my system for much less write
> patterns.
>
> What should I say: I liked the Crucial more, first: It has an easy
> lifetime counter in smartctl, Samsung doesn't. And it had powerloss
> protection which Samsung doesn't explicitly mention (tho I think it has
> it).
>
> At least, according to endurance tests, my Samsung SSD should take
> about 1 PB of writes. I've already written 7 TB if I can trust the
> smartctl raw value.
>
> But I think you cannot compare specification values to a real endurance
> test... I think it says 150TBW for 500GB 850 EVO.
>
The point was more that wear out is less of an issue for a lot of people 
than many individuals make it out to be, not me trying to make Crucial 
sound like an amazing brand.  Yes, one of the Crucial MX100's may not 
last long as a Samsung EVO in a busy mail server or something similar, 
but for a majority of people, they will probably outlast the usefulness 
of the computer.
