Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34540 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3AJIq6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 03:46:58 -0500
Received: by mail-ie0-f178.google.com with SMTP id c12so372421ieb.23
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 00:46:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EE3492.4030704@cn.fujitsu.com>
References: <CAOcd+r1VfBCRmDptpp47CLDAbH-o+NpAQxx42ou5JVG-hfM0PA@mail.gmail.com>
	<50EE3492.4030704@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 10:46:58 +0200
Message-ID: <CAOcd+r0QunaHT2bAMjVV5RWbJx09WVRLuGbhTRJf2EAJGbPp_w@mail.gmail.com>
Subject: Re: [PATCH 0/2] send: Avoid sending disknr==0 and PREALLOC extents
 when possible
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: Alexander Block <ablock84@googlemail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Arne Jansen <sensille@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chen,
thanks for reviewing.

I partially disagree with you. The new command(s) is required when the
code detects a change and wants to communicate this change to the
receive side. My patch addresses the cases when
- no new command is required to communicate the change (patch1)
- there is no change that is needed to be communicated (patch 2)

So even if/when new command is added, my patch still holds, I believe.
However, let's see what others will comment.

Thanks,
Alex.


On Thu, Jan 10, 2013 at 5:25 AM, Chen Yang <chenyang.fnst@cn.fujitsu.com> wrote:
> Hi, Alex
> The patches can only solve part of questions, but some like "punch holes" problems
> as Alexander wrote are still unsolved. So I think these patches are unnecessary
> if adding new command would help to solve all the questions.
>
> Chen.
>
> On 2013-1-9 4:11, Alex Lyakas wrote:
>> These two patches address the issue of sending unneeded zero data for
>> disknr==0 and PREALLOC extents.
>> There is room for additional improvement for PREALLOC extents, but it
>> requires adding a new command, so for
>> now this is not addressed.
>>
>> Please review and comment.
>>
>> Thanks,
>> Alex.
>>
>> Alex Lyakas (2):
>>   Avoid sending disknr==0 extents in the following cases:     1) full
>>     send 2) new inode in a diff-send 3) when disknr==0 extents are
>>     added to the end of an inode
>>   On a diff-send, avoid sending PREALLOC extents, if the parent root
>>     has only     PREALLOC extents on an appropriate file range.
>>
>>  fs/btrfs/send.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 172 insertions(+), 6 deletions(-)
>>
>> --
>> 1.7.9.5
>>
>
