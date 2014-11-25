Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i2.italiaonline.it ([212.48.25.196]:43920 "EHLO
	smtp-17.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbaKYQeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:34:20 -0500
Message-ID: <5474AF87.6090702@inwind.it>
Date: Tue, 25 Nov 2014 17:34:15 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com> <CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com> <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com> <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org>
In-Reply-To: <20141123001927.GO17380@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/2014 01:19 AM, Zygo Blaxell wrote:
[...]
> md-raid works as long as you specify the devices, and because it's always
> the lowest layer it can ignore LVs (snapshot or otherwise).  It's also
> not a particularly common use case, while making an LV snapshot of a
> filesystem is a typical use case.

I fully agree; but you still consider a *multi-device* btrfs over lvm...
This is like a dm over lvm... which doesn't make sense at all (as you 
already wrote)

> 
>>> and mounting the filesystem fails at 3.  
>> Are you sure ?
> 
> Yes, I'm sure.  I've had to replace filesystems destroyed this way.
> 
>> [working instance snipped]
> 
>> On the basis of the example above, in case you want to mount a 
>> "single-disk", BTRFS seems me to work properly. You have to pay
>> attention only to not mount the two filesystem at the same time.
> 
> The problem is btrfs stops searching when it sees one disk with each UUID,

BTRFS doens't search anything. It is udev which "push" the information
on the kernel module. The btrfs module groups these information by UUID.
When a new disk is inserted, overwrite the information of the old one.


> so the set of disks (snapshot vs origin) that you get is *random*.
> For a pair of origin + snapshots, there's a 50% chance it works, 50%
> chance it eats your data.

Sorry but I have to disagree: the code is quite clear 
(see fs/btrfs/volume.c, near line 512):

[...]

        } else if (!device->name || strcmp(device->name->str, path)) {
                /*
                 * When FS is already mounted.
                 * 1. If you are here and if the device->name is NULL that
                 *    means this device was missing at time of FS mount.
                 * 2. If you are here and if the device->name is different
                 *    from 'path' that means either
                 *      a. The same device disappeared and reappeared with
                 *         different name. or
                 *      b. The missing-disk-which-was-replaced, has
                 *         reappeared now.
                 *
                 * We must allow 1 and 2a above. But 2b would be a spurious
                 * and unintentional.

[...]

The case is the 2a; in this case btrfs store the new name and mount it.

Anyway I made a small test: I created 1 btrfs filesystem, and 
made a lvm-snapshot. Then create two different file in the snapshot and in
the original one. I run a program which mounts randomly the first or
the latter, checks if the correct file is present; after more than 130 tests I
never saw your "50% chance it works": it always works.

BR
G.Baroncelli

> 
>> BR
>> G.Baroncelli
>>
>>
>> -- 
>> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
>> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

