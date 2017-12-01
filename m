Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54049 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdLAUhz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 15:37:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eKs49-0006Kl-S1
        for linux-btrfs@vger.kernel.org; Fri, 01 Dec 2017 21:37:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-progs - failed btrfs replace on RAID1 seems to have left
 things in a wrong state
Date: Fri, 1 Dec 2017 20:37:38 +0000 (UTC)
Message-ID: <pan$10b1c$c01da1a$3a1f81da$cc066079@cox.net>
References: <CAKYHq8+crFyGA7UjaTQehOY5BcKnFLXPVMQ=VZqbeV-XhU63Yw@mail.gmail.com>
        <pan$5abb1$c7dbef76$8f3acd4$8912c489@cox.net>
        <CAA7pwKOhxP=zLreSXoZfG5TzmiHhfAetVuqXxfz7a=KrkJXoQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patrik Lundquist posted on Fri, 01 Dec 2017 10:29:43 +0100 as excerpted:

> On 1 December 2017 at 08:18, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> When udev sees a device it triggers
>> a btrfs device scan, which lets btrfs know which devices belong to which
>> individual btrfs.  But once it associates a device with a particular
>> btrfs, there's nothing to unassociate it -- the only way to do that on
>> a running kernel is to successfully complete a btrfs device remove or
>> replacement... and your replace didn't complete due to error.
>>
>> Of course the other way to do it is to reboot, fresh kernel, fresh
>> btrfs state, and it learns again what devices go with which btrfs
>> when the appearing devices trigger the udev rule that triggers a
>> btrfs scan.
> 
> Or reload the btrfs module.

Thanks.  Yes.  With a monolithic kernel I tend to forget about that (and
as I have a btrfs root it wouldn't be possible anyway), but indeed,
unloading/reloading the btrfs kernel module clears the btrfs device state
tracking as effectively as a reboot.  Good point! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

