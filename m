Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33463 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763840AbcINWZL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 18:25:11 -0400
Received: by mail-oi0-f49.google.com with SMTP id r126so44276008oib.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 15:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473884149.1129.12.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1473884149.1129.12.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 14 Sep 2016 16:25:08 -0600
Message-ID: <CAJCQCtRT3up_JWPisFK4f0D9b0dv5-EJ4zU9ara2ggu3eNB4bA@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All I can think of is the file system has gotten into a unique state
through a combination of events. I'm still suspicious that qgroups is
contributing to the problem even after being disabled. The workload
you're talking about is completely ordinary and trivial.

The openSUSE layout is basically impossible to backup and restore,
there's astrometric tons of snapshots, there's no recursive btrfs
send/receive to try and migrate it to a new file system intact, so
you'd pretty much just have to reinstall it no matter what. If it were
me, reinstall with Btrfs same as now, and first thing before anything
else I'd disable quotas. Or yeah, it's completely reasonable for you
to move to a different file system, it's really a coin toss for ext4
vs XFS, but at least XFS now checksums metadata and the journal by
default so if I thought about it at the time of the installation I'd
do that.


> Look what happened to my METADATA during the update:
>
> 1) When the problem occured:
>
> # btrfs fi usage /

Yeah FWIW, the devs seem to prefer the output from 'grep . -IR
/sys/fs/btrfs/<fsuuid>/allocation/' so for these kinds of problems I'd
report that.




>
> 4) After another rebalance (I saw the ENOSPC again):

> Metadata,DUP: Size:150.50GiB, Used:1.17GiB
>    /dev/sda6     301.00GiB

Yeah holy crap weird.

But the fs is already in some funky state so at this point it's not
surprising it continues to do crazy things. If the devs knew exactly
what was going on, they'd say so. If they had a fix, they'd post it or
at least an ETA. And while ostensibly the enospc work in 4.8 would
work around this problem, it's unknown until it's tested.

If you *really* want to, you could grab a Fedora Rawhide nightly that
has kernel 4.8 rc6 on it, with debug stuff enabled. If it face plants,
it should catch useful stuff for Josef. If it doesn't, maybe it fixes
enough things that you can get back to work for a while longer until a
long term fix becomes available. The only way to know for sure is to
test it. But it's completely sane to just switch to XFS and get back
to work also.

Current
https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20160914.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-x86_64-Rawhide-20160914.n.0.iso.n.0.iso

Use 'dd if=ISO of=USBstick bs=256K' that will boot anything, BIOS or
UEFI. At the menu, choose Troubleshooting, then the Rescue option, at
the next text menu choose 3 to get to a shell. And from there you can
mount with enospc_debug, and do a balance of the file system. To get
logs off the system, use a 2nd USB stick, or if you have wired
ethernet use scp, or if you know nmcli you can maybe get the wireless
up by command line.


> This problem is really causing me problems. I am starting to think that
> Tumbleweed, at least, should not choose BTRFS as the default file
> system, since this distribution is supposed to be stable. I think that
> BTRFS has some serious problems at least in kernels 4.6 and 4.7.
>
> I reported this problem more than 1 month ago, and yet nobody could
> provide me at least a workaround so I can keep working here. I think
> the best will be to format this machine (**again**) and use EXT4 of
> XFS, if nobody could help me to fix or avoid this problem in the
> following days.

Yep, completely reasonable.


-- 
Chris Murphy
