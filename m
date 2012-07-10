Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:43515 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab2GJFho (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jul 2012 01:37:44 -0400
Message-ID: <4FFBBF59.2020505@huawei.com>
Date: Tue, 10 Jul 2012 13:36:25 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: chandan r <chandanrmail@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Add code to support file creation time.
References: <87ipe43sgg.fsf@gmail.com> <4FF3F740.3070601@huawei.com> <CAB9VWqCjsAUd26-HsmHMAskx-LxO0ZyNxRk+4cQvaAbxQ2GiYA@mail.gmail.com> <4FF4E8C5.4030507@huawei.com> <CAB9VWqDBoY877tNh1J6Z=oD0Ao8H1mUPGFb-O93_OPVvCt_A-g@mail.gmail.com>
In-Reply-To: <CAB9VWqDBoY877tNh1J6Z=oD0Ao8H1mUPGFb-O93_OPVvCt_A-g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/7/5 9:52, Alexander Block wrote:

> On Thu, Jul 5, 2012 at 3:07 AM, Li Zefan <lizefan@huawei.com> wrote:
>> On 2012/7/4 19:04, Alexander Block wrote:
>>
>>> On Wed, Jul 4, 2012 at 9:56 AM, Li Zefan <lizefan@huawei.com> wrote:
>>>> On 2012/7/4 15:18, chandan r wrote:
>>>>
>>>>> This patch adds a new member to the 'struct btrfs_inode' structure to hold
>>>>> the file creation time.
>>>>>
>>>>
>>>>
>>>> Well, how do users use this file creation time? There's no syscall and there's
>>>> no ioctl that exports this information. That xstat syscall hasn't been accepted,
>>>> so you can revise and repost the patch when you see it happens.
>>> In my opinion we should still include this patch. Currently, otime is never even
>>> initialized, having undefined values. If it ever gets possible to
>>> access otime, we
>>> would at least have some inodes with valid otime fields.
>>
>>
>> otime (on disk) is initialized to 0, not some undefined value. But yeah, your point makes
>> some sense, that with this patch we can access valid otime in an old filesystem once we
>> update to a new kernel which has otime support.
> This is true for the inode items found in the root tree. But the inode
> items found in the filesystem trees are not initialized at all. I did
> a fast check by adding printing of the otime field in
> btrfs-debug-tree...and every inode's otime looks random.
> btrfs_new_inode uses btrfs_insert_empty_items which does not zero the
> new item, then fill_inode_item is used to initialize the fields and
> there otime is missing.
> 


That's bad..
