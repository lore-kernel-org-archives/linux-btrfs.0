Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40601 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbeH2EEh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 00:04:37 -0400
Received: by mail-lj1-f180.google.com with SMTP id j19-v6so2879864ljc.7
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 17:10:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com> <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Aug 2018 18:10:29 -0600
Message-ID: <CAJCQCtQ8ML4tXke6c9cr+syoq30vKzRoN+by7vguS_zE6Z2DVw@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Menion <menion@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 8:56 AM, Menion <menion@gmail.com> wrote:
> [sudo] password for menion:
> ID      gen     top level       path
> --      ---     ---------       ----
> 257     600627  5               <FS_TREE>/@
> 258     600626  5               <FS_TREE>/@home
> 296     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
> 297     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
> 298     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30
>
> So, there are snapshots, right?

Yep. So you can use 'sudo btrfs fi du -s <pathtosnapshot>' to get a
report on  how much exclusive space is being used by each of those
snapshots and I'll bet it all adds up to about 10G or whatever you're
missing.

>The time stamp is when I have launched
> do-release-upgrade, but it didn't ask anything about snapshot, neither
> I asked for it.

Yep, not sure what's creating them or what the cleanup policy is (if
there is one). So it's worth asking in an Ubuntu forum what these
snapshots are where they came from and what cleans them up so you
don't run out of space, or otherwise how to configure it if you want
more space just because.

I mean, it's a neat idea. But also it needs to clean up after itself
if for no other reason than to avoid user confusion :-)


> If it is confirmed, how can I remove the unwanted snapshot, keeping
> the current "visible" filesystem contents
> Sorry, I am still learning BTRFS and I would like to avoid mistakes
> Bye

You can definitely use Btrfs specific tools to get rid of the
snapshots and not piss off Btrfs at all. However, if you delete them
behind the back of the thing that created them in the first place, it
might get pissed off if they just suddenly go missing. Sometimes those
tools want to do the cleanups because it's tracking the snapshots and
what their purpose is. So if they just go away, it's like having the
rug pulled out from under them.

Anyway:

'sudo btrfs sub del <pathtosubvolume>' will delete it.


Also, I can't tell you for sure what sort of write amplification Btrfs
contributes in your use case on eMMC compared to F2FS. Btrfs has a
"wandering trees" problem that F2FS doesn't have as big a problem.
It's not a big deal (probably) on other kinds of SSDs like SATA/SAS
and NVMe. But on eMMC? If it were SD Card I'd say you can keep using
Btrfs, and maybe mitigate the wandering trees with compression to
reduce overall writes. But if your eMMC is soldered onto a board, I
might consider F2FS instead. And Btrfs for other things.


-- 
Chris Murphy
