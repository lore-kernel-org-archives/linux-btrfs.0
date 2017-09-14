Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:47378 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdINNbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 09:31:50 -0400
Received: by mail-wr0-f182.google.com with SMTP id k20so5890139wre.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 06:31:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Thu, 14 Sep 2017 14:31:48 +0100
Message-ID: <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
Subject: Re: defragmenting best practice?
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 September 2017 at 12:38, Kai Krakow <hurikhan77@gmail.com> wrote:
[..]
>
> I suggest you only ever defragment parts of your main subvolume or rely
> on autodefrag, and let bees do optimizing the snapshots.
>
> Also, I experimented with adding btrfs support to shake, still working
> on better integration but currently lacking time... :-(
>
> Shake is an adaptive defragger which rewrites files. With my current
> patches it clones each file, and then rewrites it to its original
> location. This approach is currently not optimal as it simply bails out
> if some other process is accessing the file and leaves you with an
> (intact) temporary copy you need to move back in place manually.

If you really want to have real and *ideal* distribution of the data
across physical disk first you need to build time travel device. This
device will allow you to put all blocks which needs to be read in
perfect order (to read all data only sequentially without seek).
However it will be working only in case of spindles because in case of
SSDs there is no seek time.
Please let us know when you will write drivers/timetravel/ Linux kernel driver.
When such driver will be available I promise I'll write all necessary
btrfs code by myself in matter of few days (it will be piece of cake
compare to build such device).

But seriously ..
Only context/scenario when you may want to lower defragmentation is
when you are something needs to allocate continuous area lower than
free space and larger than largest free chunk. Something like this
happens only when volume is working on almost 100% allocated space.
In such scenario even you bees cannot do to much as it may be not
enough free space to move some other data in larger chunks to
defragment FS physical space. If your workload will be still writing
new data to FS such defragmentation may give you (maybe) few more
seconds and just after this FS will be 100% full,

In other words if someone is thinking that such defragmentation daemon
is solving any problems he/she may be 100% right .. such person is
only *thinking* that this is truth.

kloczek
PS. Do you know first McGyver rule? -> "If it ain't broke, don't fix it".
So first show that fragmentation is hurting latency of the access to
btrfs data and it will be possible to measurable such impact.
Before you will start measuring this you need to learn how o sample
for example VFS layer latency. Do you know how to do this to deliver
such proof?
PS2. The same "discussions" about fragmentation where in the past
about +10 years ago after ZFS has been introduced. Just to let you
know that after initial ZFS introduction up to now was not written
even single line of ZFS code to handle active fragmentation and no one
been able to prove that something about active defragmentation needs
to be done in case of ZFS.
Why? Because all stands on the shoulders of enough cleaver *allocation
algorithm*. Only this and nothing more.
PS3. Please can we stop this/EOT?
--
Tomasz Kłoczko | LinkedIn: http://lnkd.in/FXPWxH
