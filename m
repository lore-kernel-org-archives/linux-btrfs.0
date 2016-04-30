Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:56779 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbcD3NMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Apr 2016 09:12:17 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Roman Mamedov <rm@romanrm.net>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Uncorrectable errors after rebooting with Magic Sysrq Keys
Date: Sat, 30 Apr 2016 15:11:58 +0200
MIME-Version: 1.0
Message-ID: <b0bceaf1-b5a2-47b4-8f8b-a06af171cfbc@linuxsystems.it>
In-Reply-To: <e359750f-9fbe-46d5-b16e-adc83539722b@linuxsystems.it>
References: <b4f09d8b-baac-4182-81b1-1ba9f5e4195b@linuxsystems.it>
 <5710B4B8.9020002@cn.fujitsu.com>
 <30940bf0-924b-4ad7-a3d8-24b980ba46f4@linuxsystems.it>
 <20160415215839.7754f866@natsu>
 <e359750f-9fbe-46d5-b16e-adc83539722b@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Finally my external drive arrived and I've been able to make a backup and 
try btrfs check --repair.
Unfortunately btrfs check --repair got stuck in an infinite loop like this 
one (https://www.spinics.net/lists/linux-btrfs/msg54146.html) and after 
several hours of looping and several Gigabytes of logs I had to kill it, 
which gave me a completely fucked fs.
I still have backup images, so I can restore the old state and try again 
with updated tools (I used latest btrfs-progs 4.5.1, but I also tried 
4.4.1).
For those who didn't read the whole thread I can mount the fs, but it hangs 
while trying to read certain files and sometimes it remounts read-only. I'm 
pretty sure the culprit was a bug in 4.6-rc because problems started 
roughly after upgrading. Disk (an SSD) is fine. The fs is on top of 
dm-crypt and I always mounted it with 
"rw,relatime,ssd,space_cache,discard,compress=lzo,autodefrag".

You can find the whole logs here: 
https://drive.google.com/open?id=0Bwe9Wtc-5xF1Z2YwN1Y4U0ROSUU

01_scrub is the scrub output
02_check is the btrfs check output (14MB)
03_repair_short is the btrfs check --repair output truncated to 14MB

I hope someone will be able to help me recover my data, otherwise I will 
have to backup just the most important files and reinstall the whole system 
from scratch. Mounting the fs and doing a backup with cp -a wasn't a viable 
solution because it got stuck after several GBs.

Niccolò

P.S.
I changed my spf/dkim/dmarc settings, this email should no longer go into 
the spam folder, if it does please let me know. Thanks.
