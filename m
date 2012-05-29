Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f180.google.com ([209.85.160.180]:63701 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2E2Xmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 19:42:44 -0400
Received: by ghbz12 with SMTP id z12so2714044ghb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:42:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC55AB7.3000903@gmail.com>
References: <4FC54A5D.8000600@gmail.com>
	<4FC55043.4050004@gmail.com>
	<CAE5mzvg_gLxkYhE1h7aunvvYHgsKjpo2xfLqv4A++S=UAOiySw@mail.gmail.com>
	<4FC55AB7.3000903@gmail.com>
Date: Tue, 29 May 2012 17:36:55 -0600
Message-ID: <CAE5mzvjYA-ojJWK8yqTbY6DZCoqcP9B_U2RwYGiahkp3C9t67g@mail.gmail.com>
Subject: Re: Help with data recovering
From: cwillu <cwillu@cwillu.com>
To: Maxim Mikheev <mikhmv@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2012 at 5:24 PM, Maxim Mikheev <mikhmv@gmail.com> wrote:
> Thank you for your answer.
>
>
> The system kernel was and now:
>
> Linux s0 3.4.0-030400-generic #201205210521 SMP Mon May 21 09:22:02 UTC 2012
> x86_64 x86_64 x86_64 GNU/Linux
>
> the raid was created by:
> mkfs.btrfs /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
>
> Disk are connected through RocketRaid 2670.
>
> for mounting I used line in fstab:
> UUID=c9776e19-37eb-4f9c-bd6b-04e8dde97682    /tank        btrfs
>  defaults,compress=lzo    0    1
>
> On machine was running several Virtual machines. Only one was actively using
> disks.
>
> VM has active several threads:
> 1. 2 threads reading big files (50GB each)
> 2. reading from 50 files and writing one big file
> 3. The kernel panic happens when I run another program with 30 threads of
> reading/writing of small files.
>
> Virtual Machine accessed to underline btrfs through 9-p file system which
> actively used xattr.
>
> After reboot system was in this stage.
>
> I hope that btrfsck --repair will not make it worse, It is now running.

**twitch**

Well, I also hope it won't make it worse.  Do not cancel it now, let
it finish (aborting it will  make things worse), but I suggest waiting
until a few more people have weighed in before attempting anything
beyond that.
