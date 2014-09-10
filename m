Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:56615 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaIJSgr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 14:36:47 -0400
Message-ID: <54109BCD.5000106@inwind.it>
Date: Wed, 10 Sep 2014 20:43:25 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Bob Williams <linux@barrowhillfarm.org.uk>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk>
In-Reply-To: <541043B8.7010601@barrowhillfarm.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2014 02:27 PM, Bob Williams wrote:
> I have two 2TB disks formatted as a btrfs raid1 array, mirroring both
> data and metadata. Last night I started
> 
> # btrfs filesystem balance <path>


May be that I am missing something obvious, however I have to ask which 
would be the purpose to balance a two disks RAID1 system.
The balance command should move the data between the disks in order to
avoid some disk full and other empty; but this assume that there is a
not symmetrical uses of the disks. Which is not the case for a RAID1/two
disks system.

If the disk were more than two the situation would be completely different.
But Bob reports that the system is compose by two disks only.

> 
> and it is still running 18 hours later. This suggests that most stuff
> only gets written to one physical device, which in turn suggests that
> there is a risk of lost data if one physical device fails. Or is
> there something clever about btrfs raid that I've missed? I've used
> linux software raid (mdraid) before, and it appeared to write to both
> devices simultaneously.
> 
> Is it safe to interrupt [^Z] the btrfs balancing process?
> 
> As a rough guide, how often should one perform
> 
> a) balance b) defragment c) scrub
> on a btrfs raid setup?

*defrag
I don't have any hard rule for that. However I made a systemd unit
which defrags /var each day (for file bigger than 5M) . It helps a 
lot for some critical files like systemd journal and/or the 
apt-get/deb databases.
Time to time I defrag /usr, but without a rule.

*scrub
Regarding scrub, pay attention that some (consumer) disks are 
guarantee for a (not recoverable) error rate less than 1/10^14 [1] 
bit reads. 10^14 bit are something like 10TB. This means that if you 
read your system 5 times, you may got an error bit. I suppose 
that these are very conservative number, so the likelihood of an 
undetected error is (I hope)lower. But also I am inclined to think 
these number are evaluated in an ideal case (in term of temperature, 
voltage, vibration); this means that the true might be worse.

So if you compare these numbers with your average throughput, 
you can estimate which is the likelihood of an error. Pay attention
that a scrub job means read all your data: If you have 1T of data,
and you performs a scrub each week, in three months you reach the 10^14
bit reads.....

This explains the interest in higher redundancy level (raid 6 or more).
 
G.Baroncelli

[1] 
- http://www.wdc.com/wdproducts/library/SpecSheet/ENG/2879-771442.pdf
- http://forums.storagereview.com/index.php/topic/31688-western-digital-red-nas-hard-drive-review-discussion/
> 
> Bob -- To unsubscribe from this list: send the line "unsubscribe 
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
