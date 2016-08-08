Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34314 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbcHHRNz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 13:13:55 -0400
Received: by mail-oi0-f46.google.com with SMTP id l203so120848873oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 10:13:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 8 Aug 2016 11:13:53 -0600
Message-ID: <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
Subject: Re: Strange behavior after "rm -rf //"
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2016 at 10:30 AM, Ivan Sizov <sivan606@gmail.com> wrote:
> I'd ran "rm -rf //" by mistake two days ago. I'd stopped it after five
> seconds, but some files had been deleted. I'd tried to shutdown the
> system, but couldn't (a lot of files in /bin had been deleted and
> systemd didn't work). After hard reboot (by reset button) and booting
> to a live USB a strange thing was discovered.
>
> Deleted files are present when I "mount -r" the disk, but
> btrfs-restore tells they are deleted ("We have looped trying to
> restore files too many times to be making progress").
>
> What does it mean? Will those files be deleted after RW mount?

Just a wild guess, the deletions may be in the tree log and haven't
been applied to the other trees (fs tree, extent tree, etc). So yes
I'd expect they get deleted on a rw mount.

This is what kernel? Because kernel 4.6 offers mount option
"nologreplay" which suggests even if you do mount -r that log replay
happens, so you shouldn't see these deleted files unless you mount ro
*and* use nologreplay mount option.

Anyway, even 5 seconds of rm -rf damages too much. If you don't have
recent snapshots then it's not sanely salvageable, just reinstall.


-- 
Chris Murphy
