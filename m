Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38466 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaCPGGo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 02:06:44 -0400
Date: Sat, 15 Mar 2014 23:06:34 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140316060634.GN16946@merlins.org>
References: <1756989.4ep0Vdupld@tethys>
 <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
 <4448214.x9oPWjPhdL@quad>
 <1566234.HjNzCBAKa5@quad>
 <pan$86f37$20eb1911$444fa726$8400b046@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$86f37$20eb1911$444fa726$8400b046@cox.net>
Subject: Re: discard synchronous on most SSDs?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 15, 2014 at 11:26:27AM +0000, Duncan wrote:
> Chris Samuel posted on Sat, 15 Mar 2014 17:48:56 +1100 as excerpted:
> 
> > $ sudo smartctl --identify /dev/sdb | fgrep 'Trim bit in DATA SET
> > MANAGEMENT'
> >  169      0          1   Trim bit in DATA SET MANAGEMENT command
> >  supported
> > $
> > 
> > If that command returns nothing then it's not reported as supported (and
> > I've tested that).  You can get the same info with hdparm -I.
> 
> > My puzzle now is that I have two SSD drives that report supporting NCQ
> > TRIM (one confirmed via product info) but report only supporting SATA
> > 3.0 not 3.1.
> 
> My SATA 2.5 SSDs reported earlier, report support for it too, so it's 
> apparently not SATA 3.1 limited.  (Note that I'm simply grepping word 
> 169, in the command below.  Since word 169 is trim support...)
> 
> sudo smartctl --identify /dev/sda | grep '^ 169'
>  169      -     0x0001   Data Set Management support
>  169      0          1   Trim bit in DATA SET MANAGEMENT command supported
> 
> Either that or that feature bit simply indicates trim support, not NCQ 
> trim support.

Mmmh, so now I'm confused.

See this:

=== START OF INFORMATION SECTION ===
Device Model:     INTEL SSDSC2BW180A3L
Serial Number:    CVCV215200XU180EGN
LU WWN Device Id: 5 001517 bb28c5317
Firmware Version: LE1i
User Capacity:    180,045,766,656 bytes [180 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 3.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar 15 15:49:06 2014 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

polgara:/usr/src# smartctl --identify /dev/sda | grep '^ 169'
 169      -     0x0001   Data Set Management support
 169      0          1   Trim bit in DATA SET MANAGEMENT command supported

This is a super old SSD from 3 years ago. Clearly it can't support
synchronous dicard, right?

Yet, deleting a kernel tree also takes 1.5 seconds:
polgara:/usr/src# time rm -rf linux-3.14-rc5/
real    0m1.441s
user    0m0.048s
sys     0m1.352s


So maybe it's not the data level, but just the value of 169?

Either way, this SSD is more than 2 years old, maybe 3 actually.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
