Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54884 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2KAQQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 12:16:08 -0400
Date: Thu, 1 Nov 2012 09:16:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: Sander <sander@humilis.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707 - FIXED
Message-ID: <20121101161606.GJ1644@merlins.org>
References: <E1TTCzR-0001nz-1p@gandalfthegreat.merlins.org> <20121030144914.GA18659@merlins.org> <20121029154713.GF8019@merlins.org> <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com> <20121029174802.GB7796@merlins.org> <20121030154608.GA19231@merlins.org> <20121031092440.GA31209@panda> <20121031154056.GE3290@merlins.org> <20121101105618.GA19415@panda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121101105618.GA19415@panda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 01, 2012 at 11:56:18AM +0100, Sander wrote:
> > For now, I'll stick with 3.5.3 for a while to make sure my drive is actually
> > ok (it seems to be afterall), and once I'm happy that it's the case, I'll go
> > back to 3.6.3 with serial console remote logging and try to capture the full
> > sata failure I got with 3.6.3.
> 
> Thanks for the info. You could put some load on the ssd to see if you
> can trigger an issue under 3.6.3(+) with btrfs filesystem scrub or
> badblocks (in the default non-destructive mode).

I'll try this in a few days when I've first comfirmed that my SSD is still
100% stable under 3.5.3 (so far it is).
After that, I'll go back to 3.6.3 and see what it takes to crash it.
But as per my original report and
http://marc.merlins.org/tmp/crash.jpg
this does look like a sata layer problem, which btrfs isn't responsible for.

Also there is still that unaddressed bug that when it does happen, btrfs
then can end up in a state where the filesystem is unmountable without
manually fixing it.
 
> Can you collect SMART data (with smartctl) from the ssd?

I did actually have a look, but to be honest, SSDs have pretty useless smart
data overall. Mine's likely a bit worse than the average even.

gandalfthegreat:~# smartctl -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.5.3-amd64-preempt-noide-20120903] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     OCZ-VERTEX4
Serial Number:    OCZ-26W4VJ3SP32E1WC2
LU WWN Device Id: 5 e83a97 59be3b57e
Firmware Version: 1.5
User Capacity:    512,110,190,592 bytes [512 GB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   9
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu Nov  1 09:14:43 2012 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00)	Offline data collection activity
					was never started.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      ( 249)	Self-test routine in progress...
					90% of test remaining.
Total time to complete Offline 
data collection: 		(    0) seconds.
Offline data collection
capabilities: 			 (0x1d) SMART execute Offline immediate.
					No Auto Offline data collection support.
					Abort Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					No Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x00)	Error logging NOT supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   0) minutes.
Extended self-test routine
recommended polling time: 	 (   0) minutes.

SMART Attributes Data Structure revision number: 18
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x0000   006   000   000    Old_age   Offline      -       6
  3 Spin_Up_Time            0x0000   100   100   000    Old_age   Offline      -       0
  4 Start_Stop_Count        0x0000   100   100   000    Old_age   Offline      -       0
  5 Reallocated_Sector_Ct   0x0000   100   100   000    Old_age   Offline      -       8
  9 Power_On_Hours          0x0000   100   100   000    Old_age   Offline      -       1210
 12 Power_Cycle_Count       0x0000   100   100   000    Old_age   Offline      -       240
232 Available_Reservd_Space 0x0000   100   100   000    Old_age   Offline      -       8019542246
233 Media_Wearout_Indicator 0x0000   099   000   000    Old_age   Offline      -       99

SMART Error Log not supported
Warning! SMART Self-Test Log Structure error: invalid SMART checksum.
SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


Device does not support Selective Self Tests/Logging

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
