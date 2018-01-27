Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50871 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbeA0PZ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 10:25:28 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1efSJh-0004mh-GE
        for linux-btrfs@vger.kernel.org; Sat, 27 Jan 2018 16:22:53 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: degraded permanent mount option
Date: Sat, 27 Jan 2018 15:22:38 +0000 (UTC)
Message-ID: <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
        <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
        <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
        <84c23047-522d-2529-5b16-d07ed8c28fc6@gmail.com>
        <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
        <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
        <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
        <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
        <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
        <20180127110619.GA10472@polanet.pl>
        <20180127132641.mhmdhpokqrahgd4n@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Sat, 27 Jan 2018 14:26:41 +0100 as excerpted:

> On Sat, Jan 27, 2018 at 12:06:19PM +0100, Tomasz Pala wrote:
>> On Sat, Jan 27, 2018 at 13:26:13 +0300, Andrei Borzenkov wrote:
>> 
>> >> I just tested to boot with a single drive (raid1 degraded), even
>> >> with degraded option in fstab and grub, unable to boot !  The boot
>> >> process stop on initramfs.
>> >> 
>> >> Is there a solution to boot with systemd and degraded array ?
>> > 
>> > No. It is finger pointing. Both btrfs and systemd developers say
>> > everything is fine from their point of view.
> 
> It's quite obvious who's the culprit: every single remaining rc system
> manages to mount degraded btrfs without problems.  They just don't try
> to outsmart the kernel.

No kidding.

All systemd has to do is leave the mount alone that the kernel has 
already done, instead of insisting it knows what's going on better than 
the kernel does, and immediately umounting it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

