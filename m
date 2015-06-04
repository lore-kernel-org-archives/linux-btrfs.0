Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kajt.de ([5.45.108.103]:58035 "EHLO kajt.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbbFDPds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Jun 2015 11:33:48 -0400
Date: Thu, 4 Jun 2015 17:33:45 +0200
From: Maximilian Eschenbacher <maximilian@eschenbacher.email>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stability of Btrfs in Kernel 3.0
Message-ID: <20150604153345.GD3626@kajt.de>
References: <20150604125448.GB3626@kajt.de>
 <15093386.MD5Tv7KU3x@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <15093386.MD5Tv7KU3x@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Martin,

On 04/06/2015 15:55:49, Martin Steigerwald wrote:
>BTRFS and Kernel 3.0?
>
>Unless its has a newer BTRFS version or at least critical fixed
>backported, I would run away from it.
>
>Free space management in Kernel 3.0 still had issues that even with 2
>GiB free the filesystem could report its full, while also denying to rm
>a file, delete a subvolume or do anything else to mitigate the
>situation. I have seen this on SLES 11 SP 3.
>
>I suggest something newer. Really.
>
>Or, if you still want to use it:
>
>If you want to store 50 GiB, keep 50 GiB of space free, or at least
>20-30 GiB. I.e. have plenty of free space on the device. Do not fill up
>the filesystem.
>
>Or well… use another filesystem on that device.
>
>In addition meanwhile there will be a ton of other issues with such an
>old BTRFS fixed.
>
>So until you can´t get a newer kernel for that device, I would not use
>it with BRFS.

thanks for the quick and precise answer. I will find out whether Netgear
did some backporting for btrfs in their kernel and report back.

Unfortunately Netgear uses only btrfs (or zfs on some systems) and one
cannot select another fs like ext4 (which they supported on previous
systems).

Regards,

Max
