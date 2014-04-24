Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38175 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751404AbaDXDPt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 23:15:49 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Lost /home subvolume after btrfs crash
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53580794.3050001@arcor.de>
Date: Wed, 23 Apr 2014 21:15:47 -0600
Message-Id: <0B414713-868B-4BA0-8BDF-D731B8E44F5F@colorremedies.com>
References: <534E8B6A.9060209@arcor.de> <7C3AD7C7-44A4-45F3-9634-3E92618DCD15@colorremedies.com> <53580794.3050001@arcor.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Martin Wilck <mwilck@arcor.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 23, 2014, at 12:33 PM, Martin Wilck <mwilck@arcor.de> wrote:

> Chris,
> 
>> OpenSUSE 12.3 is using kernel 3.7 which is also old for this sort of recovery attempt. Even openSUSE 13.1 is at 3.11.6 which might work in a bind, but if it doesn't, inevitably someone will suggest you use something even newer. 
> 
> Thanks for your reply, I appreciate it a lot.
> 
>> Current stable is 3.14.1, I suggest giving 3.13 or 3.14 a shot at this with -o ro,recovery as a first step and see if it at least mounts.
> 
> I will. Note that with 12.3, which was the most recent media I had at
> hand at the time, the FS was actually mountable at first (-o
> ro,recovery). But there was no /home and later attempts to actually
> access data in other subvolumes failed with the messages in my debug
> material.

I'd skip 3.13 and go straight to 3.14.1 or 3.15rc2, and use mount option -o ro,recovery straight away and see if you can extract all of /home.

You could then try btrfs-progs v3.14's btrfs restore to extract /home. If that doesn't work then I'd give up on this instance of the file system as it sounds damaged by something possibly even the btrfsck --repair.

> 
>> And an old kernel implies old btrfs-progs too, which is where the code for btrfsck and btrfs restore is contained. So that needs to be at least v 3.12. And hopefully you didn't use --repair with btrfsck yet.
> 
> I did, but I made a block-level copy of the device before.

I wouldn't use --repair until a dev recommends it (even with btrfs-progs v3.14 let alone the I'm guessing v0.19 or v0.20 you were using); or once all other reasonable options are exhausted.


Chris Murphy