Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:32881 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965369AbcAURXi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 12:23:38 -0500
Received: by mail-io0-f178.google.com with SMTP id q21so61502068iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 09:23:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20160121T152848-821@post.gmane.org>
References: <loom.20160116T132316-196@post.gmane.org>
	<pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
	<loom.20160120T143906-108@post.gmane.org>
	<56A0956B.7060706@cn.fujitsu.com>
	<loom.20160121T152848-821@post.gmane.org>
Date: Thu, 21 Jan 2016 10:23:37 -0700
Message-ID: <CAJCQCtQr18LnkrxpnBR0MrTjLGuUd=wPsa9+NoW-TfrycT8Zvw@mail.gmail.com>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
From: Chris Murphy <lists@colorremedies.com>
To: Al <6401e46d@opayq.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 7:53 AM, Al <6401e46d@opayq.com> wrote:
>>> Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
>> >
>> > .. unless you're really short of
>> > block dev space (!), which is a pretty naff dedup strategy,
>
>> > I'm looking forward to using it; keep up the very good work.
>
>> If you really think the design is naff, I'm very glad if you can provide
>> a better one.
>
> Wenruo, I would suggest that you concentrate on your English comprehension
> before you reply in such a manner.

Going back and rereading the "naff" comment in context, I find it
confusing. So I guess my English comprehension requires concentration
also. I'd like to think you're saying that being short of block device
space while relying on on-disk hash table dedup (rather than
in-memory) is not a good idea for the user to do to himself? I can't
tell, but if that table is in its own tree, the user isn't likely to
run into that problem. Anyway, naff has a negative connotation to it
so it sounds like it's a backhanded criticism. Maybe there's something
being lost in translation between British and American English.

.
>
> Address your emotional problems in a more appropriate place.

You just stepped into the same pile of poo you're accusing Qu of stepping in.



-- 
Chris Murphy
