From: Chris Mason <chris.mason@oracle.com>
Subject: Re: writes got stuck
Date: Tue, 19 Apr 2011 08:06:13 -0400
Message-ID: <1303214712-sup-9341@think>
References: <BANLkTinJt3n69=NpPKAvFd3LPeDGnn0bkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Cheng Shao <zchshao@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BANLkTinJt3n69=NpPKAvFd3LPeDGnn0bkA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Cheng Shao's message of 2011-04-18 17:49:29 -0400:
> Hi there,
> 
> I'm periodically having issues with btrfs running in a Ubuntu VM using
> VirtualBox. After the VM has been running for a while (a couple days),
> any write operation seems getting stuck. The read seems totally fine.
> I tried a simple dd of a 4M file and it got stuck after writing 131K
> worth of data.
> 
> I don't know if this is btrfs related, or it is due to some bug in
> VritualBox. Could you guys provide information on how to debug this
> (collecting logs, getting dumps etc.)? Thanks a lot!

Which kernel are you running?

Definitely look for kernel messages (run dmesg etc).  If there are no
crashes or related messages you can run sysrq-t and send the output and
we can look for the deadlock.

-chris
