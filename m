Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:32847 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755757AbdLTRae (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Dec 2017 12:30:34 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eRiAJ-0000y9-OQ
        for linux-btrfs@vger.kernel.org; Wed, 20 Dec 2017 18:28:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unexpected raid1 behaviour
Date: Wed, 20 Dec 2017 17:28:10 +0000 (UTC)
Message-ID: <pan$758ef$cfef6027$b6ab67ce$233e8581@cox.net>
References: <5A357909.8010206@yandex.ru>
        <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
        <23094.37316.66397.431081@tree.ty.sabi.co.uk>
        <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
        <20171218194351.GA25245@polanet.pl>
        <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
        <20171219144644.GA9855@polanet.pl>
        <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
        <20171219204155.GB14726@polanet.pl>
        <aac98fbf-c94b-1a88-f191-902146ff544f@gmail.com>
        <20171219222308.GE14726@polanet.pl>
        <862f03b0-9311-09f6-ee2c-d53d35d176bd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 20 Dec 2017 08:33:03 -0500 as
excerpted:

>> The obvious answer is: do it via kernel command line, just like mdadm
>> does:
>> rootflags=device=/dev/sda,device=/dev/sdb
>> rootflags=device=/dev/sda,device=missing
>> rootflags=device=/dev/sda,device=/dev/sdb,degraded
>> 
>> If only btrfs.ko recognized this, kernel would be able to assemble
>> multivolume btrfs itself. Not only this would allow automated degraded
>> mounts, it would also allow using initrd-less kernels on such volumes.
> Last I checked, the 'device=' options work on upstream kernels just
> fine, though I've never tried the degraded option.  Of course, I'm also
> not using systemd, so it may be some interaction with systemd that's
> causing them to not work (and yes, I understand that I'm inclined to
> blame systemd most of the time based on significant past experience with
> systemd creating issues that never existed before).

Has the bug where rootflags=device=/dev/sda1,device=/dev/sdb1 failed, 
been fixed?  Last I knew (which was ancient history in btrfs terms, but 
I've not seen mention of a patch for it in all that time either), device= 
on the userspace commandline worked, and device= on the kernel commandline 
worked if there was just one device, but it would fail for more than one 
device.  Mounting degraded (on a pair-device raid1) would then of course 
work, since it would just use the one device=, but that's simply 
dangerous for routine use regardless of whether it actually assembled or 
not, thus effectively forcing an initr* for multi-device btrfs root in 
ordered to get it mounted properly.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

