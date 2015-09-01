Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:37933 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbbIAElT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 00:41:19 -0400
Subject: Re: btrfs regression since 4.X kernel NULL pointer dereference
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@lst.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>
References: <55D8B193.8010906@profihost.ag> <20150825090030.GF31630@lst.de>
 <20150825135146.GE7176@ret.masoncoding.com>
 <590FB3C7-8BCA-4B04-BBB0-92863E02A89C@profihost.ag>
 <20150901000610.GC5136@ret.masoncoding.com>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <55E52C6D.6050504@profihost.ag>
Date: Tue, 1 Sep 2015 06:41:17 +0200
MIME-Version: 1.0
In-Reply-To: <20150901000610.GC5136@ret.masoncoding.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 01.09.2015 um 02:06 schrieb Chris Mason:
> On Mon, Aug 31, 2015 at 07:32:09PM +0200, Stefan Priebe - Profihost AG wrote:
>>> Am 25.08.2015 um 15:51 schrieb Chris Mason <clm@fb.com>:
>>>
>>>> On Tue, Aug 25, 2015 at 11:00:30AM +0200, Christoph Hellwig wrote:
>>>> I think this is btrfs using a struct block_device that doesn't have
>>>> a valid queue pointer in it's gendisk for ->s_bdev.  And there are
>>>> some fishy looking ->s_bdev assignments in the code which I suspect
>>>> are related to it:
>>>>
>>>> fs/btrfs/dev-replace.c: if (fs_info->sb->s_bdev == src_device->bdev)
>>>> fs/btrfs/dev-replace.c:         fs_info->sb->s_bdev = tgt_device->bdev;
>>>> fs/btrfs/volumes.c:     if (device->bdev == root->fs_info->sb->s_bdev)
>>>> fs/btrfs/volumes.c:             root->fs_info->sb->s_bdev = next_device->bdev;
>>>> fs/btrfs/volumes.c:     if (tgtdev->bdev == fs_info->sb->s_bdev)
>>>> fs/btrfs/volumes.c:             fs_info->sb->s_bdev = next_device->bdev;
>>>
>>> We've had trouble with this in the past, I'll take a look.
>>
>> Any news?
>
> Haven't been able to reproduce yet, I'll try again in the morning.

Thanks. We're using schroot like the user in this bugreport:
https://bugzilla.kernel.org/show_bug.cgi?id=100911

But he also claims he found another way to reproduce using vfcgbackup 
(last comment).

Stefan

>
> -chris
>
