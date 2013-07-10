Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58694 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab3GJMmQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 08:42:16 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 776327C0432
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Jul 2013 06:42:16 -0600 (MDT)
Date: Wed, 10 Jul 2013 08:42:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Russell Coker <russell@coker.com.au>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: performance loss with lots of snapshots
Message-ID: <20130710124214.GA30450@localhost.localdomain>
References: <201307101254.44583.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201307101254.44583.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 12:54:44PM +1000, Russell Coker wrote:
> There are two uses of backups, recovering from user errors (IE deleting the 
> wrong file) and recovering from sysadmin errors or hardware failures (IE disks 
> are dead or wiped).  For the former use I'm mainly using BTRFS snapshots on 
> many systems.
> 
> A problem that I have had on more than a few occasions (most recently on the 
> latest Debian 3.9 kernel) is of severe performance loss.  A few days ago this 
> happened on a workstation running an Intel 120G SSD device for the root 
> filesystem which was being used for basic workstation tasks (kmail, GIMP, 
> OpenOffice, etc).  The /home and / subvols had about 400 snapshots between 
> them (which doesn't seem like a huge number) when the system became unusably 
> slow while running a scrub from a cron job, programs like GIMP became stuck in 
> D state.  The system in question has 8G of RAM and very light load, there 
> shouldn't be any reason for it not giving good performance while the scrub was 
> in progress and it definitely should have performed well when the scrub was 
> cancelled.  But it didn't return to decent performance until I deleted about 
> 300 snapshots.
> 
> This has happened to me often enough that I can probably reproduce it on a VM.  
> What kernel should I use for such tests?
> 
> If I get a virtual machine in a state where it has ongoing performance 
> problems would any of the BTRFS developers like root access to debug it?
> 

There is a memory leak-ish with scrub where it doesn't free up the csums it's
looked up until after its done scrubbing an area which can lead to OOM's or
degraded performance.  Btrfs-next has the fix as well as the pull request that
just went to Linus, so pick which one you want and run again and see if that
helps?  I imagine you are probably seeing two things, first that oom'ish
behavior and then some other performance gotcha with a fair number of snapshots,
but just in case.  Thanks,

Josef
