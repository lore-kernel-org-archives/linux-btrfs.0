Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36336 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2GDLEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 07:04:22 -0400
Received: by pbbrp8 with SMTP id rp8so10872057pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 04:04:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF3F740.3070601@huawei.com>
References: <87ipe43sgg.fsf@gmail.com>
	<4FF3F740.3070601@huawei.com>
Date: Wed, 4 Jul 2012 13:04:22 +0200
Message-ID: <CAB9VWqCjsAUd26-HsmHMAskx-LxO0ZyNxRk+4cQvaAbxQ2GiYA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: Add code to support file creation time.
From: Alexander Block <ablock84@googlemail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: chandan r <chandanrmail@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 4, 2012 at 9:56 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2012/7/4 15:18, chandan r wrote:
>
>> This patch adds a new member to the 'struct btrfs_inode' structure to hold
>> the file creation time.
>>
>
>
> Well, how do users use this file creation time? There's no syscall and there's
> no ioctl that exports this information. That xstat syscall hasn't been accepted,
> so you can revise and repost the patch when you see it happens.
In my opinion we should still include this patch. Currently, otime is never even
initialized, having undefined values. If it ever gets possible to
access otime, we
would at least have some inodes with valid otime fields.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
