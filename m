Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35191 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbbEKODJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 10:03:09 -0400
Received: by igbyr2 with SMTP id yr2so70556757igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 07:03:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJCQCtSXceHtfNYpOekP+8TfiF7WJeHQNwYyNJRYnD0XT2z-XA@mail.gmail.com>
References: <CAJCQCtSK6cejsr=5J=XvWHnU6iUTrQ_gMGV3ExBwoxvO0ZaXcQ@mail.gmail.com>
	<CAJCQCtSXceHtfNYpOekP+8TfiF7WJeHQNwYyNJRYnD0XT2z-XA@mail.gmail.com>
Date: Mon, 11 May 2015 15:03:08 +0100
Message-ID: <CAL3q7H5bdnOLmHTt_YrUnJb7grmv+UFMSW62e85yK7F9UN24Zg@mail.gmail.com>
Subject: Re: oops BUG unable to handle kernel NULL point dereference IP io_ctl_check_crc
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 9, 2015 at 8:43 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, May 9, 2015 at 12:34 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=97991
>
> OK it appears to be a 32bit kernel problem, as it happens in an x86_64
> qemu/kvm VM.
>
> But that same vm with the same version 64bit kernel doesn't exhibit the problem.

Sounds like it should have been fixed in rc3 by [1], the same trace
was reported recently [2].

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1d3c61c2eb3fe4f96d3192212f1bdcee49ea55aa
[2] http://www.spinics.net/lists/linux-btrfs/msg43754.html

>
> --
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
