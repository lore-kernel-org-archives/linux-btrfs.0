Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36398 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbcJAUVP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 16:21:15 -0400
Received: by mail-vk0-f47.google.com with SMTP id y190so100085962vkd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Oct 2016 13:21:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160729175310.GA22477@localhost.localdomain>
References: <1469670123-19839-1-git-send-email-bo.li.liu@oracle.com>
 <pan$5450c$1d8fe409$834c6bbc$1311860c@applied-asynchrony.com>
 <20160728184914.GA29799@localhost.localdomain> <20160729170150.GE30795@twin.jikos.cz>
 <20160729175310.GA22477@localhost.localdomain>
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
Date: Sat, 1 Oct 2016 23:13:36 +0300
Message-ID: <CAOcd+r3YBut48a52_9=9zEg7T+Wwdq=V_gGWaXXN6s9-=j8FGg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: deal with unexpected return value in flush_space
To: David Sterba <dsterba@suse.cz>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David, Holger,

Thank you for picking up that old patch of mine.

Alex.


On Fri, Jul 29, 2016 at 8:53 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Jul 29, 2016 at 07:01:50PM +0200, David Sterba wrote:
>> On Thu, Jul 28, 2016 at 11:49:14AM -0700, Liu Bo wrote:
>> > > For reviewers - this came up before here:
>> > > https://patchwork.kernel.org/patch/7778651/
>
> David, this patch made a mistake in commit log.
>
>> > >
>> > > Same fix basically.
>> >
>> > Aha, I've given it my Reviewed-by.
>> >
>> > Taking either one works for me, I can make the clarifying comment into a
>> > seperate patch if we need to.
>>
>> I'll pick the first patch and please send the separate comment update.
>> Thanks.
>
> Sure.
>
> Thanks,
>
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
