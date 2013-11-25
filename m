Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64900 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3KYMZ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 07:25:28 -0500
Received: by mail-ie0-f171.google.com with SMTP id ar20so6859356iec.30
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 04:25:27 -0800 (PST)
Message-ID: <529341B5.8030600@gmail.com>
Date: Mon, 25 Nov 2013 07:25:25 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Jim Salter <jim@jrs-s.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs scrub ioprio
References: <5292C7F7.8010200@jrs-s.net>
In-Reply-To: <5292C7F7.8010200@jrs-s.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-24 22:45, Jim Salter wrote:
> TL;DR scrub's ioprio argument isn't really helpful - a scrub murders
> system performance til it's done.
> 
> My system:
> 
> 3.11 kernel (from Ubuntu Saucy)
> btrfs-tools from 2013-07 (from Debian Sid)
> Opteron 8-core CPU
> 32GB RAM
> 4 WD 1TB Black drives in a btrfs RAID10 (data and metadata).
> 
> iotop shows that the idle priority really is set on the processes:
> 
>>> me@box:~$ sudo iotop -bn 1 | grep idle
>>> 28326 idle root       82.06 M/s    0.00 B/s  0.00 %  0.00 % btrfs
> scrub start -c3 /data
>>> 28327 idle root       89.30 M/s    0.00 B/s  0.00 %  0.00 % btrfs
> scrub start -c3 /data
>>> 28329 idle root       84.47 M/s    0.00 B/s  0.00 %  0.00 % btrfs
> scrub start -c3 /data
>>> 28331 idle root       79.64 M/s    0.00 B/s  0.00 %  0.00 % btrfs
> scrub start -c3 /data
> 
> But unfortunately, despite being on "idle" priority, the scrub is
> KILLING system performance. This is one of my eight CPU cores. Any core
> with a significant amount of non-idle time has three to four times as
> much wait time as it does user/system time. Brutal:
> 
>>> Cpu4  :  4.4%us, 16.1%sy,  0.0%ni, 12.4%id, 67.2%wa, 0.0%hi, 
> 0.0%si,  0.0%st
> 
> Anybody got any ideas that might make the scrub go a little less...
> enthusiastically... and leave the system more usable?  Right now, with a
> scrub running, the system is so burdened that it may take as much as two
> to three seconds to so much as display a manpage. God help you if you
> want to, say, log into a VM running on the system. It'll GET there, but
> it'll look like it's iSCSI on TCP over carrier pigeon.
A large part of this might be that the idle I/O scheduling class does
not put a limit on bandwidth utilization, so even though it is using
'idle' bandwidth, it is actually using all of the bandwidth that is
'unused' by other tasks, which kills your disk latency.  As i see it,
the best option is probably either:
1. set up something to suspend the scrub if there are other pending I/O
requests (which would probably need kernel support)
2. allow the user to set a reasonable I/O bandwidth limit on the scrub
processes (you could already do this with the BIO cgroup, but it would
be nice to not need that to be compiled into the kernel to have this happen)

