Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63162 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaF0RwM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 13:52:12 -0400
Received: by mail-qa0-f46.google.com with SMTP id i13so4222941qae.5
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 10:52:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53ADA6A4.3000303@gmail.com>
References: <CAMXuLLrhMv82LPveRemDU_v_Kru2US6sKVn377gS3t9p-VFrag@mail.gmail.com>
	<53AD9D1A.4050703@libero.it>
	<53ADA6A4.3000303@gmail.com>
Date: Fri, 27 Jun 2014 13:52:11 -0400
Message-ID: <CAMXuLLrEPvi80WkiVJwE=h1N7Gc5jaGvCS9CCHVke_x7ac=ZVQ@mail.gmail.com>
Subject: Re: [Question] Btrfs on iSCSI device
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 1:15 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-06-27 12:34, Goffredo Baroncelli wrote:
>> Hi,
>> On 06/27/2014 05:44 PM, Zhe Zhang wrote:
>>> Hi,
>>>
>>> I setup 2 Linux servers to share the same device through iSCSI. Then I
>>> created a btrfs on the device. Then I saw the problem that the 2 Linux
>>> servers do not see a consistent file system image.
>>>
>>> Details:
>>> -- Server 1 running kernel 2.6.32, server 2 running 3.2.1
>>> -- Both running btrfs v0.20-rc1
>>> -- Server 2 has device /dev/vdc, exposed as iSCSI target
>>>  -- Server 1 mounts the device as /dev/sda
>>> -- Server 1 'mount /dev/sda /mnt/btrfs'; server 2 'mount /dev/vdc /mnt/btrfs',
>>>  -- When server 1 'touch /mnt/btrfs/foo', server 2 doesn't see any
>>> file under /mnt/btrfs
>>> -- I created /mnt/btrfs/foo on server 2 as well; then I added some
>>> content from both server 1 and server 2 to /mnt/btrfs/foo
>>> -- After that each server sees the content it adds, but not the
>>> content from the other server
>>> -- Both server 'umount /mnt/btrfs', and mount it again
>>> -- Then both servers see /mnt/btrfs/foo with the content added from
>>> server 2 (I guess it's because server 2 created the foo file later
>>> than server 1).
>>>
>>> I did a similar test on ext4 and both servers see a consistent image
>>> of the file system. When server 1 creates a foo file server 2
>>> immediately sees it.
>>>
>>> Is this how btrfs is supposed to work?
>>
>> I don't think that it is possible to mount the _same device_ at the _same time_ on two different machines. And this doesn't depend by the filesystem.
>>
>> The fact that you see it working, I suspect that is is casual.
>>
>> When I tried this (same scsi HD connected to two machines), I had to ensure that the two machines never accessed to the HD at the same time.
>>
>>>
>>> Thanks,
>>>
>>> Zhe
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
> If you need shared storage like that, you need to use a real cluster
> filesystem like GFS2 or OCFS2, BTRFS isn't designed for any kind of
> concurrent access to shared storage from separate systems.
> The reason it appears to work when using iSCSI and not with directly
> connected parallel SCSI or SAS is that iSCSI doesn't provide low level
> hardware access.
>

I did more testing with ext4 and it supports what Goffredo and Austin
said above. Error message is "cannot access xxx: Input/output error".

It seems to me that both servers hold some file system data structures
in memory and eventually conflict with each other (like writing inode
info to the same blocks).
