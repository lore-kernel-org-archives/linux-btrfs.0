Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33980 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbcB0DDF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 22:03:05 -0500
Date: Fri, 26 Feb 2016 19:03:04 -0800
From: Marc MERLIN <marc@merlins.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160227030304.GC5286@merlins.org>
References: <20160227023938.GB5286@merlins.org> <20160227024533.GB11954@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160227024533.GB11954@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2016 at 06:45:34PM -0800, Liu Bo wrote:
> On Fri, Feb 26, 2016 at 06:39:38PM -0800, Marc MERLIN wrote:
> > btrfs-tools 4.4-1
> > gargamel:~# uname -r
> > 4.4.2-amd64-i915-volpreempt-20160214bc2
> > 
> > 2 drive array stopped working after a crash/reboot. Check --repair finds nothing wrong with it:
> > 
> > gargamel:~# btrfs check --repair /dev/mapper/raid0d1
> > enabling repair mode
> > Checking filesystem on /dev/mapper/raid0d1
> > UUID: 01334b81-c0db-4e80-92e4-cac4da867651
> > checking extents
> > Fixed 0 roots.
> > checking free space cache
> > cache and super generation don't match, space cache will be invalidated
> > checking fs roots
> > checking csums
> > checking root refs
> > found 1201345524312 bytes used err is 0
> > total csum bytes: 1165124220
> > total tree bytes: 8258322432
> > total fs tree bytes: 5574197248
> > total extent tree bytes: 1020428288
> > btree space waste bytes: 1902023247
> > file data blocks allocated: 1193398628352
> >  referenced 1209324777472
> > gargamel:~# mount /var/local/space
> > mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d1,
> >        missing codepage or helper program, or other error
> >        In some cases useful info is found in syslog - try
> >        dmesg | tail  or so
> > [ 8200.511021] BTRFS info (device dm-6): disk space caching is enabled
> > [ 8200.533030] BTRFS: failed to read the system array on dm-6
> > [ 8200.582097] BTRFS: open_ctree failed
> 
> Does 'btrfs dev scan' help?
 
Oh my, it does...
gargamel:~# btrfs dev scan
Scanning for Btrfs filesystems
gargamel:~# mount /var/local/space

[14477.028083] BTRFS: device label btrfs_space devid 2 transid 776784 /dev/mapper/raid0d2
[14500.262307] BTRFS info (device dm-7): disk space caching is enabled
[14504.042485] BTRFS: checking UUID tree

Err, I'm very perplexed now. I already have a scan in my boot process after device decrypts. 
Somehow it saw one of my 2 devices, but not the other one?

I'm looking at my boot:
[  112.063677] BTRFS: device label btrfs_space devid 1 transid 776782 /dev/mapper/raid0d1
[  112.090192] BTRFS info (device dm-6): disk space caching is enabled
[  112.111740] BTRFS: failed to read the system array on dm-6
[  112.160047] BTRFS: open_ctree failed
[  112.269710] BTRFS info (device dm-6): disk space caching is enabled
[  112.291430] BTRFS: failed to read the system array on dm-6
[  112.320104] BTRFS: open_ctree failed

So dm-6 is: raid0d1 -> ../dm-6

So, raid0d1 had an issue, btrfs check didn't really report any, for some unknown 
reason this caused raid0d2 not to be scanned, and in turn this caused
mounting that filesystem to fail?

Or did btrfs check actually fix something that I missed?
Any why would scan have missed raid0d2 the first time around?

Is it complaining that it can't read btrfs structures from raid0d1 because raid0d2
wasn't known yet? I'm not too sure what open_ctree means in that context.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
