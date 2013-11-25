Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:43855 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab3KYDym (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 22:54:42 -0500
Received: from [192.168.100.50] (cpe-024-088-095-145.sc.res.rr.com [24.88.95.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 68D7FD2B1
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Nov 2013 22:46:00 -0500 (EST)
Message-ID: <5292C7F7.8010200@jrs-s.net>
Date: Sun, 24 Nov 2013 22:45:59 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs scrub ioprio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR scrub's ioprio argument isn't really helpful - a scrub murders 
system performance til it's done.

My system:

3.11 kernel (from Ubuntu Saucy)
btrfs-tools from 2013-07 (from Debian Sid)
Opteron 8-core CPU
32GB RAM
4 WD 1TB Black drives in a btrfs RAID10 (data and metadata).

iotop shows that the idle priority really is set on the processes:

 >> me@box:~$ sudo iotop -bn 1 | grep idle
 >> 28326 idle root       82.06 M/s    0.00 B/s  0.00 %  0.00 % btrfs 
scrub start -c3 /data
 >> 28327 idle root       89.30 M/s    0.00 B/s  0.00 %  0.00 % btrfs 
scrub start -c3 /data
 >> 28329 idle root       84.47 M/s    0.00 B/s  0.00 %  0.00 % btrfs 
scrub start -c3 /data
 >> 28331 idle root       79.64 M/s    0.00 B/s  0.00 %  0.00 % btrfs 
scrub start -c3 /data

But unfortunately, despite being on "idle" priority, the scrub is 
KILLING system performance. This is one of my eight CPU cores. Any core 
with a significant amount of non-idle time has three to four times as 
much wait time as it does user/system time. Brutal:

 >> Cpu4  :  4.4%us, 16.1%sy,  0.0%ni, 12.4%id, 67.2%wa, 0.0%hi,  
0.0%si,  0.0%st

Anybody got any ideas that might make the scrub go a little less... 
enthusiastically... and leave the system more usable?  Right now, with a 
scrub running, the system is so burdened that it may take as much as two 
to three seconds to so much as display a manpage. God help you if you 
want to, say, log into a VM running on the system. It'll GET there, but 
it'll look like it's iSCSI on TCP over carrier pigeon.
