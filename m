Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60988 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3EQQz0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 12:55:26 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 45AAB7C04F9
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:55:26 -0600 (MDT)
Date: Fri, 17 May 2013 12:54:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel 3.8.8: btrfs still crashes on boot when it can't replay a
 log
Message-ID: <20130517165456.GH1765@localhost.localdomain>
References: <20130516150918.GB26762@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130516150918.GB26762@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 16, 2013 at 09:09:18AM -0600, Marc MERLIN wrote:
> I've reported this bug a few times over different kernel versions over the
> last year now, and unfortunately it's still not fixed as of 3.8 (yes, I know
> 3.9 is out, I'm just about to switch).
> 
> What happens as far as I know:
> I have btrfs on top of dmcrypt on an SDD.
> 
> The SSD on occasion seems to just hang, so I have to power cycle my laptop.
> I can't say how much the SSD did and did not write before stopping to work.
> 
> Then, maybe one time out of 2 or 3, btrfs crashes when I reboot and it tries 
> to replay the log.
> 
> I'm then forced to do this from emergency boot media:
> 
> gandalfthegreat:~# btrfs-zero-log /dev/mapper/root                                                        
> Check tree block failed, want=64855564288, have=14954667565421255623                                      
> Check tree block failed, want=64855564288, have=14954667565421255623                                      
> Check tree block failed, want=64855564288, have=7474503720151340134                                       
> Check tree block failed, want=64855564288, have=14954667565421255623                                      
> Check tree block failed, want=64855564288, have=14954667565421255623                                      
> read block failed check_tree_block   
> 
> The last bits of the crash before I zero the log:
> http://marc.merlins.org/tmp/btrfs-3.8.8.jpg
> 
> Still issues with btrfs_numb_copies.
> 
> This has been going on for over a year now, not very pleasant :)
> 
> Is there no way you can corrupt logs in a test lab and reproduce this?
> 
> Or is it still known to happen due to missing code that decides whether a log is corrupt 
> and whether to discard it before the code reads it and crashes?
> 
> If so, could you add this to the list of things to fix to make btrfs a bit
> less scary to others? :)
> (and of course more production ready, this repeated problem would kill any
> server it happens on)
> 

This has been all fixed in 3.10.  Thanks,

Josef
