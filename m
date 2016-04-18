Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35305 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbcDRBqe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 21:46:34 -0400
Received: by mail-wm0-f54.google.com with SMTP id a140so99340561wma.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 18:46:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTh_nDmjf+5MMkHoi6oe4wM51o709m24xZpagT5PMWuQw@mail.gmail.com>
References: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
 <CAJCQCtTh_nDmjf+5MMkHoi6oe4wM51o709m24xZpagT5PMWuQw@mail.gmail.com>
From: Zachary Vance <vanceza@gmail.com>
Date: Sun, 17 Apr 2016 18:46:13 -0700
Message-ID: <CAC8+__7sEnSjtpSSG+Wu+J-582bE4guSwP3L3ZUU8N0r-9ATVg@mail.gmail.com>
Subject: Re: [resend] btrfs-send -c fails: reproduction case
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+linux-btrfs and with new policy

On 04/16/2016 08:37 PM, Duncan wrote:
> Zachary Vance posted on Sat, 16 Apr 2016 13:08:17 -0700 as excerpted:
>
>> Reproduction case after running into the same problem as Paride
>> Legovini:
>> http://article.gmane.org/gmane.comp.file-systems.btrfs/48706/match=send
>
> [As a btrfs user and list-regular with a personal use-case that doesn't
> include send/receive, I generally skip posts on that topic, leaving them
> for those with more direct experience. Except... the above thread didn't
> seem to get /any/ replies except from others with the same problem, and
> while you just posted yours a few hours ago, yours hasn't either so far.
> But while I don't follow send/receive /that/ closely and could be wrong,
> I did happen to read this one and think I know the problem, so...]

So... I may need to re-send the original post, basically, Chris Murphy
privately pointed a problem with my mail hosting which causes it to be
classified as spam by gmail. (Mailing lists can't validly format mail
as me with my restrictive SPF policy).

> OK, now you delete the parent subvolumes and the subvolume that contained
> them, leaving:
>
> /root/ (pwd and there originally)
> |
> + a/ (/root/a, ro snap of (now deleted) /root/m/a, no parent left)
> |
> + b/ (/root/b, ro snap of (now deleted) /root/m/b, no parent left)
>
>> [root@burn ~]# sudo btrfs send -c a b >/dev/null
>> At subvol b ERROR: parent determination failed for 9622
>
> AFAIK, that's entirely expected, because there /is/ no parent now to
> incrementally send against -- you deleted the parents and can no longer
> incrementally send against them.

I'm not incrementally sending against the parent, as I understand -c.
Failure here was surprising.

Also, I'd like to flag that there are two notions of "parent" -- a
parent ID and a parent_uuid, and it would be great if that error
message specified which more clearly since both are involved in the
reproduction case.

The exact same steps, keeping 'm' as a folder rather than a subvolume,
also fails, which clarifies what's happening. The message is related
to parent_uuid.

> Instead, at this point you have to do a full (non-incremental) send,
> since there's nothing to match against as the parent for an incremental
> send.
>
>
> However, what I believe you /wanted/ to do is something like this,
> assuming monthly snapshots to make it easy:
> [...]

Every time I start asking about snapshots people tell me how I could
set up my process differently which is annoying because:
1) They assume I'm doing a single, incremental backup process, which is wrong
2) I already have years/terabytes pf data I need to transfer, so I
can't change what I did in the past
3) They inevitably recommend their favorite method, which doesn't work
for me, because I have different requirements

I realize you're also trying to provide basic explanation of -p and -c
here but it's EVERY time I ask about snapshots...

Anyway, I'm doing a one-time transfer of a large number of snapshots
which are currently stuck on a .img file. Over the years they've been
re-organized repeatedly and I've snapshotted many from writable to
read-only (most of the cases of the parent being deleted, I think). My
goal is to get them into a new filesystem, but I can't do a full send
in every case, because then it would balloon up to a petabyte or so.

> Does that make more sense now, or were you actually already doing it that
> way and still getting the errors, and just didn't say so, or did I just
> confuse you even further (hopefully not!)?

I was already making sure all -c references were both present and
unmodified, I think the confusion is mostly around whether the parent
required to use -c, and whether it's an implicit reference volume in
particular. If it's required, it's impossible to preserve
de-duplication after deleting the original parent which would be
really bad.
