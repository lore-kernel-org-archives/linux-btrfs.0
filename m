Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:47349 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaINOxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Sep 2014 10:53:16 -0400
Received: from [192.168.9.10] (52-dom-15.acn.waw.pl [85.222.54.52])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id 1C77A525BAA
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Sep 2014 16:53:14 +0200 (CEST)
Message-ID: <5415ABE4.7060800@siedziba.pl>
Date: Sun, 14 Sep 2014 16:53:24 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 failure and recovery
References: <000f01cfce67$9e9015f0$dbb041d0$@csy.ca> <20140912104732.GO5783@carfax.org.uk> <5415083C.4050404@siedziba.pl> <20140914044405.GU5783@carfax.org.uk>
In-Reply-To: <20140914044405.GU5783@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14.09.2014 06:44, Hugo Mills wrote:
>> I've done this before, by accident (pulled the wrong drive, reinserted
>> it). You can fix it by running a scrub on the device (btrfs scrub
>> start /dev/ice, I think).
> Checksums are done for each 4k block, so the increase in probability 
> of a false negative is purely to do with the sher volume of data. 
> "Weak" checksums like the CRC32 that btrfs currently uses are indeed 
> poor for detecting malicious targeted attacks on the data, but for 
> random failures, such as a disk block being unreadable and returning 
> zeroes or having bit errors, the odds of identifying the failure are 
> still excellent. 

I don't require "probably the universe will end sooner" kind of odds, 
but I would at least like "better than winning the lottery" odds. Once 
there are thousands of blocks to fix, the odds aren't that great: 1 / 
2^32 * 10 000 =~ 1 / 430 000

I wouldn't feel confident enough to add the disk back and let btrfs fix 
it. I'd rather wipe the FS on it and do the "replace missing".

>> Additionally, nocow files are not checksummed. They will not be 
>> corrected
>> and may return good data or random garbage, depending on which mirror is
>> accessed.
>     Yes, this is a trade-off that you have to make for your own
> use-case and happiness. For some things (like a browser cache), I'd be
> happy with losing the checksums.

The point is, if I add a drive with old contents back, I will probably 
have to delete all nocow files. Cause I'm not aware of any tool that can 
compare both mirrors, and tell me which files are identical on both, and 
which are different. Scrub will not detect them, as it works separately 
on each device, and doesn't compare one mirror to the other.

If I don't delete nocow files, I may get intermittent failures, like my 
browser randomly not loading some pages, and wonder what's going on.

On a multi user system, I risk exposing sensitive data to all users 
having nocow files, or access to nocow files.

Thus I think this practice is bad, dangerous, and I would advice against 
doing that. I'd also like btrfs to reject devices with old content by 
default.
