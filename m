Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36668 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbcDRUwp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 16:52:45 -0400
Received: by mail-lf0-f44.google.com with SMTP id g184so231523584lfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 13:52:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8+__7sEnSjtpSSG+Wu+J-582bE4guSwP3L3ZUU8N0r-9ATVg@mail.gmail.com>
References: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
	<CAJCQCtTh_nDmjf+5MMkHoi6oe4wM51o709m24xZpagT5PMWuQw@mail.gmail.com>
	<CAC8+__7sEnSjtpSSG+Wu+J-582bE4guSwP3L3ZUU8N0r-9ATVg@mail.gmail.com>
Date: Mon, 18 Apr 2016 22:52:43 +0200
Message-ID: <CAPmG0jZdWexpZH0pSNTS_PX8cp66oNxw7KViDXMxUgkA+gCm6g@mail.gmail.com>
Subject: Re: [resend] btrfs-send -c fails: reproduction case
From: Henk Slager <eye1tm@gmail.com>
To: Zachary Vance <vanceza@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> Reproduction case after running into the same problem as Paride
>>> Legovini:
>>> http://article.gmane.org/gmane.comp.file-systems.btrfs/48706/match=send

Your case is not the same as in this thread from Paride IMO. The error
message is the same, but that doesn't mean the call tree leading to it
is the same. My first impression from your 1st and also your 2nd (in
resend thread) example was that btrfs' error message is correct and
usage of -c is wrong.

More important is that the problem that Paride describes, is solved
for kernel/tools v4.5.0/v4.5.1

[...]
> Every time I start asking about snapshots people tell me how I could
> set up my process differently which is annoying because:
> 1) They assume I'm doing a single, incremental backup process, which is wrong
> 2) I already have years/terabytes pf data I need to transfer, so I
> can't change what I did in the past
> 3) They inevitably recommend their favorite method, which doesn't work
> for me, because I have different requirements

You would have to write a clear set of requirements, as an extension
to what btrfs send|receive currently can do.
>From the examples it is simply not clear what you want.

[...]
> Anyway, I'm doing a one-time transfer of a large number of snapshots
> which are currently stuck on a .img file. Over the years they've been

So, this is yet another problem; What is the background here?

> re-organized repeatedly and I've snapshotted many from writable to
> read-only (most of the cases of the parent being deleted, I think). My
> goal is to get them into a new filesystem, but I can't do a full send
> in every case, because then it would balloon up to a petabyte or so.

This gives some hint what the situation is. How many ro snapshots is
it? How much data in total as uncompressed diskblocks?

>> Does that make more sense now, or were you actually already doing it that
>> way and still getting the errors, and just didn't say so, or did I just
>> confuse you even further (hopefully not!)?
>
> I was already making sure all -c references were both present and
> unmodified, I think the confusion is mostly around whether the parent
> required to use -c, and whether it's an implicit reference volume in
> particular. If it's required, it's impossible to preserve
> de-duplication after deleting the original parent which would be
> really bad.

Can you give examples for your real data how bad it is? And how you
expect or want it to be ?
