Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:43445 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbBMVz4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 16:55:56 -0500
Received: by mail-yk0-f182.google.com with SMTP id 142so5007743ykq.13
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 13:55:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54DDD85D020000AF000D6A9E@frodo.1stsolutions.be>
References: <54DDB3A9020000AF000D6A8D@frodo.1stsolutions.be>
	<CAJCQCtS5acWHChw3ww8phg7tE0JOf9EfwA8nROdecBVrvtaj-w@mail.gmail.com>
	<54DDD85D020000AF000D6A9E@frodo.1stsolutions.be>
Date: Fri, 13 Feb 2015 14:55:55 -0700
Message-ID: <CAJCQCtQ5o_7LugCVSkRmXvYVtZhCwY9z6JU+R7Hu5-pSt09tAA@mail.gmail.com>
Subject: Re: Betr.: Re: slow system
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 13, 2015 at 2:56 AM, Roel Niesen <Roel.Niesen@1stsolutions.be>
wrote:

>  Hi,
>
> No subvolumes or snapshots.
> I already compiled the kernel 3.18.5 for ubuntu with scst.
> I also compiled btrfs-progs 3.18.2.
>
> I tried to install them this weekend.
>
> Can I remove the 2 added disk with only metadata on it to replace the 2
> borken ones?
>

I would do this only after back up is updated, the kernel is updated, and
you've made the recommended timer changes. All you need to do is btrfs dev
delete for the two devices you want removed.

What I don't know off hand is if it's OK to delete both devices right away
at the same time. So unless you want to find out (i.e. take a risk) I
suggest either waiting for someone else to reply whether this should work,
or I'd delete them separately: wait for the first delete to succeed before
starting the next one.


> btrfs replaces somthing ?
>

Not necessary because you've already added two devices. So you can just
delete the two you want removed.


-- 
Chris Murphy
