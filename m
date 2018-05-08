Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:52249 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754694AbeEHLcW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 07:32:22 -0400
Received: by mail-it0-f51.google.com with SMTP id y189-v6so9758071itb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 04:32:22 -0700 (PDT)
Subject: Re: Btrfs installation advices
To: Rolf Wald <rolf.wald@lug-balista.de>, faurepierr@gmail.com,
        linux-btrfs@vger.kernel.org
References: <a064411e-dcec-ecc8-98b9-98cb86284f1e@gmail.com>
 <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7d680d1c-60af-0d4e-1a91-c2814b1aa26d@gmail.com>
Date: Tue, 8 May 2018 07:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <63a6c2b4-79ab-18bd-2e24-6acf10b2fd63@lug-balista.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-08 03:50, Rolf Wald wrote:
> Hello,
> 
> some hints inside
> 
> Am 08.05.2018 um 02:22 schrieb faurepierr@gmail.com:
>> Hi,
>>
>> I'm curious about btrfs, and maybe considering it for my new laptop
>> installation (a Lenovo T470).
>> I was going to install my usual lvm+ext4+full disk encryption setup, but
>> thought I should maybe give a try to btrfs.
>>
>>
>> Is it possible to meet all these criteria?
>> - operating system: debian sid
>> - file system: btrfs
>> - disk encryption (or at least of sensitives partitions)
>> - hibernation feature (which implies a swap partition or file, and I've
>> read btrfs is not a big fan of the latter)
> 
> A swap partition is not possible inside or with btrfs alone.
> 
> You can choose btrfs filesystem out of the box in debian install, but 
> that would mean full-disk-encryption with lvm and btrfs. The extra layer 
> lvm doesn't hurt, but you have two layers with many functions double, 
> e.g. snapshotting, resize.
Um, this isn't really as much of an issue as you might think.  LVM has 
near zero overhead unless you're actually doing any of that stuff (as 
long as the LV is just a simple linear mapping, it has less than 1% more 
overhead than just using partitions).  The only real caveat here is to 
make _ABSOLUTELY CERTAIN_ that you _DO NOT_ make LVM snapshots of _ANY_ 
BTRFS volumes.  Doing so is a recipe for disaster, and will likely eat 
at least your data, and possibly your children.

The bigger issue is that dm-crypt generally slows down device access, 
which BTRFS is very sensitive to.  Using BTRFS with FDE works, but it's 
slow, so I would only suggest doing it with an SSD (and if you're using 
an SSD, you may be better off getting a TCG Opal compliant 
self-encrypting drive and just using the self-encryption functionality 
instead of FDE).
> 
>>
>> If yes, how would you suggest me to achieve it?
> 
> Yes, there is a solution, and it works for me now several years.
> You need to build three partitions, e.g. named boot, swap, root. The 
> sizes choose to your need. the boot partition remains unencrypted, but 
> the other two partitions are encrypted with cryptsetup (luks) 
> separately. Normally there are two passphrases to type in (and to 
> remember), but there is an option in the cryptsetup scripts 
> (/lib/cryptsetup/scripts) decrypt_derived, which could take the key from 
> the root partition to decrypt the swap partition also. The filesystems 
> then on the partitions are boot with ext(2,3,4), swap with swap and root 
> with btrfs.
> This configuration is not reachable with a standard debian installation. 
> Debian always choose lvm if you want full encryption. You have to do the 
> first steps manually: make partitions, cryptsetup(luks) for the 
> partitions swap and root, and open the encrypted partitions manually. 
> After that you can install your OS. The manual steps you have to make 
> from a working distro, e.g. live system (disk or stick) with a recent 
> kernel and recent btrfs-progs (debian sid is ok for this).
> After the install of the OS you have to made the changes for a 
> successful (re)boot manually. Please read the advices you can find in 
> the net. There are some nice articles.
> 
>>
>> Thanks for your kind help.
> 

