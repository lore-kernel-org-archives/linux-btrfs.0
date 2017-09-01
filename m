Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34212 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdIALtJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 07:49:09 -0400
Received: by mail-io0-f193.google.com with SMTP id z67so808261iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 04:49:09 -0700 (PDT)
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <2f83f856-031a-9c52-2443-1b8a530e51f8@gmail.com>
 <9fd28041-3f49-4dc7-d4a3-120edfe47964@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <67a445ef-ce53-534a-8473-a5057b64d0fa@gmail.com>
Date: Fri, 1 Sep 2017 07:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <9fd28041-3f49-4dc7-d4a3-120edfe47964@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 16:29, Goffredo Baroncelli wrote:
> On 2017-08-31 20:49, Austin S. Hemmelgarn wrote:
>> On 2017-08-31 13:27, Goffredo Baroncelli wrote:
>>> Hi All,
>>>
>>>
>>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It
>>> seems that it is not visible the full disk.
>>>
>>> $ uname -a Linux venice.bhome 4.12.8 #268 SMP Thu Aug 17 09:03:26
>>> CEST 2017 x86_64 GNU/Linux $ btrfs --version btrfs-progs v4.12
>> As far as I understand it, this is intended behavior.  Tools that
>> offer equivalent options (genext2fs for example) are designed to
>> generate pre-packaged system images that can then be resized to fit
>> the target device's space.  As an example use case, I do full system
>> image updates on some of my systems (that is, I keep per-system
>> configuration to a minimum and replace the entire root filesystem
>> when I update the system) I use this option to generate a base-image,
>> which then gets automatically resized by my update scripts to fill
>> the partition during the update process.
> 
> Sorry, but I am a bit confused. If I run "mkfs.btrfs -r ...." on a partition... how I can detect the end of the filesystem in order to cut the unused space ?
> 
>  From your explanation I should do
> 
> # mkfs.btrfs -r <source> /dev/sdX
> 
> then
> 
> # dd if=/dev/sdX of=/tmp/image bs=1M count=NNNN
> 
> What I have to put in NNNN ?
Mount the filesystem, and see what size `btrfs filesystem show` reports 
for the device, then go just over that (to account for rounding).
> 
> genext2fs in effect works generating a file. Instead mkfs.btrfs seems to work only with disks (or file already created)...
Most mkfs tools require a file to already exist because they were 
designed to create fixed size filesystem images.
> 
>>
>> Overall, this could probably stand to be documented better though
>> (I'll look at writing a patch to update the documentation to clarify
>> this when I have some spare time over the weekend).
> 
> This would be great. However I think that some code should be update in order to generate a file instead of rely on a block device.
> 
> BR
> G.Baroncelli
> 

