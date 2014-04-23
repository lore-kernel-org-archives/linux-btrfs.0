Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:53999 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbaDWTmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 15:42:05 -0400
Message-ID: <53580794.3050001@arcor.de>
Date: Wed, 23 Apr 2014 20:33:56 +0200
From: Martin Wilck <mwilck@arcor.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Lost /home subvolume after btrfs crash
References: <534E8B6A.9060209@arcor.de> <7C3AD7C7-44A4-45F3-9634-3E92618DCD15@colorremedies.com>
In-Reply-To: <7C3AD7C7-44A4-45F3-9634-3E92618DCD15@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

> OpenSUSE 12.3 is using kernel 3.7 which is also old for this sort of recovery attempt. Even openSUSE 13.1 is at 3.11.6 which might work in a bind, but if it doesn't, inevitably someone will suggest you use something even newer. 

Thanks for your reply, I appreciate it a lot.

> Current stable is 3.14.1, I suggest giving 3.13 or 3.14 a shot at this with -o ro,recovery as a first step and see if it at least mounts.

I will. Note that with 12.3, which was the most recent media I had at
hand at the time, the FS was actually mountable at first (-o
ro,recovery). But there was no /home and later attempts to actually
access data in other subvolumes failed with the messages in my debug
material.

> And an old kernel implies old btrfs-progs too, which is where the code for btrfsck and btrfs restore is contained. So that needs to be at least v 3.12. And hopefully you didn't use --repair with btrfsck yet.

I did, but I made a block-level copy of the device before.

Thanks again
Martin
