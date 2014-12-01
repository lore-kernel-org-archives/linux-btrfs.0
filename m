Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:35315 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbaLATdh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 14:33:37 -0500
Message-ID: <547CC28E.2050208@pobox.com>
Date: Mon, 01 Dec 2014 11:33:34 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Oliver <r.oliver@web.de>, linux-btrfs@vger.kernel.org
Subject: Re: Online Drive Replacement: BTRFS with RAID 6
References: <547C7F7C.3080701@web.de>
In-Reply-To: <547C7F7C.3080701@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2014 06:47 AM, Oliver wrote:
> Hi All,
>
> on a testing machine I installed four HDDs and they are configured as
> RAID6. For a test I removed one of the drives (/dev/sdk) while the
> volume was mounted and data was written to it. This worked well, as far
> as I can see. Some I/O errors were written to /var/log/syslog, but the
> volume kept working. Unfortunately the command "btrfs fi sh" did not
> show any missing drives. So I remounted the volume in degraded mode:
> "mount -t btrfs /dev/sdx1 -o remount,rw,degraded,noatime /mnt". This way
> the drive in question was reported as missing. Then I plugged in the HDD
> again (it is of course /dev/sdk again) and started a balancing in hope
> that this will restore RAID6: "btrfs filesystem balance start /mnt". Now
> the volume looks like this:

Since it was already running and such, remounting it as degraded was 
probably not a good thing (or even vaguely necessary).

The WIKI, in discussing add/remove and failed drives goes to great 
lengths (big red box) to discuss the current instability of RAID5/6 format.

I am guessing here but I _think_ you should do the following...

(0) Backup your data. [okay this is a test system that you deliberately 
purturbed but still... 8-) ]

Option 1:

(reasonable, but undocumented .. Either blance or scrub _ought_ to look 
at the disk sectors and trigger some re-copying from the good parts.)

The disk is in the array (again), you may just need to re-balance or 
scrub the array to get the data on the drive back in harmony with the 
state of the array overall.

Option 2:

(unlikely :: add and remove are about making the geometry smaller/larger 
and, as stated, a RAID 6 cannot be less than 4 drives by definition, so 
there is no three-drive geometry for a RAID 6.)

re-unplug the device, then use btrfs remove /dev/sdk /mnt
then re-plug-in the device and use btrfs add /dev/sdk /mnt


Option 3:

(reasonable, but undocumented :: replace by device id -- 4 in your 
example case -- instead of system path. This would, I should think, skip 
the check of /dev/sdk1's separate status)

btrfs replace start -f 4 /dev/sdk1 /mnt

Option 3a:

(got to get /dev/sdk1 back out of the list of active devices for /mnt so 
the system wont see /dev/sdk1 as "mounted" (e.g. held by a subsystem))

unplug device.
mount -o remount,degraded etc...
plug in device.
btrfs replace start -f 4 /dev/sdk1 /mnt

Option 4:

(most likely, most time consuming)

Unplug /dev/sdk. Plug it into another computer and zero a decent chunk 
of partition 1.
Plug it back into the original computer
do the replace operation as in Option 3.

This is the most-likely correct option if a simple rebalance or scrub 
doesn't work, as you will be presenting the system with three attached 
drives, one "missing" drive that will not match any necessary 
signatures, and a "new, blank" drive in its place.

===

In all cases, you may need to unmount or remount or remount degraded  in 
there somewhere, particularly because you have already done so at least 
once.


