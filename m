Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:37492 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751505AbeAZOzF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 09:55:05 -0500
Received: by mail-io0-f173.google.com with SMTP id f89so688165ioj.4
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 06:55:04 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Christophe Yayon <cyayon-list@nbux.org>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com>
 <5d342036-0de0-9bf7-3e9e-4885b62d8100@gmail.com>
 <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f87f54d4-09a0-5b7c-d0d3-2d5525fbab73@gmail.com>
Date: Fri, 26 Jan 2018 09:55:01 -0500
MIME-Version: 1.0
In-Reply-To: <1516978054.4103196.1249114200.76EC1546@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-26 09:47, Christophe Yayon wrote:
> Hi Austin,
> 
> Thanks for your answer. It was my opinion too as the "degraded" seems to be flagged as "Mostly OK" on btrfs wiki status page. I am running Archlinux with recent kernel on all my servers (because of use of btrfs as my main filesystem, i need a recent kernel).
> 
> Your idea to add a separate entry in grub.cfg with rootflags=degraded is attractive, i will do this...
> 
> Just a last question, i thank that it was necessary to add "degraded" option in grub.cfg AND fstab to allow boot in degraded mode. I am not sure that only grub.cfg is sufficient...
> Yesterday, i have done some test and boot a a system with only 1 of 2 drive in my root raid1 array. No problem with systemd, but i added rootflags and fstab option. I didn't test with only rootflags.
Hmm...  I'm pretty sure that you only need degraded in rootflags for a 
degraded boot without systemd involved.  Not sure about with systemd 
involved, though the fact that it worked with systemd at all is 
interesting, as last I knew systemd doesn't do any special casing for 
BTRFS and just looks at whether all the devices are registered with the 
kernel or not.

Also, as far as I know, `degraded` in the mount options won't cause any 
change in behavior if there is no device missing, so you're not really 
going to be running 'degraded' if you've got all your devices (though 
depending on how long it takes to scan devices, you may end up with some 
issues during boot when they're technically all present and working).
