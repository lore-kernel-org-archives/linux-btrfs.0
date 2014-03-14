Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53268 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaCNT0I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 15:26:08 -0400
Date: Fri, 14 Mar 2014 12:26:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Samuel <chris@csamuel.org>, Duncan <1i5t5.duncan@cox.net>,
        Christopher Corsi <cjmovie@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: discard synchronous on most SSDs?
Message-ID: <20140314192605.GD6143@merlins.org>
References: <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk> <20140314021159.GQ18959@merlins.org> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org> <pan$667da$c4955705$c59674a0$a844850c@cox.net> <531C1CC4.701@gmail.com> <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com> <20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJvTjgh4+SW6qx_v2eaXYwOrNo8xK5L3gkS45yhXzvtJp954zw@mail.gmail.com> <pan$667da$c4955705$c59674a0$a844850c@cox.net> <5289248.oqpgSKG6td@quad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 14, 2014 at 12:07:54PM +0000, Duncan wrote:
> Marc MERLIN posted on Thu, 13 Mar 2014 22:17:50 -0700 as excerpted:
> 
> > On Thu, Mar 13, 2014 at 09:39:02PM -0600, Chris Murphy wrote:
> >> 
> >> On Mar 13, 2014, at 8:11 PM, Marc MERLIN <marc@merlins.org> wrote:
> >> 
> >> > On Sun, Mar 09, 2014 at 11:33:50AM +0000, Hugo Mills wrote:
> >> >> discard is, except on the very latest hardware, a synchronous
> >> >> command (it's a limitation of the SATA standard), and therefore
> >> >> results in very very poor performance.
> >> > 
> >> > Interesting. How do I know if a given SSD will hang on discard?
> >> > Is a Samsung EVO 840 1TB SSD latest hardware enough, or not? :)
> >> 
> >> smartctl -a or -x will tell you what SATA revision is in place. The
> >> queued trim support is in SATA Rev 3.1. I'm not certain if this
> >> requires only the drive to support that revision level, or both
> >> controller and drive.
> > 
> > I'm not sure I'm seeing this, which field is that?
> 
> > ATA Version is:   8
> > ATA Standard is:  ATA-8-ACS revision 4c
> 
> Your drive didn't report it, but here, I have SATA fields as well, in 
> addition to the ATA fields:
> 
> Here's the fields from my Corsair Neutron SSDs:
> 
> ATA Version is:   ATA8-ACS (minor revision not indicated)
> SATA Version is:  SATA 2.5, 6.0 Gb/s
> 
> Here's the fields from my Seagate 500-gig 2.5-inch spinning rust:
> 
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 3.0 Gb/s

Ok, my smartmontools was too old. I got a newer one and now have proper
output:
Device Model:     Samsung SSD 840 EVO 1TB
Serial Number:    S1D9NEAD934600N
LU WWN Device Id: 5 002538 85009a8ff
Firmware Version: EXT0BB0Q
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Mar 14 10:49:39 2014 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

So I have Sata 3.1, that's great news, it means I can keep using discard
without worrying about performance and hangs

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
