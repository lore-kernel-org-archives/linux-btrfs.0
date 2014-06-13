Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:57823 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaFMWPk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 18:15:40 -0400
Message-ID: <539B78F3.9070607@libero.it>
Date: Sat, 14 Jun 2014 00:19:31 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: R: Re: Slow startup of systemd-journal on BTRFS
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <pan$22693$6b452195$976b783a$e4956372@cox.net> <20140612232453.GR9508@dastard>
In-Reply-To: <20140612232453.GR9508@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave

On 06/13/2014 01:24 AM, Dave Chinner wrote:
> On Thu, Jun 12, 2014 at 12:37:13PM +0000, Duncan wrote:
>> Goffredo Baroncelli <kreijack@libero.it> posted on Thu, 12 Jun 2014
>> 13:13:26 +0200 as excerpted:
>>
>>>> systemd has a very stupid journal write pattern. It checks if there is
>>>> space in the file for the write, and if not it fallocates the small
>>>> amount of space it needs (it does *4 byte* fallocate calls!) and then
>>>> does the write to it.  All this does is fragment the crap out of the log
>>>> files because the filesystems cannot optimise the allocation patterns.
>>>
>>> I checked the code, and to me it seems that the fallocate() are done in
>>> FILE_SIZE_INCREASE unit (actually 8MB).
>>
>> FWIW, either 4 byte or 8 MiB fallocate calls would be bad, I think 
>> actually pretty much equally bad without NOCOW set on the file.
> 
> So maybe it's been fixed in systemd since the last time I looked.
> Yup:
> 
> http://cgit.freedesktop.org/systemd/systemd/commit/src/journal/journal-file.c?id=eda4b58b50509dc8ad0428a46e20f6c5cf516d58
> 
> The reason it was changed? To "save a syscall per append", not to
> prevent fragmentation of the file, which was the problem everyone
> was complaining about...

thanks for pointing that. However I am performing my tests on a fedora 20 with systemd-208, which seems have this change
> 
>> Why?  Because btrfs data blocks are 4 KiB.  With COW, the effect for 
>> either 4 byte or 8 MiB file allocations is going to end up being the 
>> same, forcing (repeated until full) rewrite of each 4 KiB block into its 
>> own extent.


I am reaching the conclusion that fallocate is not the problem. The fallocate increase the filesize of about 8MB, which is enough for some logging. So it is not called very often.

I have to investigate more what happens when the log are copied from /run to /var/log/journal: this is when journald seems to slow all.

I am prepared a PC which reboot continuously; I am collecting the time required to finish the boot vs the fragmentation of the system.journal file vs the number of boot. The results are dramatic: after 20 reboot, the boot time increase of 20-30 seconds. Doing a defrag of system.journal reduces the boot time to the original one, but after another 20 reboot, the boot time still requires 20-30 seconds more....

It is a slow PC, but I saw the same behavior also on a more modern pc (i5 with 8GB).

For both PC the HD is a mechanical one...

> 
> And that's now a btrfs problem.... :/

Are you sure ?

ghigo@venice:/var/log$ sudo filefrag messages
messages: 29 extents found

ghigo@venice:/var/log$ sudo filefrag journal/*/system.journal
journal/41d686199835445395ac629d576dfcb9/system.journal: 1378 extents found

So the old rsyslog creates files with fewer fragments. BTRFS (but it seems also xfs) for sure highlights more this problem than other filesystem. But also systemd seems to create a lot of extens.

BR
G.Baroncelli



> 
> Cheers,
> 
> Dave.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
