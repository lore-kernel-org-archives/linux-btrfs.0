Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35895 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbcA1McW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jan 2016 07:32:22 -0500
Received: by mail-ig0-f182.google.com with SMTP id z14so11802415igp.1
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jan 2016 04:32:22 -0800 (PST)
Subject: Re: RAID1 disk upgrade method
To: Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20160122034538.GA25196@coach.student.rit.edu>
 <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu>
 <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu> <20160127235528.GA5498@fox.rh.rit.edu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AA0A0A.1060807@gmail.com>
Date: Thu, 28 Jan 2016 07:31:06 -0500
MIME-Version: 1.0
In-Reply-To: <20160127235528.GA5498@fox.rh.rit.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-27 18:55, Sean Greenslade wrote:
> On Wed, Jan 27, 2016 at 05:45:49PM -0500, Sean Greenslade wrote:
>> OK, disks have arrived, and I've completed the first replace.
>> Interestingly enough, the replace seems to have succeeded, however btrfs
>> fi show doesn't seem to think so.
>>
>> Dmesg:
>> [Wed Jan 27 13:03:09 2016] BTRFS info (device sdb1): disk space caching
>> is enabled
>> [Wed Jan 27 13:03:09 2016] BTRFS: has skinny extents
>> [Wed Jan 27 13:03:09 2016] BTRFS: bdev /dev/sdb1 errs: wr 0, rd 186,
>> flush 0, corrupt 0, gen 0
>> [Wed Jan 27 13:05:23 2016]  sdc: sdc1
>> [Wed Jan 27 13:05:25 2016]  sdc: sdc1
>> [Wed Jan 27 13:08:37 2016] BTRFS: dev_replace from /dev/sdb1 (devid 2)
>> to /dev/sdc1 started
>> [Wed Jan 27 16:34:49 2016] BTRFS: dev_replace from /dev/sdb1 (devid 2)
>> to /dev/sdc1 finished
>>
>> Btrfs fi show:
>> warning, device 3 is missing
>> warning, device 3 is missing
>> warning devid 3 not found already
>> Label: none  uuid: 490b8b7c-59c4-45dc-ac63-6a90f0966776
>>          Total devices 2 FS bytes used 1.45TiB
>> 		devid    1 size 1.82TiB used 1.52TiB path /dev/sda1
>> 		*** Some devices missing
>>
>> I haven't rebooted or remounted yet, so I'm curious if this is a bug,
>> a normal thing that is fixed by a reboot, or what.
>
> Got the opportunity to reboot, and things appear to be OK. Still, I
> would expect replace to work without requiring a reboot, so this may
> still be a bug. I'm running a scrub to verify things, and once that
> completes I'll do the second replace and see if I encounter the same
> problem.
That is unusual, it's supposed to work without needing a reboot or 
rescan, so I think you may have found a bug.
