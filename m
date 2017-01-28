Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36654 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750893AbdA1RQx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 12:16:53 -0500
Received: by mail-wm0-f48.google.com with SMTP id c85so158076387wmi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 09:16:52 -0800 (PST)
Received: from ?IPv6:2a01:5c0:13:d671:6d3b:20e0:5697:6617? ([2a01:5c0:13:d671:6d3b:20e0:5697:6617])
        by smtp.googlemail.com with ESMTPSA id o42sm13642564wrb.18.2017.01.28.08.46.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Jan 2017 08:46:25 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
 <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
 <304177d4-cc35-9bfc-816c-85ff3501dc50@gmail.com>
 <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
To: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <ad929c7d-8781-6c9f-382c-b2fbdfad5f2c@googlemail.com>
Date: Sat, 28 Jan 2017 17:46:24 +0100
MIME-Version: 1.0
In-Reply-To: <pan$cc953$ec4078b0$696ed46d$9618e10e@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan, 

thanks for your extensive reply! 

Am 28.01.2017 um 06:00 schrieb Duncan:
> All three options apparently default to 64K (as that's what I see here 
> and I don't believe I've changed them), but can be changed.  See the 
> kernel options help and where it points for more.
> 
Indeed, I have here:
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
(still at default)
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
The last option sets the default value for the bootparam,
so my kernel boots with checks on even without the bootparam explicitly set. 

I have now increased 
CONFIG_X86_RESERVE_LOW=640
which was previously indeed set to 64, and rebooted successfully. 

I have also tried to set:
memory_corruption_check_size=640
as kernel parameter. Sadly, the system froze before it could produce any output on screen, or write anything to PMEM.  
So I am now running with the default of checking the first 64k, but hope I am more safe since I use CONFIG_X86_RESERVE_LOW=640 now. 

> Meanwhile, since the defaults cover it, no quirk should be necessary (tho 
> I might increase the reserve and test coverage area to the maximum 640K 
> and run for awhile to be sure it's not going above the 64K default), but 
> were it outside the default 64K coverage area, I would probably file it 
> as a bug (my usual method for confirmed bugs), and mark it initially as 
> an arch-x86 bug, tho they may switch it to something else, later.  But 
> the devs would probably suggest further debugging, possibly giving you 
> debug patches to try, etc, to nail down the specific device, before 
> setting up a quirk for it.  Because the problem could be an expansion 
> card or something, not the mobo/factory-default-machine, too, and it'd be 
> a shame to setup a quirk for the wrong hardware.
I have another funny addition. I have access to a machine with exact same hardware configuration, and I am pretty sure it has the same firmware version, of course maybe slightly differently configured. 
That one is running openSUSE 13.1 with standard kernel. 
They use:
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
That machine does *NOT* produce the corruption-messages in syslog. 

The obvious differences are the kernel version (I run 4.9, that machine has 3.12.57-44-default),
and the fact that my machine was booted via UEFI, while the openSUSE machine booted classically via BIOS (i.e. CSM of the UEFI). 
Even the GPU is the same. That machine uses nvidia binary, while I use nouveau by now, but indeed I find in old syslogs the same corruption messages from the time I still used the binary blob. 

So my hunch is that it is related to me booting via EFI, but of course it might be a firmware bug triggered by some kernel-firmware-interaction change between 3.12 and 4.9,
or something in the firmware configuration. 

> Btrfs restore is a very useful tool.  It has gotten me out of a few 
> "changes since the last backup weren't valuable enough to have updated 
> the backup yet when the risk was theoretical, so nothing serious, but now 
> that it's no longer theory only, it'd still be useful to be able to save 
> the current version, if it's not /too/ much trouble" type situations, 
> myself. =:^)
> 
> Just don't count on restore to save your *** and always treat what it can 
> often bring to current as a pleasant surprise, and having it fail won't 
> be a down side, while having it work, if it does, will always be up side. 
> =:^)
> 
I'll keep that in mind, and I think that in the future, before trying any "btrfs check" (or even repair)
I will always try restore first if my backup was not fresh enough :-). 

