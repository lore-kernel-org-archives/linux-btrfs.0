Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3K1RhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 12:37:21 -0500
Date: Thu, 28 Nov 2013 18:37:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: NMI from btrfs cron jobs in 3.11.6
Message-ID: <20131128173718.GK25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201311140145.29255.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201311140145.29255.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 01:45:29AM +1100, Russell Coker wrote:
> Nov 14 00:00:01 workstation /USR/SBIN/CRON[30993]: (root) CMD 
> (/usr/local/sbin/btrfs-make-snapshot minutes /home >> /var/log/snapshot.log)                                                                                                                                                                                                                      
> Nov 14 00:00:01 workstation /USR/SBIN/CRON[30994]: (root) CMD 
> (/usr/local/sbin/btrfs-make-snapshot days /home >> /var/log/snapshot.log)                                                                                                                                                                                                                         
> Nov 14 00:00:01 workstation /USR/SBIN/CRON[30995]: (root) CMD 
> (/usr/local/sbin/btrfs-remove-snapshots 100 100 /home/ / >> 
> /var/log/snapshot.log)
> 
> Below is a grep for NMI in my kernel message log.  I'm running Debian kernel 
> 3.11.6-2 on a quad-core AMD64 system.  Above is the relevant section of the 
> cron log.  It appears that running two scripts that create snapshots at the 
> same time as a script that removes maybe 97 snapshots causes an NMI.  I've 
> attached the kernel message log from today, I can give you logs from other 
> days if they are useful.

Snapshot deletion may touch a lot of data and some operations are slowed
down by that. This may trigger the warning

  INFO: task T blocked for more than 120 seconds

If there's no other crash (that would block the system indefinitely),
the warnings disappear. According to the grep output, the warnings
happen at the same daytime, so this is likely the system overload
reason.

You may want to follow the warning's sugeestion:

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message

or increase the timeout.

david
