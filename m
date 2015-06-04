Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46819 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbFDNzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 09:55:51 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Maximilian Eschenbacher <maximilian@eschenbacher.email>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stability of Btrfs in Kernel 3.0
Date: Thu, 04 Jun 2015 15:55:49 +0200
Message-ID: <15093386.MD5Tv7KU3x@merkaba>
In-Reply-To: <20150604125448.GB3626@kajt.de>
References: <20150604125448.GB3626@kajt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 4. Juni 2015, 14:54:48 schrieb Maximilian Eschenbacher:
> Greetings,
> 
> I am wondering about the stability of btrfs in this kernel version since
> Negear ist selling those ReadyNAS with a buttload of features including
> btrfs and linux kernel 3.0.
> 
> Is this a system one can use to keep backup? Do you have any suggestions
> on what operations may be cause problems or how to keep btrfs happy and
> running?

BTRFS and Kernel 3.0?

Unless its has a newer BTRFS version or at least critical fixed backported, I 
would run away from it.

Free space management in Kernel 3.0 still had issues that even with 2 GiB 
free the filesystem could report its full, while also denying to rm a file, 
delete a subvolume or do anything else to mitigate the situation. I have 
seen this on SLES 11 SP 3.

I suggest something newer. Really.

Or, if you still want to use it:

If you want to store 50 GiB, keep 50 GiB of space free, or at least 20-30 
GiB. I.e. have plenty of free space on the device. Do not fill up the 
filesystem.

Or well… use another filesystem on that device.

In addition meanwhile there will be a ton of other issues with such an old 
BTRFS fixed.

So until you can´t get a newer kernel for that device, I would not use it 
with BRFS.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
