Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65350 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3BUOT7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 09:19:59 -0500
Received: by mail-ob0-f177.google.com with SMTP id wc18so8679990obb.8
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 06:19:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130221132627.GC12051@shiny.masoncoding.com>
References: <CAKcLGm9g-c8oJu_ZymZ+kiAb_fq219AeUNXRrw4kdQQw9gM_BQ@mail.gmail.com>
	<5125ED66.4060405@cn.fujitsu.com>
	<20130221132627.GC12051@shiny.masoncoding.com>
Date: Thu, 21 Feb 2013 08:19:58 -0600
Message-ID: <CAKcLGm8v4n5OMtEY-NBERm-z1F5re0su3cgMxmqoruYsVAhatQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix wrong outstanding_extents when doing DIO write
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Chris Mason <chris.mason@fusionio.com>, Miao Xie <miaox@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 7:26 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Thu, Feb 21, 2013 at 02:48:22AM -0700, Miao Xie wrote:
>> When running the 083th case of xfstests on the filesystem with
>> "compress-force=lzo", the following WARNINGs were triggered.
>>   WARNING: at fs/btrfs/inode.c:7908
>>   WARNING: at fs/btrfs/inode.c:7909
>>   WARNING: at fs/btrfs/inode.c:7911
>>   WARNING: at fs/btrfs/extent-tree.c:4510
>>   WARNING: at fs/btrfs/extent-tree.c:4511
>>
>> This problem was introduced by the patch "Btrfs: fix deadlock due
>> to unsubmitted". In this patch, there are two bugs which caused
>> the above problem.
>
> I saw this as well on test 132 last night.  My plan was to track it down
> this morning, so discovering it already fixed while I slept was
> wonderful.
>
> Thanks Miao.  Josef I've got this one and Miao's defrag unmount patch
> queued up.
>

Thanks, I've also tested this patch, and it cleared the error I was receiving.
