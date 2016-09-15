Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35578 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765069AbcIOA40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 20:56:26 -0400
Received: by mail-qk0-f174.google.com with SMTP id t7so33064578qkh.2
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 17:56:26 -0700 (PDT)
Message-ID: <1473900979.3439.6.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 14 Sep 2016 21:56:19 -0300
In-Reply-To: <CAJCQCtRT3up_JWPisFK4f0D9b0dv5-EJ4zU9ara2ggu3eNB4bA@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com> <1473884149.1129.12.camel@gmail.com>
         <CAJCQCtRT3up_JWPisFK4f0D9b0dv5-EJ4zU9ara2ggu3eNB4bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Em Qua, 2016-09-14 às 16:25 -0600, Chris Murphy escreveu:
> All I can think of is the file system has gotten into a unique state
> through a combination of events. I'm still suspicious that qgroups is
> contributing to the problem even after being disabled. The workload
> you're talking about is completely ordinary and trivial.

This seems reasonable. However, I formatted the computer and after two
days, if I remember correctly, I started to see the problems again. I'm
still thinking it should be also related to my HDD (7200 RPM). In all
my other computers, everything is fine and I use SSD.

> The openSUSE layout is basically impossible to backup and restore,
> there's astrometric tons of snapshots, there's no recursive btrfs
> send/receive to try and migrate it to a new file system intact, so
> you'd pretty much just have to reinstall it no matter what. If it
> were
> me, reinstall with Btrfs same as now, and first thing before anything
> else I'd disable quotas. Or yeah, it's completely reasonable for you
> to move to a different file system, it's really a coin toss for ext4
> vs XFS, but at least XFS now checksums metadata and the journal by
> default so if I thought about it at the time of the installation I'd
> do that.

Thanks! 

> Yeah FWIW, the devs seem to prefer the output from 'grep . -IR
> /sys/fs/btrfs/<fsuuid>/allocation/' so for these kinds of problems
> I'd
> report that.

Yeah, unfortunately I forgot this one today :(

> If you *really* want to, you could grab a Fedora Rawhide nightly that
> has kernel 4.8 rc6 on it, with debug stuff enabled. If it face
> plants,
> it should catch useful stuff for Josef. If it doesn't, maybe it fixes
> enough things that you can get back to work for a while longer until
> a
> long term fix becomes available. The only way to know for sure is to
> test it. But it's completely sane to just switch to XFS and get back
> to work also.
> 
> Current
> https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-201
> 60914.n.0/compose/Everything/x86_64/iso/Fedora-Everything-netinst-
> x86_64-Rawhide-20160914.n.0.iso.n.0.iso
> 
> Use 'dd if=ISO of=USBstick bs=256K' that will boot anything, BIOS or
> UEFI. At the menu, choose Troubleshooting, then the Rescue option, at
> the next text menu choose 3 to get to a shell. And from there you can
> mount with enospc_debug, and do a balance of the file system. To get
> logs off the system, use a 2nd USB stick, or if you have wired
> ethernet use scp, or if you know nmcli you can maybe get the wireless
> up by command line.

This seems good. However, I just have access to that machine during my
working period, and I just does not have time to test this, sorry :(

Nevertheless, when you mentioned the `dd` command, I had a great idea
that can help me to live with this problem until I have access to
kernel 4.8. I will use `dd` to create, let's say, 100 files with 3 GiB
each in my /home directory. Hence, when I see ENOSPC, I will just need
to delete some of these files. I think this should work.

Thanks for all the advices Chris!

Best regards,
Ronan Arraes
