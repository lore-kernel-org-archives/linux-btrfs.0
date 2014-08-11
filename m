Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60936 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaHKPpu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 11:45:50 -0400
Received: by mail-oi0-f45.google.com with SMTP id e131so5670253oig.4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 08:45:50 -0700 (PDT)
Message-ID: <1407771945.6404.1.camel@kepstin.ca>
Subject: Re: File system stuck in scrub
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 11 Aug 2014 11:45:45 -0400
In-Reply-To: <87mwbbnjpt.fsf@vostro.rath.org>
References: <87mwbbnjpt.fsf@vostro.rath.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, 2014-08-11 at 08:12 -0700, Nikolaus Rath wrote:
> Hello,
> 
> I started a scrub of one of my btrfs filesystem and then had to 
> restart
> the system. `systemctl restart` seemed to terminate all processes, 
> but
> then got stuck at the end. The disk activity led was still flashing
> rapidly at that point, so I assume that the active scrub was 
> preventing
> the reboot (is that a bug or a feature?).
This sounds like a bug - I know that e.g. the rebalance operation is 
designed so that you can shutdown/reboot during the operation, and it 
will complete following a reboot. But I'm not familiar with the code 
in question.

> In any case, I could not wait for that so I power cycled. But now my
> file system seems to be stuck in a scrub that can neither be 
> completed
> nor cancelled:
> 
> $ sudo btrfs scrub status /home/nikratio/
> scrub status for 8742472d-a9b0-4ab6-b67a-5d21f14f7a38
>         scrub started at Sun Aug 10 18:36:43 2014, running for 1562 
> seconds
>         total bytes scrubbed: 209.97GiB with 0 errors
> 
> $ date
> Sun Aug 10 22:00:44 PDT 2014
> 
> $ sudo btrfs scrub cancel /home/nikratio/
> ERROR: scrub cancel failed on /home/nikratio/: not running
> 
> $ sudo btrfs scrub start /home/nikratio/
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /home/nikratio/'.
> To see the status use 'btrfs scrub status [-d] /home/nikratio/'.
My guess is that this is a mismatch between some state stored by the 
userspace tools and the state in the kernel. One of the things you can 
try is to delete the files /var/lib/btrfs/scrub.status.* - that will 
force the btrfs tools to get the current status from the kernel (you 
will lose some statistics and scrub history.)

Running 'btrfs scrub status /home/nikratio/' after this should simply 
say 'no stats available', and you can start a new scrub later if you 
like.

> I then figured that maybe I need to run btrfsck. This gave the 
> following
> output:
As long as you didn't use --repair, this shouldn't break anything... 
Note that btrfs has to be run on an *unmounted* filesystem to give 
useful results.

>  * Is it more risky to leave the above errors uncorrected, or to run
>    btrfsck with --repair?
There probably aren't any issues on the filesystem that the runtime 
btrfs code can't handle. Don't run with --repair, at least not yet.

> 
> 
> I'm using kernel 3.14.
> 
> Thanks!
> -Nikolaus
> 
> 

-- 
Calvin Walton <calvin.walton@kepstin.ca>
