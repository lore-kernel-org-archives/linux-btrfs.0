Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55807 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755907AbaF1SPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 14:15:43 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:50777 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1X0xA6-002RxH-8y
	for linux-btrfs@vger.kernel.org; Sat, 28 Jun 2014 12:15:42 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID1 3+ drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1403953457.BS00mAsj6N@xev>
Date: Sat, 28 Jun 2014 12:15:42 -0600
Message-Id: <DC109384-A75B-4469-B043-4A6935BF9A76@colorremedies.com>
References: <CAA8KC9J4M+Vsk0Wjs+vbgQVrcgMfznwE9WwqapHKhH82g_-hBA@mail.gmail.com> <10572318.CAuhDIAMDU@xev> <pan$b64f$b234655e$f16fd679$34acdd2f@cox.net> <1403953457.BS00mAsj6N@xev>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 28, 2014, at 12:28 AM, Russell Coker <russell@coker.com.au> wrote:
> 
>> Tho if you ran a md/dmraid level scrub often enough, and then ran a btrfs
>> scrub on top, one could be /reasonably/ assured of freedom from lower
>> level corruption.
> 
> Not at all.  Linux software RAID scrub will copy data from one disk to the 
> other.  

md supports two kinds of scrub: check and repair. Check is the same as btrfs read-only scrub with -r option.

> It may copy from the good disk to the bad or from the bad disk to the 
> good - and it won't know which it's doing.

Yes.

> Also last time I checked a scrub of Linux software RAID-1 still reported large 
> multiples of 128 sectors mismatching in normal operation.  So you won't even 
> know if a disk is returning bogus data unless the bad data is copied to the 
> good disk and exposed to BTRFS.

For raid1,raid10 you need to zero the drives or you will get mismatches. And swap partition or swap file on an md device will also cause mismatches. Mismatches on raid1,10 are much less likely for other types of files, but man 4 md does say it's possible so mismatch_cnt isn't perfectly reliable on raid1,10.


Chris Murphy