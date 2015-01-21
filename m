Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:37911 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbAUMpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 07:45:24 -0500
Received: by mail-la0-f43.google.com with SMTP id q1so24667901lam.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2015 04:45:22 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <54BF90C5.8060100@spth.de>
References: <54BF90C5.8060100@spth.de>
Date: Wed, 21 Jan 2015 12:45:22 +0000
Message-ID: <CAL3q7H4ZFdYbZ91Q9PuwA8R9jkoANEsipEcB6054q=DLPtWPEA@mail.gmail.com>
Subject: Re: BTRFS critical (device dm-2): invalid dir item name len: 77
From: Filipe David Manana <fdmanana@gmail.com>
To: Philipp Klaus Krause <pkk@spth.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2015 at 11:43 AM, Philipp Klaus Krause <pkk@spth.de> wrote:
> Hello,
>
> I've been using btrfs on a Debian GNU/Linux system. After about 9
> months, I encountered my first filesystem issue. It first appeared while
> doing an rm -rf, which resulted in a
>
> rm: cannot remove […]: Directory not empty
>
> a du -s on the directory gives an
>
> BTRFS critical (device dm-2): invalid dir item name len: 77
>
> I can mv directory around (which is good so it doesn't get in my way any
> more), but can't rm it.
>
> How can I get id of it?

In principle btrfsck (with the --repair option) should be able to fix it.
Before running it with --repair, it's recommended to backup your data
and run it first in readonly mode (no command line options passed to
btrfsck) to confirm it detects the issue. Also try the latest version
of btrfs-progs (currently v3.18.x), which has better chances of fixing
it.

We had a few issues [1, 2] that lead to that issue, one fix is in
kernel 3.18 and the other one is very recent, not yet in any kernel
release:

Hope it helps.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a2cc11db245b9d8fbd4e3adbe2a1e7cf60473950
[2] https://patchwork.kernel.org/patch/5604671/


>
> Philipp
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
