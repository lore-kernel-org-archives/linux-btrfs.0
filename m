Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:41967 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbbBISIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 13:08:39 -0500
Received: by mail-qa0-f49.google.com with SMTP id v8so22255784qal.8
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 10:08:38 -0800 (PST)
Received: from [127.0.0.1] (68-188-183-115.dhcp.bycy.mi.charter.com. [68.188.183.115])
        by mx.google.com with ESMTPSA id q5sm12569249qan.24.2015.02.09.10.08.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 09 Feb 2015 10:08:37 -0800 (PST)
Message-ID: <54D8F7B6.1060802@virtualcomplete.com>
Date: Mon, 09 Feb 2015 13:08:54 -0500
From: "Devon B." <devon.b@virtualcomplete.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Accepting discard to free space from disk images
References: <54D842FD.1010806@virtualcomplete.com> <20150209114023.137402bf@natsu> <54D8D1A9.1070006@virtualcomplete.com> <20150209204256.51278106@natsu> <20150209204521.7b556d93@natsu>
In-Reply-To: <20150209204521.7b556d93@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for your testing.  I haven't tried 3.14.  I tried on CentOS 6 box 
(2.6.32 - which is experimental) and Ubuntu 14.04 (3.13) and neither 
worked.  So the question remains, what is the difference?  Possibly a 
small difference between the 3.13 and 3.14 kernels, I don't think it is 
any of the mount options.  I guess if anyone else has insight on this, 
that would be great.  Otherwise, I'll see if I can get a newer kernel 
loaded up and do some more testing.

> Roman Mamedov <mailto:rm@romanrm.net>
> Monday, February 9, 2015 10:45 AM
> On Mon, 9 Feb 2015 20:42:56 +0500
> Roman Mamedov<rm@romanrm.net>  wrote:
>
>> On Mon, 09 Feb 2015 10:26:33 -0500
>> "Devon B."<devon.b@virtualcomplete.com>  wrote:
>>
>>> If you don't mind me asking, what version kernel are you running and are
>>> you using any special mount options?
>> Well actually I did not claim I have working discard through 'loop', but your
>> post made me curious.
>>
>> $ sudo dd if=/dev/zero of=100g bs=1M seek=100000 count=1
>> 1+0 records in
>> 1+0 records out
>> 1048576 bytes (1.0 MB) copied, 0.00221052 s, 474 MB/s
>>
>> $ sudo mkfs.ext4 100g
>> [...]
>>
>> $ du -hsc 100g
>> 133M	100g
>> 133M	total
>>
>> $ sudo mount -o loop 100g /mnt/tmp1/
>>
>> (then in a new terminal window):
>> $ cd /mnt/tmp1/
>> $ df -h .
>> Filesystem      Size  Used Avail Use% Mounted on
>> /dev/loop0       96G   60M   92G   1% /mnt/tmp1
>> $ sudo dd if=/dev/zero of=zerofile bs=1M count=1024
>> 1024+0 records in
>> 1024+0 records out
>> 1073741824 bytes (1.1 GB) copied, 0.944377 s, 1.1 GB/s
>> $ sync
>>
>> (back to the original one):
>> $ du -hsc 100g
>> 1.2G	100g
>> 1.2G	total
>
>> (2nd window):
>
> Forgot to add I also did 'rm zerofile' here, of course.
>
>> $ sudo fstrim .
>>
>> (back to the original one):
>> $ du -hsc 100g
>> 133M	100g
>> 133M	total
>>
>> So it does work for me just fine even with 'loop'.
>> Kernel version 3.14.32, mount options
>> rw,noatime,nodiratime,compress=zlib,space_cache,inode_cache.
>>
>
>
> Roman Mamedov <mailto:rm@romanrm.net>
> Monday, February 9, 2015 10:42 AM
> On Mon, 09 Feb 2015 10:26:33 -0500
>
> Well actually I did not claim I have working discard through 'loop', 
> but your
> post made me curious.
>
> $ sudo dd if=/dev/zero of=100g bs=1M seek=100000 count=1
> 1+0 records in
> 1+0 records out
> 1048576 bytes (1.0 MB) copied, 0.00221052 s, 474 MB/s
>
> $ sudo mkfs.ext4 100g
> [...]
>
> $ du -hsc 100g
> 133M 100g
> 133M total
>
> $ sudo mount -o loop 100g /mnt/tmp1/
>
> (then in a new terminal window):
> $ cd /mnt/tmp1/
> $ df -h .
> Filesystem Size Used Avail Use% Mounted on
> /dev/loop0 96G 60M 92G 1% /mnt/tmp1
> $ sudo dd if=/dev/zero of=zerofile bs=1M count=1024
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.944377 s, 1.1 GB/s
> $ sync
>
> (back to the original one):
> $ du -hsc 100g
> 1.2G 100g
> 1.2G total
>
> (2nd window):
> $ sudo fstrim .
>
> (back to the original one):
> $ du -hsc 100g
> 133M 100g
> 133M total
>
> So it does work for me just fine even with 'loop'.
> Kernel version 3.14.32, mount options
> rw,noatime,nodiratime,compress=zlib,space_cache,inode_cache.
>
> Devon B. <mailto:devon.b@virtualcomplete.com>
> Monday, February 9, 2015 10:26 AM
> If you don't mind me asking, what version kernel are you running and 
> are you using any special mount options?
>
> Here is a quick example:
>
> # qemu-img create -f raw /btrfs/sub/raw.img 100G
> Formatting '/btrfs/sub/raw.img', fmt=raw size=107374182400
>
> # mkfs.ext4 /btrfs/sub/raw.img
> ...
>
> # mount -o loop /btrfs/sub/raw.img /mnt/test
>
> # du -hs /btrfs/sub/raw.img
> 1.7G    /btrfs/sub/raw.img
>
> # fstrim -v /mnt/test
> /mnt/test: 105492688896 bytes were trimmed
>
> # du -hs /btrfs/sub/raw.img
> 1.7G    /btrfs/sub/raw.img
>
> # dd if=/dev/zero of=/mnt/test/1GB count=1k bs=1M
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.493057 s, 2.2 GB/s
>
> # du -hs /btrfs/sub/raw.img
> 2.7G    /btrfs/sub/raw.img
>
> # rm -f /mnt/test/1GB
>
> # fstrim -v /mnt/test
> /mnt/test: 1186967552 bytes were trimmed
>
> # du -hs /btrfs/sub/raw.img
> 2.7G    /btrfs/sub/raw.img
>
> # dd if=/dev/zero of=/mnt/test/1GB count=1k bs=1M
> 1024+0 records in
> 1024+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.467089 s, 2.3 GB/s
>
> # du -hs /btrfs/sub/raw.img
> 3.7G    /btrfs/sub/raw.img
>
> # rm -f /mnt/test/1GB
>
> # fstrim -v /mnt/test
> /mnt/test: 1203761152 bytes were trimmed
>
> # du -hs /btrfs/sub/raw.img
> 3.7G    /btrfs/sub/raw.img
>
> # du -hs /mnt/test
> 20K     /mnt/test
>
> So even though there is nothing in /mnt/test, the disk image is 
> consuming 3.7GB of space.  Maybe you could test similarly with your 
> server if you have time on your hands.
>
> Thanks!
> Roman Mamedov <mailto:rm@romanrm.net>
> Monday, February 9, 2015 1:40 AM
> On Mon, 09 Feb 2015 00:17:49 -0500
>
> I use KVM (QEMU) with discard pass-through from the VM guest 
> ("discard=unmap"
> option), with the VM images stored on Btrfs. It works just fine, the disk
> space used for the image file does shrink when the guest OS issues 
> discards on
> its FS. Maybe there is a difference in how KVM and the 'loop' module 
> submit
> discards to Btrfs?
>
> Devon B. <mailto:devon.b@virtualcomplete.com>
> Monday, February 9, 2015 12:17 AM
> Looking to use btrfs with disk images that contain ext4, xfs, and other
> possible filesystems. One of my main concerns is reclaiming disk space
> when files are deleted on the disk image's filesystem. Using fstrim on
> the mount point of the disk image or mounting the disk image (loop) with
> discard doesn't appear to pass the freed blocks to btrfs.
>
> The image file on the btrfs filesystem just keeps growing in size. When
> hosting images on ext4, using fstrim or discard frees up the space on
> the host filesystem (ext4).
>
> I see discard is pretty well supported for btrfs to the underlying block
> devices but is there any way to properly free space on the btrfs host
> filesystem from overlying filesystems while they are online?
>
> Thanks.
