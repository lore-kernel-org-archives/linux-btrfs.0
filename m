Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-cletus.wadns.net ([41.185.62.38]:56957 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752305AbaKUHFk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 02:05:40 -0500
Message-ID: <546EE43C.7020900@swiftspirit.co.za>
Date: Fri, 21 Nov 2014 09:05:32 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za> <546AF572.2020101@swiftspirit.co.za> <20141121045801.GS17395@hungrycats.org>
In-Reply-To: <20141121045801.GS17395@hungrycats.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/21 06:58, Zygo Blaxell wrote:
> You have one reallocated sector, so the drive has lost some data at some
> time in the last 49000(!) hours.  Normally reallocations happen during
> writes so the data that was "lost" was data you were in the process of
> overwriting anyway; however, the reallocated sector count could also be
> a sign of deteriorating drive integrity.
>
> In /var/lib/smartmontools there might be a csv file with logged error
> attribute data that you could use to figure out whether that reallocation
> was recent.
>
> I also notice you are not running regular SMART self-tests (e.g.
> by smartctl -t long) and the last (and first, and only!) self-test the
> drive ran was ~12000 hours ago.  That means most of your SMART data is
> about 18 months old.  The drive won't know about sectors that went bad
> in the last year and a half unless the host happens to stumble across
> them during a read.
>
> The drive is over five years old in operating hours alone.  It is probably
> so fragile now that it will break if you try to move it.
All interesting points. Do you schedule SMART self-tests on your own 
systems? I have smartd running. In theory it tracks changes and sends 
alerts if it figures a drive is going to fail. But, based on what you've 
indicated, that isn't good enough.

> WARNING: errors detected during scrubbing, corrected.
> [snip]
> scrub device /dev/sdb2 (id 2) done
> 	scrub started at Tue Nov 18 03:22:58 2014 and finished after 2682 seconds
> 	total bytes scrubbed: 189.49GiB with 5420 errors
> 	error details: read=5 csum=5415
> 	corrected errors: 5420, uncorrectable errors: 0, unverified errors: 164
> That seems a little off.  If there were 5 read errors, I'd expect the drive to
> have errors in the SMART error log.
>
> Checksum errors could just as easily be a btrfs bug or a RAM/CPU problem.
> There have been a number of fixes to csums in btrfs pulled into the kernel
> recently, and I've retired two five-year-old computers this summer due
> to RAM/CPU failures.
The difference here is that the issue only affects the one drive. This 
leaves the probable cause at:
- the drive itself
- the cable/ports

with a negligibly-possible cause at the motherboard chipset.


-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

