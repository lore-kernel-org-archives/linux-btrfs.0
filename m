Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([212.48.14.164]:54060 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750908AbdHaU34 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 16:29:56 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <2f83f856-031a-9c52-2443-1b8a530e51f8@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <9fd28041-3f49-4dc7-d4a3-120edfe47964@inwind.it>
Date: Thu, 31 Aug 2017 22:29:45 +0200
MIME-Version: 1.0
In-Reply-To: <2f83f856-031a-9c52-2443-1b8a530e51f8@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 20:49, Austin S. Hemmelgarn wrote:
> On 2017-08-31 13:27, Goffredo Baroncelli wrote:
>> Hi All,
>> 
>> 
>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It
>> seems that it is not visible the full disk.
>> 
>> $ uname -a Linux venice.bhome 4.12.8 #268 SMP Thu Aug 17 09:03:26
>> CEST 2017 x86_64 GNU/Linux $ btrfs --version btrfs-progs v4.12
> As far as I understand it, this is intended behavior.  Tools that
> offer equivalent options (genext2fs for example) are designed to
> generate pre-packaged system images that can then be resized to fit
> the target device's space.  As an example use case, I do full system
> image updates on some of my systems (that is, I keep per-system
> configuration to a minimum and replace the entire root filesystem
> when I update the system) I use this option to generate a base-image,
> which then gets automatically resized by my update scripts to fill
> the partition during the update process.

Sorry, but I am a bit confused. If I run "mkfs.btrfs -r ...." on a partition... how I can detect the end of the filesystem in order to cut the unused space ?

>From your explanation I should do

# mkfs.btrfs -r <source> /dev/sdX

then

# dd if=/dev/sdX of=/tmp/image bs=1M count=NNNN

What I have to put in NNNN ?

genext2fs in effect works generating a file. Instead mkfs.btrfs seems to work only with disks (or file already created)...

> 
> Overall, this could probably stand to be documented better though
> (I'll look at writing a patch to update the documentation to clarify
> this when I have some spare time over the weekend).

This would be great. However I think that some code should be update in order to generate a file instead of rely on a block device.

BR
G.Baroncelli 
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
