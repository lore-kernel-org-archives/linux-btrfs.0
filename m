Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36279 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbbHUFcY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 01:32:24 -0400
Received: by pdbmi9 with SMTP id mi9so22497109pdb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 22:32:23 -0700 (PDT)
References: <1440126612-53381-1-git-send-email-bhlee.kernel@gmail.com> <013101d0dbc4$7e5ab090$7b1011b0$@cn.fujitsu.com>
From: Byongho Lee <bhlee.kernel@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix memory leaks in error path
In-reply-to: <013101d0dbc4$7e5ab090$7b1011b0$@cn.fujitsu.com>
Date: Fri, 21 Aug 2015 14:32:18 +0900
Message-ID: <878u95i4v1.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Zhao Lei writes:

> Hi, Byongho Lee
>
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org
>> [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Byongho Lee
>> Sent: Friday, August 21, 2015 11:10 AM
>> To: linux-btrfs@vger.kernel.org
>> Subject: [PATCH] btrfs-progs: fix memory leaks in error path
>> 
>> This patch includes below fixes in error path:
>> 1. fix memory leaks if realloc() fails
>> 2. add missing call free_history() before return error in scrub_read_file()
>> 
>> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>
>> ---
>>  btrfs-list.c |  8 ++++++++
>>  cmds-scrub.c | 18 ++++++++++++++----
>>  qgroup.c     |  8 ++++++++
>
>
> Similar problem in cmds-send.c:
> cmds-send.c:    s->clone_sources = realloc(s->clone_sources,
>

Thank you for feedback.

You're right, I missed that point.
I'll prepare v2 patch.

Regards,
Lee
