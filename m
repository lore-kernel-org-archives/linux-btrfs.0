Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm31.bullet.mail.gq1.yahoo.com ([98.136.217.14]:26352 "HELO
	nm31.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751777Ab2JANe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Oct 2012 09:34:56 -0400
Message-ID: <50699A40.2030603@yahoo.com.br>
Date: Mon, 01 Oct 2012 10:27:28 -0300
From: Cesar Inacio Martins <cesar_inacio_martins@yahoo.com.br>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Tunning - cache write (database)
References: <1349098002.208.YahooMailNeo@web31801.mail.mud.yahoo.com>
In-Reply-To: <1349098002.208.YahooMailNeo@web31801.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

First, sorry if this isn't the place to get this kind of help...
If not, I appreciate some link , forum, where I can try get some answers...

My problem:
* Using btrfs + compression , flush of 60 MB/s take 4 minutes....
(on this 4 minutes they keep constatly I/O of +- 4MB/s no disks)
(flush from Informix database)

The enviroment :
* Virtualized environment
* OpenSuse 12.1 64bits, running over VmWare ESXi 5
* Btrfs version : btrfsprogs-0.19-43.1.2.x86_64
* Kernel : Linux jdivm06 3.1.10-1.16-desktop #1 SMP PREEMPT Wed Jun 27 
05:21:40 UTC 2012 (d016078) x86_64 x86_64 x86_64 GNU/Linux
* The file system is used to keep the Informix database data (chunks).
* 8 cores (intel i7) , so,  all btrfs threads able to work parallel.

The file system mount :
   root@jdivm06:/proc/sys/fs# mount |grep ifx
   /dev/sdb1 on /ifxdados type btrfs 
(rw,nosuid,nodev,noexec,noatime,compress=zlib,space_cache)

My question, what I believed will help to avoid this long flush :
* Have some way to force this flush all in memory cache and then use the 
btrfs background process to flush to disk ...
   Security and recover aren't a priority for now, because this is part 
of a database bulkload ...after finish , integrity will be desirable 
(not a obligation, since this is a test environment)

For now, performance is the mainly requirement...

A plus :
root@jdivm06:/proc/sys/fs# cat /proc/sys/vm/dirty_ratio
50
root@jdivm06:/proc/sys/fs# cat /proc/sys/vm/dirty_background_ratio
10

Thanks
Cesar


