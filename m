Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:37611 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbeFOSKv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Jun 2018 14:10:51 -0400
Received: by mail-io0-f193.google.com with SMTP id s26-v6so11489318ioj.4
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2018 11:10:51 -0700 (PDT)
Subject: Re: ntfs -> qemu -> raw-image -> btrfs -> iscsi
To: Chris Murphy <lists@colorremedies.com>, ein <ein.net@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <336a1d5a-708f-f7e3-8fdf-6898fc68140a@gmail.com>
 <CAJCQCtQTZo5mjG+9BE0SFKYsFGqXKvLRgkbGe3xH27=4Xme53g@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <19c0d77f-1687-d705-b9f3-20e1c2dd1d17@gmail.com>
Date: Fri, 15 Jun 2018 14:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQTZo5mjG+9BE0SFKYsFGqXKvLRgkbGe3xH27=4Xme53g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-06-15 13:40, Chris Murphy wrote:
> On Fri, Jun 15, 2018 at 5:33 AM, ein <ein.net@gmail.com> wrote:
>> Hello group,
>>
>> does anyone have had any luck with hosting qemu kvm images resided on BTRFS filesystem while serving
>> the volume via iSCSI?
>>
>> I encouraged some unidentified problem and I am able to replicate it. Basically the NTFS filesystem
>> inside RAW image gets corrupted every time when Windows guest boots. What is weired is that changing
>> filesystem for ext4 or xfs solves the issue.
>>
>> The problem replication looks as follows:
>> 1) run chkdsk on the guest to make sure the filesystem structure is in good shape,
>> 2) shut down the VM via libvirtd,
>> 3) rsync changes between source and backup image,
>> 4) generate SHA1 for backup and original and compare it,
>> 5) try to run guest on the backup image, I was able to boot windows once for ten times, every time
>> after reboot NTFS' chkdsk finds problems with filesystem and the VM is unable to boot again.
>>
>> What am I missing?
>>
>> VM disk config:
>>
>>      <disk type='file' device='disk'>
>>        <driver name='qemu' type='raw' cache='none' io='native'/>
> 
> 
> 
> cache=none uses O_DIRECT, and that's the source of the issue with VM
> images on Btrfs. Details are in the list archive.
> 
> I'm not really sure what you want to use with Windows in this
> particular case, probably not cache=unsafe though. I'd say give
> writethrough a shot and see how it affects performance and fixes this
> problem.
> 
cache=writethrough is probably going to be the best option, unless you 
want to switch to cache=writeback and disable write caching in Windows 
(which from what I hear can actually give better performance than using 
cache=none).
