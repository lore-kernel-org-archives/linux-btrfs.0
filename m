Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:44907 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752565Ab2I3IMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 04:12:38 -0400
Message-ID: <5067FF1A.5060804@gmx.net>
Date: Sun, 30 Sep 2012 10:13:14 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: Li Zefan <lizefan@huawei.com>, chandan r <chandanrmail@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Add code to support file creation time.
References: <87ipe43sgg.fsf@gmail.com> <4FF3F740.3070601@huawei.com> <CAB9VWqCjsAUd26-HsmHMAskx-LxO0ZyNxRk+4cQvaAbxQ2GiYA@mail.gmail.com>
In-Reply-To: <CAB9VWqCjsAUd26-HsmHMAskx-LxO0ZyNxRk+4cQvaAbxQ2GiYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/12 13:04, Alexander Block wrote:
> On Wed, Jul 4, 2012 at 9:56 AM, Li Zefan <lizefan@huawei.com> wrote:
>> On 2012/7/4 15:18, chandan r wrote:
>>
>>> This patch adds a new member to the 'struct btrfs_inode' structure to hold
>>> the file creation time.
>>>
>>
>>
>> Well, how do users use this file creation time? There's no syscall and there's
>> no ioctl that exports this information. That xstat syscall hasn't been accepted,
>> so you can revise and repost the patch when you see it happens.
> In my opinion we should still include this patch. Currently, otime is never even
> initialized, having undefined values. If it ever gets possible to
> access otime, we
> would at least have some inodes with valid otime fields.

I'll second that, even if by now the fields get correctly initialized.
Why should we zero the fields instead of setting them to the correct
values?

-Arne

