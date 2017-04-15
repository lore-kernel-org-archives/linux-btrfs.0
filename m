Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42613 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdDOSb7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:31:59 -0400
Date: Sat, 15 Apr 2017 20:31:56 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <chris@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: remount and conflicting ssd options?
Message-ID: <20170415183156.mmgm6t4rygm2mt3j@angband.pl>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:17:25PM -0600, Chris Murphy wrote:
> I don't understand this:
> 
> /dev/mmcblk0p3 on / type btrfs
> (rw,noatime,seclabel,compress=zlib,nossd,ssd_spread,space_cache,commit=150,subvolid=260,subvol=/root)
> 
> The fstab uses ssd_spread. It looks like during startup the initial
> option is ssd via autodetection and then at switchroot time, when it
> goes ro to rw, the fstab options are applied and it becomes
> ssd_spread. Fine.
> 
> Then later I tried
> 
> mount -o remount,ssd
> 
> To go back to regular ssd option, but nothing happens, mount still
> shows ssd_spread.

ssd_spread implies ssd.

> And then if I do
> 
> mount -o remount,nossd
> 
> I get the above mount output with nossd,ssd_spread options which would
> seem to be a contradiction. At least it's confusing. So... now what?
> 
> kernel 4.10.8-200.fc25.x86_64

Already fixed in mainline.  You need linus/master from literally today if
your time zone is between +1 and +3 (inclusively), adjust by one day
accordingly if not.

Or cherry-pick 951e79663.

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
