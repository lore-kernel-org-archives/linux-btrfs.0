Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:54880 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbbBCLgm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 06:36:42 -0500
Received: by mail-la0-f51.google.com with SMTP id ge10so50724897lab.10
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2015 03:36:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6ada49cc-4bf0-4a9d-8ed7-27754af3639c@aei.ca>
References: <1422862299-7361-1-git-send-email-forrestl@synology.com>
	<9348c3e9-9858-4c1a-9489-fab558f1e169@aei.ca>
	<6ada49cc-4bf0-4a9d-8ed7-27754af3639c@aei.ca>
Date: Tue, 3 Feb 2015 19:36:40 +0800
Message-ID: <CAJSVwFP89ZSqtL1Y2E12KXE8y+hhs_JkbqWqcidcfvc920HSMw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix find_free_dev_extent() malfunction in case
 device tree has hole
From: Forrest Liu <forrestl@synology.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-02-03 2:40 GMT+08:00 Ed Tomlinson <edt@aei.ca>:
> On Monday, February 2, 2015 9:39:06 AM EST, Ed Tomlinson wrote:
>
> Hi
>
> Booting a kernel with the three patches:
> [PATCH] Btrfs: fix find_free_dev_extent() malfunction in case device tree
> has hole
> [PATCH] Btrfs: btrfs_release_extent_buffer_page() didn't free pages of dummy
> extent
> [PATCH] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete unused block
> group
>
> generates lots of opps here (I hate to post an anemic report but my serial
> console was not recording so I do not have the opps).  They occured when
> starting X and, If I read them correctly, had something to do with extents.
>

My fault, i should test these patches before i submit these patches.
The oops was caused by patch
"Btrfs: btrfs_release_extent_buffer_page() didn't free pages of dummy extent"

I will resend these patches after test on linux-3.19-rc7.

Thanks
Forrest

> Anyone else?
>
> Thanks
> Ed Tomlinson
>
>> Hi,
>>
>> Found a problem compile testing this.
>> hole_size = key_offset - search_start;
>>
>> Should not that be key.offset ?
>>
>> TIA
>> Ed Tomlinson
>>
>>
>> On Monday, February 2, 2015 2:31:39 AM EST, Forrest Liu wrote:
>>>
>>> If device tree has hole, find_free_dev_extent() cannot find available
>>> address properly.
>>>
>>> The example below, has one BIG hole in device tree, and can only
>>> allocate just one chunk in a transaction.
>>>
>>>     item 9 key (1 DEV_EXTENT 273841913856) itemoff 15811 itemsize 48 ...
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
