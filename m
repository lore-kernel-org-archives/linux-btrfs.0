Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37572 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbcAUXvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 18:51:43 -0500
Received: by mail-ig0-f178.google.com with SMTP id h5so43630965igh.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 15:51:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.20.1601211317410.38375@ioko>
References: <alpine.OSX.2.20.1601190308520.34954@ioko>
	<CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com>
	<CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com>
	<alpine.OSX.2.20.1601211317410.38375@ioko>
Date: Thu, 21 Jan 2016 16:51:42 -0700
Message-ID: <CAJCQCtQLFdWf35bFK2exkSg2yWu2ZtAUO+xDO6j8ZGado9VGNw@mail.gmail.com>
Subject: Re: FS corruption when mounting non-degraded after mounting degraded
From: Chris Murphy <lists@colorremedies.com>
To: Rian Hunter <rian@thelig.ht>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 3:25 PM, Rian Hunter <rian@thelig.ht> wrote:

>
> Start state: Normally functioning raid6 array. Device FOO intermittently
> fails and requires power cycle to work again. This has happened 25-50
> times in the past with no irresolvable data corruption.

For each drive, what are the results:
# smartctl -l scterc /dev/sdX
# cat /sys/block/sdX/device/timeout





>
> * Unmount raid6 FS
> * Disconnect array.
> * Physically remove device FOO from array, add new device BAR to array.
> * Connect array
> * Mount raid6 array with "-o degraded"
> * Run "btrfs replace start 2 /dev/BAR /mnt"
> * Start VMs on FS
> * Machine freezes (not sure why)
> * Restart machine
> * Mount raid6 array with "-o degraded"
> * Replace job continues automatically
> * Start VMs on FS
> * After an hour: VMs have no started up yet (seeing hung-task
>   warnings in kernel). "btrfs replace status /mnt" shows 0.1% done

Do you have dmesg output that includes sysrq+w at the time of the hung
tasks warnings? That's pretty much always requested by devs in these
cases.


> * Cancel replace: "btrfs replace cancel /mnt"
> * Unmount raid6 FS
> * Disconnect array
> * Physically add device FOO back to array
> * Reconnect array
> * Mount raid6 array normally (no "-o degraded")
> * Run "btrfs replace start 2 /dev/BAR /mnt"

Hmm. Open question if 'btrfs replace cancel' actually marked /dev/BAR
as wiped. If it doesn't, then this 2nd replace start should have
failed unless you had used -f, or you used wipefs -a. If it's not
wiped by any of the above, then I'd expect it's possible things get
messy.



> * Mount raid6 array with "-o degraded"
> * Run "btrfs replace start 2 /dev/BAR /mnt"
> * After an hour: Replace operation was automatically cancelled, lots
>   of "parent transid verify failed" in dmesg again.
> * Run "btrfs scrub," "btrfs scrub status" shows millions of
>   unrecoverable errors


Some others (no devs however) have disagreed with me on this, so take
it with a grain of salt, but I don't understand the rationale of
running scrub on degraded arrays. The first order of business is to
get it non-degraded. If that can't be done, scrub is pointless. Of
course it's going to produce millions of unrecoverable errors. There's
a device missing, so I'd expect many unrecoverable errors during a
degraded scrub.




> * Cancel "btrfs scrub"
> * At this point I'm convinced this FS is in a very broken state and I
>   try to salvage whatever data could have changed since beginning the
>   process.

Agreed. Certainly not reassuring.


> From a black box perspective, this led me to believe that the
> corruption happened during the replace operation after mounting
> normally after first mounting with "-o degraded." Of course,
> knowledge of the internals could easily verify this.

Filesystems are really difficult, so even knowledge of the internals
doesn't guarantee the devs will understand where the problem first
started in this case.


-- 
Chris Murphy
