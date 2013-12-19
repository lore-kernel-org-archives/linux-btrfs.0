Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58125 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3LSTlF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 14:41:05 -0500
Received: by mail-pd0-f176.google.com with SMTP id w10so1528335pde.35
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 11:41:04 -0800 (PST)
Message-ID: <52B34BCE.2000409@gmail.com>
Date: Thu, 19 Dec 2013 11:41:02 -0800
From: Chris Kastorff <encryptio@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
References: <52B2BBE1.8090306@gmail.com> <pan$a2b51$7fd8f776$b8dead2a$ea511250@cox.net> <52B3461A.4030300@gmail.com>
In-Reply-To: <52B3461A.4030300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> I'm using btrfs in data and metadata RAID10 on drives (not on md or any
>>> other fanciness.)
>>>
>>> I was removing a drive (btrfs dev del) and during that operation, a
>>> different drive in the array failed. Having not had this happen before,
>>> I shut down the machine immediately due to the extremely loud piezo
>>> buzzer on the drive controller card. I attempted to do so cleanly, but
>>> the buzzer cut through my patience and after 4 minutes I cut the power.
>>>
>>> Afterwards, I located and removed the failed drive from the system, and
>>> then got back to linux. The array no longer mounts ("failed to read the
>>> system array on sdc"), with nearly identical messages when attempted
>>> with -o recovery and -o recovery,ro.
>>
>> This may be a stupid question, but you're missing a drive so the 
>> filesystem will be degraded, but you didn't mention that in your mount 
>> options, so...
>>
>> Did you try mounting with -o degraded (possibly with recovery, etc, also, 
>> but just try -o degraded plus any normal options first)?
>>
> 
> I did not try degraded because I didn't remember that there were two
> different options for handling broken btrfs volumes.
> 
> mount -o degraded,ro yields:
> 
> btrfs: device label lake devid 11 transid 4893967 /dev/sda
> btrfs: allowing degraded mounts
> btrfs: disk space caching is enabled
> parent transid verify failed on 87601116364800 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116364800 (dev /dev/sdf
> sector 62986400)
> parent transid verify failed on 87601116381184 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116381184 (dev /dev/sdf
> sector 62986432)
> parent transid verify failed on 87601115320320 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601115320320 (dev /dev/sdf
> sector 62985896)
> parent transid verify failed on 87601116368896 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116368896 (dev /dev/sdf
> sector 62986408)
> parent transid verify failed on 87601116377088 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116377088 (dev /dev/sdf
> sector 62986424)
> btrfs: bdev (null) errs: wr 344288, rd 230234, flush 0, corrupt 0, gen 0
> btrfs: bdev /dev/sdm1 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> btrfs: bdev /dev/sdg errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> Failed to read block groups: -5
> btrfs: open_ctree failed
> 
> mount -o degraded,recovery,ro yields:
> 
> btrfs: device label lake devid 11 transid 4893967 /dev/sda
> btrfs: allowing degraded mounts
> btrfs: enabling auto recovery
> btrfs: disk space caching is enabled
> parent transid verify failed on 87601116798976 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116798976 (dev /dev/sdg
> sector 113318256)
> parent transid verify failed on 87601119379456 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601119379456 (dev /dev/sdg
> sector 113319456)
> parent transid verify failed on 87601116774400 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116774400 (dev /dev/sdg
> sector 113318208)
> parent transid verify failed on 87601119391744 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601119391744 (dev /dev/sdg
> sector 113319480)
> parent transid verify failed on 87601116778496 wanted 4893969 found 4893913
> btrfs read error corrected: ino 1 off 87601116778496 (dev /dev/sdg
> sector 113318216)
> parent transid verify failed on 87601116786688 wanted 4893969 found 4893849
> btrfs read error corrected: ino 1 off 87601116786688 (dev /dev/sdg
> sector 113318232)
> btrfs: bdev (null) errs: wr 344288, rd 230234, flush 0, corrupt 0, gen 0
> btrfs: bdev /dev/sdm1 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> btrfs: bdev /dev/sdg errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> parent transid verify failed on 87601111515136 wanted 4893968 found 4893913
> btrfs read error corrected: ino 1 off 87601111515136 (dev /dev/sdg
> sector 113315616)
> parent transid verify failed on 87601111523328 wanted 4893968 found 4893913
> btrfs read error corrected: ino 1 off 87601111523328 (dev /dev/sdg
> sector 113315632)
> parent transid verify failed on 87601111535616 wanted 4893968 found 4893913
> btrfs read error corrected: ino 1 off 87601111535616 (dev /dev/sdg
> sector 113315656)
> parent transid verify failed on 87601111556096 wanted 4893968 found 4893913
> btrfs read error corrected: ino 1 off 87601111556096 (dev /dev/sdg
> sector 113315696)
> Failed to read block groups: -5
> btrfs: open_ctree failed
> 

I should also mention that the "corrupt 4" errs on /dev/sdm1 and
/dev/sdg are there from an earlier btrfs extent corruption bug, and do
not exist on the filesystem anymore (a scrub hours before the device
deletion completed with 0 errors.)
