From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 29 Dec 2011 18:25:58 -0600 (CST)
Message-ID: <f246b736-54be-46d6-8944-701f3bd70c68@mail.placs.net>
References: <dc6ccf7d-261b-487c-966f-a7bcdd0439cc@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Phillip Susi <psusi@cfl.rr.com>,
	Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <dc6ccf7d-261b-487c-966f-a7bcdd0439cc@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

Actually, I seem to be having problems where my rsync script ends up hanging the system again.  It's pretty repeatable, and the system is completely frozen and I have to do a hard reboot.  Runs for a couple of hours and hangs the system every time.  Of course, I'm not doing anything special other than an rsync of compressed btrfs data and snapshots.  Well, that and my btrfs partitions are on external SATA port multipliers and btrfs is used to create a two drive RAID-0 for each partition (the source and the destination).  I tried the bwlimit switch on rsync, which seemed to allow it to go longer between crashes, but of course that just means I'm copying the data slower too....

I can't find anything in the usual logs.  Any suggestions?  I'm using CentOS 6.2 fully updated.

-BJ
