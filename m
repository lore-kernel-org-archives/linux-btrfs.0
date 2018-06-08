Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32905 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751128AbeFHI6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2018 04:58:07 -0400
Subject: Re: [PATCH] btrfs-progs: check: Initialize all filed of
 btrfs_inode_item in insert_inode_item()
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, <dsterba@suse.cz>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1528339598.git.misono.tomohiro@jp.fujitsu.com>
 <a9e2495c-6085-4efb-5257-f58a5019e2b7@jp.fujitsu.com>
 <20180607122246.GB3215@twin.jikos.cz>
 <56d8305a-8d52-49ad-fdff-61269e01192a@jp.fujitsu.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <8bfb2fb7-f70d-7bb8-b351-01dd6dacf4a0@cn.fujitsu.com>
Date: Fri, 8 Jun 2018 17:04:09 +0800
MIME-Version: 1.0
In-Reply-To: <56d8305a-8d52-49ad-fdff-61269e01192a@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/08/2018 08:43 AM, Misono Tomohiro wrote:
> On 2018/06/07 21:22, David Sterba wrote:
>> On Thu, Jun 07, 2018 at 11:49:58AM +0900, Misono Tomohiro wrote:
>>> Initialize all filed of btrfs_inode_item to zero in order to prevent
>>> having some garbage, especially for flags field.
>>
>> Have you observed in practice or is it a matter of precaution?
> 
> I saw failure of fsck-test/010 in yesterday's devel branch and
> made this patch. It turned out that root cause was wrong flag comparison
> in btrfs check.
> (https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg77758.html)
> 
> With Su's fix, failure of fsck-test/010 is also gone without this patch,
> but it is better to initialize the variables anyway.
> 
Agreed. I saw odd flags reported by btrfs check too.
The callers of insert_inode_item() don't set inode flags manully.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


