Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56702 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752030AbaCNVn7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 17:43:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: discard synchronous on most SSDs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140314051750.GY6143@merlins.org>
Date: Fri, 14 Mar 2014 15:44:01 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <0505738E-9D6B-49C7-9BEC-27C6F1C7139D@colorremedies.com>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <3438733.p6vCjojJlH@merkaba> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 13, 2014, at 11:17 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Thu, Mar 13, 2014 at 09:39:02PM -0600, Chris Murphy wrote:
>> 
>> On Mar 13, 2014, at 8:11 PM, Marc MERLIN <marc@merlins.org> wrote:
>> 
>>> On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
>>>> discard is, except on the very latest hardware, a synchronous command
>>>> (it's a limitation of the SATA standard), and therefore results in
>>>> very very poor performance.
>>> 
>>> Interesting. How do I know if a given SSD will hang on discard?
>>> Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)
>> 
>> smartctl -a or -x will tell you what SATA revision is in place. The queued trim support is in SATA Rev 3.1. I'm not certain if this requires only the drive to support that revision level, or both controller and drive.
> 
> I'm not sure I'm seeing this, which field is that?
> 
> === START OF INFORMATION SECTION ===
> Device Model:     Samsung SSD 840 EVO 1TB
> Serial Number:    S1D9NEAD934600N
> LU WWN Device Id: 5 002538 85009a8ff
> Firmware Version: EXT0BB0Q
> User Capacity:    1,000,204,886,016 bytes [1.00 TB]
> Sector Size:      512 bytes logical/physical
> Device is:        Not in smartctl database [for details use: -P showall]
> ATA Version is:   8
> ATA Standard is:  ATA-8-ACS revision 4c
> Local Time is:    Thu Mar 13 22:15:14 2014 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled


After ATA Version for me.

$ smartctl -a /dev/disk0
smartctl 6.1 2013-03-16 r3800 [x86_64-apple-darwin12.3.0] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     SAMSUNG SSD 830 Series
Serial Number:    S0Z4NEAC933856
LU WWN Device Id: 5 002538 043584d30
Firmware Version: CXM03B1Q
User Capacity:    256,060,514,304 bytes [256 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 T13/2015-D revision 2
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Mar 14 15:37:07 2014 MDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

The Samsung hardware by and large is fairly well behaved with discard in my experience. But it does really depend a lot on the workload. I'd notice occasional random freezes for a couple of seconds when I had it enabled in OS X (totally different animal from the kernel up), nothing severe. But it was annoying enough I disabled it, and the problem went away. Apple doesn't enable trim by default on non-Apple SSD's still, so the idea that "everyone else" is doing this isn't true. The Windows implementation is rather complex, and also isn't always used contrary to what's been reported (on the everybody panic or get mad NOW type web sites).

If you want to be conservative about it, I'd say just manually run fstrim when the system is idle. Do that once a week or two. Chron job it if you want.


Chris Murphy