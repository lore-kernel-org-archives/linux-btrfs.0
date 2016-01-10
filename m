Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:42787 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755212AbcAJQyM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jan 2016 11:54:12 -0500
Reply-To: kreijack@inwind.it
Subject: Re: evidence of persistent state, despite device disconnects
References: <CAJCQCtS59TFek+g9x_aoqGzepySMrRn6DcOQkuwi=VQYR9M4tw@mail.gmail.com>
 <pan$671e2$87d221b4$c1b40d79$6f794584@cox.net>
 <CAJCQCtSCvzoOdqFx9dB9sbT-dR0XsQVzWwVcK3zBnwC17+ZV_Q@mail.gmail.com>
 <pan$4b55a$cfffcc6c$c8faaa76$1740646a@cox.net>
 <CAJCQCtRkDrUhiCsgO5Wm=1OhpbtxaR58SLLg5JxZvYQE_nSTUQ@mail.gmail.com>
 <pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56928CB1.1070104@inwind.it>
Date: Sun, 10 Jan 2016 17:54:09 +0100
MIME-Version: 1.0
In-Reply-To: <pan$84a33$9b12297$c9fad6dd$fe3dbd43@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-09 11:55, Duncan wrote:
> (a minimum of two devices are required to create raid1 chunks, since two
> copies are required and they can't be on the same device).

I think that this is the problem: BTRFS should allocate a new chunk as RAID1, even if only one device is available. It is already capable to use a RAID1 chunk in degraded mode, so it shouldn't be so difficult to create new chunk RAID1 when only a one disk is available.

Anyway I agree with Chris about the fact that btrfs sometime gives incorrect information about the devices. In the past I proposed to abandon the current model where the device are "per-registered" before the mount command asynchronously.
I wrote a mount helper which does a scan at the mount time [1]; this would reduce the window time where a device disappearing could cause confusion.

BR
G.Baroncelli


[1] https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg39429.html
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
