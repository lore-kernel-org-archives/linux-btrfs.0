Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42623 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab3JWE25 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 00:28:57 -0400
Date: Wed, 23 Oct 2013 13:28:44 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131023132844.2a206238@virtall.com>
In-Reply-To: <20131022162019.GY1032@twin.jikos.cz>
References: <20131021122123.43b3aa50@virtall.com>
	<20131021151032.708cc7d2@virtall.com>
	<20131021125317.GK1032@twin.jikos.cz>
	<20131022025025.169941de@virtall.com>
	<20131022154619.GW1032@twin.jikos.cz>
	<20131023010411.42d30c97@virtall.com>
	<20131022162019.GY1032@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Oct 2013 18:20:19 +0200
David Sterba <dsterba@suse.cz> wrote:

> > However, it's not possible to work with this system via SSH, because
> > these keep popping up few times every minute:
> 
> Probably only some of the files that get accessed during ssh login is
> corrupted, but the scrub does not get far enough to let you know the
> filenames. You can try to look into 'lsof' output which files are open
> by sshd or it's children.

It's not the case.
Files in btrfs mount are not accessed in any way - the scrub was
started after restart, and there is no way anything on this system can
accidentally access data there. This is further confirmed by lsof
output.


> >  kernel:[22219.117012] BUG: soft lockup - CPU#2 stuck for 23s!
> > [btrfs:5673] kernel:[22247.100515] BUG: soft lockup - CPU#0 stuck
> > for 23s! [btrfs:5674] kernel:[22247.100519] BUG: soft lockup -
> > CPU#2 stuck for 23s! [btrfs:5673]
> 
> Cpus 0 and 2 are stuck and every other attempt to access the broken
> files will pin another cpu.

Scrub was running for some time; after scrubbung about 2.8 TB, the
system was so slow, that it was barely possible to launch any command.

"reboot" issued via ssh took ~8 hours to execute.

A new scrub started after the reboot immediately begins to show "BUG:
soft lockup - CPU#2 stuck for 23s!".

Anyway, it is RAID-1 - I would expect the scrub to either correct
corrupt data (from a copy on the other disk), or mark it as invalid
(both copies corrupt), but not "nearly hang" the server, or?


-- 
Tomasz Chmielewski
http://wpkg.org
