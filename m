Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46297 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaCNFRu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 01:17:50 -0400
Date: Thu, 13 Mar 2014 22:17:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: discard synchronous on most SSDs?
Message-ID: <20140314051750.GY6143@merlins.org>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <3438733.p6vCjojJlH@merkaba> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 13, 2014 at 09:39:02PM -0600, Chris Murphy wrote:
> 
> On Mar 13, 2014, at 8:11 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
> >> discard is, except on the very latest hardware, a synchronous command
> >> (it's a limitation of the SATA standard), and therefore results in
> >> very very poor performance.
> > 
> > Interesting. How do I know if a given SSD will hang on discard?
> > Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)
> 
> smartctl -a or -x will tell you what SATA revision is in place. The queued trim support is in SATA Rev 3.1. I'm not certain if this requires only the drive to support that revision level, or both controller and drive.

I'm not sure I'm seeing this, which field is that?

=== START OF INFORMATION SECTION ===
Device Model:     Samsung SSD 840 EVO 1TB
Serial Number:    S1D9NEAD934600N
LU WWN Device Id: 5 002538 85009a8ff
Firmware Version: EXT0BB0Q
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4c
Local Time is:    Thu Mar 13 22:15:14 2014 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (15000) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 250) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  9 Power_On_Hours          -O--CK   099   099   000    -    2219
 12 Power_Cycle_Count       -O--CK   099   099   000    -    659
177 Wear_Leveling_Count     PO--C-   099   099   000    -    3
179 Used_Rsvd_Blk_Cnt_Tot   PO--C-   100   100   010    -    0
181 Program_Fail_Cnt_Total  -O--CK   100   100   010    -    0
182 Erase_Fail_Count_Total  -O--CK   100   100   010    -    0
183 Runtime_Bad_Block       PO--C-   100   100   010    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
190 Airflow_Temperature_Cel -O--CK   054   041   000    -    46
195 Hardware_ECC_Recovered  -O-RC-   200   200   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   100   100   000    -    0
235 Unknown_Attribute       -O--C-   099   099   000    -    35
241 Total_LBAs_Written      -O--CK   099   099   000    -    12186944165
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
