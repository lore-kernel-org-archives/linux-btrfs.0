Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60031 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2GEBw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 21:52:26 -0400
Received: by ghrr11 with SMTP id r11so6937511ghr.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 18:52:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF4E8C5.4030507@huawei.com>
References: <87ipe43sgg.fsf@gmail.com>
	<4FF3F740.3070601@huawei.com>
	<CAB9VWqCjsAUd26-HsmHMAskx-LxO0ZyNxRk+4cQvaAbxQ2GiYA@mail.gmail.com>
	<4FF4E8C5.4030507@huawei.com>
Date: Thu, 5 Jul 2012 03:52:25 +0200
Message-ID: <CAB9VWqDBoY877tNh1J6Z=oD0Ao8H1mUPGFb-O93_OPVvCt_A-g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Add code to support file creation time.
From: Alexander Block <ablock84@googlemail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: chandan r <chandanrmail@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 5, 2012 at 3:07 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2012/7/4 19:04, Alexander Block wrote:
>
>> On Wed, Jul 4, 2012 at 9:56 AM, Li Zefan <lizefan@huawei.com> wrote:
>>> On 2012/7/4 15:18, chandan r wrote:
>>>
>>>> This patch adds a new member to the 'struct btrfs_inode' structure to hold
>>>> the file creation time.
>>>>
>>>
>>>
>>> Well, how do users use this file creation time? There's no syscall and there's
>>> no ioctl that exports this information. That xstat syscall hasn't been accepted,
>>> so you can revise and repost the patch when you see it happens.
>> In my opinion we should still include this patch. Currently, otime is never even
>> initialized, having undefined values. If it ever gets possible to
>> access otime, we
>> would at least have some inodes with valid otime fields.
>
>
> otime (on disk) is initialized to 0, not some undefined value. But yeah, your point makes
> some sense, that with this patch we can access valid otime in an old filesystem once we
> update to a new kernel which has otime support.
This is true for the inode items found in the root tree. But the inode
items found in the filesystem trees are not initialized at all. I did
a fast check by adding printing of the otime field in
btrfs-debug-tree...and every inode's otime looks random.
btrfs_new_inode uses btrfs_insert_empty_items which does not zero the
new item, then fill_inode_item is used to initialize the fields and
there otime is missing.
