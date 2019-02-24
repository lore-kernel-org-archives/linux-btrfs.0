Return-Path: <SRS0=YhH7=Q7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEA8C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Feb 2019 00:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0545020855
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Feb 2019 00:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="JSMmWXb0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfBXAA4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Feb 2019 19:00:56 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44822 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727475AbfBXAA4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Feb 2019 19:00:56 -0500
Received: by mail-lj1-f195.google.com with SMTP id q128so4472470ljb.11
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Feb 2019 16:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k29hLA0EDdLg8ahPYI4Y1WVzx+DGRhii4L2/BjG7Q1o=;
        b=JSMmWXb0U8icK0/UhZ5OIOH0iTTjnMQXlDC6Nq100EMw3RgHA00zHu4g1bRqfM7SNq
         AMzNhW3fS24CZBY7Gl/7KxeEIhzeVk4M7qtLMWfgBpFp+WyWXrV8NzfQUSKFiQJz5zDi
         s1rNu1EW+e4qhF9XBtpFxalsyWrn399cM5G+hSr5o926KgcQB+d94xsbkQAANiSR03AC
         XrLqSWXAgQUzfZx70iCfSHrBOE4eFZgWFOVF3sJf0cHQoKzwjx2bulLBbCUTfwkTjI1T
         UVX9lqSCujViS0p/Xd1rKoj/D3mgA0ubT3eeK6qnBuRawkO8Rk+NQcm1aGd9wrAK0hrV
         ZODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k29hLA0EDdLg8ahPYI4Y1WVzx+DGRhii4L2/BjG7Q1o=;
        b=BsBkmsuSqQfXM54X+qH6S5LtHhCn9KIusAwCZ/s6uQbG5+ENJMsUskZV93JUJZFY/a
         XpvPj8jEbNAs17tENDJYrA5+smL2y0b4APKC6B6OcfHkQeCpgb5s6zt3lwO/BhjOMg29
         H7BndYseOUhhFUGe3uT2mDKU1nbI7205ONpGShkaQSL1+BLEksdJ9PqespcrRPoTCWvC
         pNG0GvyvFa04bZzAqm+2kSHfuj383SgbeoaHgkCdrwsB5gsHcgGZOMKrk8qKm/+/nxwF
         /q71sCnEXi97hJRr8l8k/OYHtHcNAOMBUZdnzWD6PuZO9mUsEkV4HxsElbg+VzZNIhXE
         LWQA==
X-Gm-Message-State: AHQUAuaI/LEhIAdzKR1OyyQn+CZeUjxQd/wVLp1SNeh+CVe9LmA83rki
        FBh/KZUn8zv2Rjm9cJztsC0xdU77a/VNZFzBQU32iIwm
X-Google-Smtp-Source: AHgI3IZRy21sga7q/xUJcNoI7FiguaOyONtv5s6LkqqpJkVzog+nwZvwkP+CzwXwZWLvWU+wixZU+ZYkkQFntYaJlYY=
X-Received: by 2002:a2e:870c:: with SMTP id m12mr5814820lji.24.1550966454051;
 Sat, 23 Feb 2019 16:00:54 -0800 (PST)
MIME-Version: 1.0
References: <7ef0e91501a04cd4c5e0d942db638a0b50ef3ec3.camel@seblu.net>
 <CAJCQCtQ+b9y7fBXPPhB-gQrHAH-pCzau6nP1OabsC1GNqNnE1w@mail.gmail.com>
 <91e2c9ef095eae21f9e88f7b5cf49102571dcba8.camel@seblu.net>
 <CAJCQCtTq8YLmti_tf0oNaSGn94qvGxs-mQeDdvxddE61L0Rjdg@mail.gmail.com> <4fd5e655c49278cf5967b2774ab34e4a0571f722.camel@seblu.net>
In-Reply-To: <4fd5e655c49278cf5967b2774ab34e4a0571f722.camel@seblu.net>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 23 Feb 2019 17:00:42 -0700
Message-ID: <CAJCQCtQzqvtVyzZETUzsH+ZqD8QuFSOGd9fxpEPT3LkLXRbr9A@mail.gmail.com>
Subject: Re: Corrupted filesystem, looking for guidance
To:     =?UTF-8?Q?S=C3=A9bastien_Luttringer?= <seblu@seblu.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 11:14 AM S=C3=A9bastien Luttringer <seblu@seblu.net=
> wrote:



> What I don't get is how this could end up to silent sector corruption or =
let
> accumulate bad sectors. A read timeout, a link reset will end up with an =
error
> kick at minimum one drive from the array, forcing a full rebuild. No?

No. Link resets don't result in a drive being kicked out of an array.

Accumulation happens because a link reset means there's no discrete
read error with sector LBA, which is necessary for md to know what
sector to repair and where to obtain the mirror copy (or stripe
reconstruction from parity if parity raid).

>
> I discovered that my SAS drives have no such timeout and they don't need =
an ERC
> value to be defined. So, I updated my timeout to 180 when my drives are S=
ATA
> and doesn't support ERC. Thanks a lot for making me discovering this.

SAS drives you probably don't need to worry about. I'm pretty sure all
of them do a fast error recovery in less than 30 seconds. I'm not sure
off hand how to discover this, other than digging through manufacturer
specs for that make/model.


> > If you do want to move to strictly Btrfs, I suggest raid5 for data but
> > use raid1 for metadata instead of raid5. Metadata raid 5 writes can't
> > really be assured to be atomic. Using raid1 metadata is less fragile.
> Make sense. Is raid10 suitable (atomic) option for metadata? Looks like
> performance are better than raid1?

It's better performance than raid1, but since the full metadata write
can be striped among multiple drives, you run into the same problem as
with parity raid, which is that metadata write isn't guaranteed to be
completed until all drives commit all parts of that metadata write to
stable media. So it's maybe not really atomic, it depends. I'd expect
SAS drives don't lie, and actually commit to stable media when is says
it has. Therefore barriers should work as expected.


> > --repair should be safe but even in 4.20.1 tools you'll see the man
> > page says it's dangerous and you should ask on list before using it.
> Few month ago I was strongly advised to ask here before calling repair.
> Are you saying that it's no more useful?

Ask on list before using it, or just realize you're taking a chance.
It's quite a lot safer than it used to be a few years ago. But
sometimes it makes things worse still.


> > Well at this point if you ran a those commands the file system is
> > different so you should refresh the thread by posting current normal
> > mount (no options) kernel messages; and also 'btrfs check' output
> > without repair; and also output from btrfs-debug-tree. If the problem
> > is simple enough and a dev has time it might be they get you a file
> > system specific patch to apply and it can be fixed. But it's really
> > important that you stop making changes to the file system in the
> > meantime. Just gather information. Be deliberate.
> It's a pity that there is yet no solution without involving a human. I'll=
 not
> request developer time which could be used to improve the filesystem. :)

Well a lot of times they're able to improve the file system but
figuring out how to fix edge cases resulting in problems.


--=20
Chris Murphy
