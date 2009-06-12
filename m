From: Michael Raskin <a0091f122@rambler.ru>
Subject: Re: cleanup after a small data loss on incorrect shutdown.
Date: Fri, 12 Jun 2009 15:08:58 +0400
Message-ID: <4A32374A.6080900@rambler.ru>
References: <4A30FC2E.3030804@rambler.ru> <20090612105332.GG3834@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Michael Raskin <a0091f122@rambler.ru>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090612105332.GG3834@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
>> 	2. I found a file which is listed in the directory, but stat on it
>> returns "No such file or directory". Certainly, rm and unlink cannot
>> remove it. The partition has 14G in use. What can I do to provide a
>> useful piece of FS structure information? How can I remove the file
>> afterwards.
> 
> I'd say to send us the btrfsck output, it will help answer these
> questions.

Oh, easily. "Bad block <number way beyond partition block count>".
That's all. Reading one of the damaged file actually returned
"Input/output error" - probably it tried to read beyond end-of-device. I
 had to kill this file (practical testing means that to continue to use
my notebook normally I had to nuke the damaged file and get intact
copies). The "no such file except in readdir" is still there right now.

>> 	3. On a 30G partition with 14G used btrfsck was left overnight. It has
>> neither finished nor printed any meaningful request for interaction. Is
>> it normal?
> 
> Definitely not ;)  You can check with vmstat to see if btrfsck is
> actually doing anything, but it sounds like you hit a bug.  Which
> version of the kernel and tools are you using?

v0.18 release tools. 2.6.30-rc8 kernel. (It seems to include everything
before newformat patches). "top" said 99% of single-core Celeron was
used by btrfsck. I didn't run vmstat, but I remember that e2fsck random
reads would make much more noise (and for linear reading it took way too
much time).

