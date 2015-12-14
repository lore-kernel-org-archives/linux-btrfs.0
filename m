Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:59552
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbbLNI2S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 03:28:18 -0500
Subject: Re: Kernel lockup, might be helpful log.
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <566DF757.8020807@birds-are-nice.me>
 <CAJCQCtSG24eO0K6z471PzfyOM-W81p9-6Gq+QGF8dXMf1FBMyA@mail.gmail.com>
From: Birdsarenice <Quail@birds-are-nice.me>
Message-ID: <566E7D94.7000506@birds-are-nice.me>
Date: Mon, 14 Dec 2015 08:28:04 +0000
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSG24eO0K6z471PzfyOM-W81p9-6Gq+QGF8dXMf1FBMyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've no need for a fix. I know exactly what the underlying cause is: 
Those Seagate 8TB Archive drives and their known compatibility issues 
with some kernel versions. I just shared the log because it's a 
situation that btrfs handles very, very poorly, and the error handling 
could be improved. If a drive is unresponsive, btrfs really should be 
able to just cease using it and treat it as failed, or even unmount the 
entire filesystem - either would be preferable to what actually happens 
(at least for me), a system hang that leaves nothing functional whatsoever.

I've 'solved' it by removing all drives of that model. It's been running 
without issue since I did that.

On 14/12/15 07:36, Chris Murphy wrote:
> I can't help with the call traces. But several (not all) of the hard
> resetting link messages are hallmark cases where the SCSI command
> timer default of 30 seconds looks like it's being hit while the drive
> itself is hung up doing a sector read recovery (multiple attempts).
> It's worth seeing if 'smartctl -l scterc <dev>' will report back that
> SCT is supported and that it's just disabled, meaning you can change
> this to something sane like with 'smartctl -l 70,70 <dev>' which will
> make the drive time out before the linux kernel command timer. That'll
> let Btrfs do the right thing, rather than constantly getting poked in
> both eyes by link resets.
>
>
> Chris Murphy
>

