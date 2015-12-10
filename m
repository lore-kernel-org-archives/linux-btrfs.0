Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34527 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbbLJVvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 16:51:18 -0500
Received: by mail-ig0-f178.google.com with SMTP id g19so27484160igv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 13:51:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20151210213515.GB11639@localhost.localdomain>
References: <20151209042528.GA2413@codemonkey.org.uk>
	<20151210190220.GA11257@ret.masoncoding.com>
	<20151210193555.GA23535@codemonkey.org.uk>
	<20151210213024.GC11257@ret.masoncoding.com>
	<20151210213515.GB11639@localhost.localdomain>
Date: Thu, 10 Dec 2015 21:51:17 +0000
Message-ID: <CAL3q7H7idBFER25hh3FUa95KkS7OpVTi1HLNQrYw6_q9XUfvPA@mail.gmail.com>
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
From: Filipe Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <clm@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Josef Bacik <jbacik@fb.com>, dsterba@suse.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 9:35 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Dec 10, 2015 at 04:30:24PM -0500, Chris Mason wrote:
>> On Thu, Dec 10, 2015 at 02:35:55PM -0500, Dave Jones wrote:
>> > On Thu, Dec 10, 2015 at 02:02:20PM -0500, Chris Mason wrote:
>> >  > On Tue, Dec 08, 2015 at 11:25:28PM -0500, Dave Jones wrote:
>> >  > > Not sure if I've already reported this one, but I've been seeing this
>> >  > > a lot this last couple days.
>> >  > >
>> >  > > kernel BUG at mm/page-writeback.c:2654!
>> >  > > invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
>> >  > > CPU: 1 PID: 2566 Comm: trinity-c1 Tainted: G        W       4.4.0-rc4-think+ #14
>> >  > > task: ffff880462811b80 ti: ffff8800cd808000 task.ti: ffff8800cd808000
>> >  > > RIP: 0010:[<ffffffff8826ff40>]  [<ffffffff8826ff40>] clear_page_dirty_for_io+0x180/0x1d0
>> >  >
>> >  > Huh, are you able to reproduce at will?  From this code path it should
>> >  > mean somebody else is unlocking a page they don't own.
>> >
>> > pretty easily yeah. I hit it maybe a couple dozen times yesterday.
>> > So if you've got some idea of printk's to spray anywhere I can give
>> > that a shot.
>>
>> I'd rather try to trigger it here.  Going to have to add some way to
>> record which stack trace last unlocked and/or freed the page.
>
> Looks like a bisect with 4.3 might target the commit.

Not necessarily a regression added in 4.3. We've had this issue
reported before on older releases, like 4.1 for example:

https://lkml.org/lkml/2015/5/19/190

>
> Thanks,
>
> -liubo
>>
>> -chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
