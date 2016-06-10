Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36753 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbcFJRkQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 13:40:16 -0400
Received: by mail-vk0-f49.google.com with SMTP id g67so106785046vkb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 10:40:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160610172203.GB18657@angband.pl>
References: <87y47g1esh.fsf@thinkpad.rath.org> <87fuslg19q.fsf@vostro.rath.org>
 <ec929c7d-079d-8ea5-87d7-fce0ed1c45b7@gmail.com> <87twh1t4xv.fsf@thinkpad.rath.org>
 <20160610165046.GA18657@angband.pl> <271297eb-f557-4b9b-e236-81dd3f70c1be@gmail.com>
 <20160610172203.GB18657@angband.pl>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 10 Jun 2016 19:40:14 +0200
Message-ID: <CAPmG0jZSe-uxFKC1pGMyAzfVmQO7HwL90HHLpph=U-c=bBscDw@mail.gmail.com>
Subject: Re: fsck: to repair or not to repair
To: Adam Borowski <kilobyte@angband.pl>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Nikolaus Rath <Nikolaus@rath.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 7:22 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Fri, Jun 10, 2016 at 01:12:42PM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-06-10 12:50, Adam Borowski wrote:
>> >And, as of coreutils 8.25, the default is no reflink, with "never" not being
>> >recognized even as a way to avoid an alias.  As far as I remember, this
>> >applies to every past version with support for reflinks too.
>> >
>> Odd, I could have sworn that was an option...
>>
>> And I do know there was talk at least at one point of adding it and
>> switching to reflink=auto by default.
>
> Yes please!
>
> It's hard to come with a good reason for not reflinking when it's possible
> -- the only one I see is if you have a nocow VM and want to slightly improve
> speed at a cost of lots of disk space.  And even then, there's cat a >b for
> that.

For a nocow VM imagefile, reflink anyhow does not work so cp
--reflink=auto would then just duplicate the whole thing, do doing a
'cp --reflink=never' (never works for --sparse), either silently or
with a warning/note.

For a cow VM imagefile, the only thing I do and want w.r.t. cp is
reflink=always, so I also vote for auto on by default.

If you want to 'defrag' a VM imagefile, using cat or dd and enough RAM
does a better and faster job than cp or btrfs manual defrag.

> And the cost on non-btrfs non-unmerged-xfs is a single syscall per file,
> that's utterly negligible compared to actually copying the data.
>
> --
> An imaginary friend squared is a real enemy.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
