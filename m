Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63335 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3L3RTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:15 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so3762178bkb.6
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Dec 2013 09:19:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131201230130.GS8803@dastard>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
 <20131127005126.GC10988@dastard> <CBAC6E46-0E69-477C-A177-E720C3184073@colorremedies.com>
 <20131201230130.GS8803@dastard>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 30 Dec 2013 18:18:53 +0100
Message-ID: <CAG-2HqXvwHnEGp=O_pBj+Wv4Z3nBNqQCpidr7=--FPNjZAZ74g@mail.gmail.com>
Subject: Re: missing /sbin/fsck.btrfs
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 2, 2013 at 12:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> I just explained that things can go wrong if
> you don't detect certain types of errors in fsck.<foo> when it is
> called from fstab processing.
>
> What I am implying here is that we cannot prevent users from setting
> passno to 1 or 2 in /etc/fstab. We have no control over that and so
> asserting that "we don't need a fsck.btrfs because we can set passno
> to 0" is invalid. IOWs, fsck.btrfs needs to be present and it needs
> to behave correctly in these cases....

I actually think what btrfs is doing here is the more sensible thing
(i.e., to not ship an fsck.btrfs), as it is a bit confusing to have a
fsck.* that does not in fact do any filesystem checking.

The way this stuff works under systemd is:

 * fsck is only ever called on a filesystem once the backing device
has appeared (so under systemd, fsck.xfs is indeed a noop).
 * fsck is skipped for filesystems where the relevant helper does not
exist, so fs_passno=1 has the same effect for xfs and btrfs
filesystems (either way, nothing happens).

That still leaves non-systemd systems and calling "fsck -A" manually.
Maybe a good solution would be to patch fsck to adopt systemd's
behavior, which would avoid every filesystem having to ship these
"fake" fsck helpers? What do you think Karel?

Cheers,

Tom
