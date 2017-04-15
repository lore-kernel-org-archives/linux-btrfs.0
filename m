Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60654 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdDOSUK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:20:10 -0400
Subject: Re: remount and conflicting ssd options?
To: Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <4096c717-4804-bce4-d7da-de962218f190@mendix.com>
Date: Sat, 15 Apr 2017 20:20:07 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2017 08:17 PM, Chris Murphy wrote:
> I don't understand this:
> 
> /dev/mmcblk0p3 on / type btrfs
> (rw,noatime,seclabel,compress=zlib,nossd,ssd_spread,space_cache,commit=150,subvolid=260,subvol=/root)
> 
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
> shows ssd_spread. And then if I do
> 
> mount -o remount,nossd
> 
> I get the above mount output with nossd,ssd_spread options which would
> seem to be a contradiction. At least it's confusing. So... now what?
> 
> kernel 4.10.8-200.fc25.x86_64
> 

See thread "Cosmetics bug: remounting ssd does not clear nossd", started
on Mar 31. It has all the answers. :-)

-- 
Hans van Kranenburg
