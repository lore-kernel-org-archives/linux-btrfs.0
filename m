Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35424 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbbCGJjh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Mar 2015 04:39:37 -0500
Received: by lams18 with SMTP id s18so1639549lam.2
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Mar 2015 01:39:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CADurGxyF6g5Z+HNMry+q=b_oCKv1a6StDvp6pL20z=twK0BMHQ@mail.gmail.com>
References: <CADurGxyF6g5Z+HNMry+q=b_oCKv1a6StDvp6pL20z=twK0BMHQ@mail.gmail.com>
Date: Sat, 7 Mar 2015 09:39:35 +0000
Message-ID: <CAL3q7H41AVqn9xK+Dwo+AjSYpjsEH9wWG+nbCxio6+oL_0TBfA@mail.gmail.com>
Subject: Re: Status: converting raid levels
From: Filipe David Manana <fdmanana@gmail.com>
To: Marcel Ritter <ritter.marcel@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 6, 2015 at 10:22 AM, Marcel Ritter <ritter.marcel@gmail.com> wrote:
> Hi,
>
> please, can someone comment on the current status of raid level migration?
> (kernel 4.0.0-rc2, btrfs-progs 3.19-rc2)
>
> I just started testing this feature, and it doesn't seem to work:
>
> Starting with Raid1:
>
> root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
> Data, RAID1: total=3.00GiB, used=512.00KiB
> Data, single: total=8.00MiB, used=0.00B
> System, RAID1: total=8.00MiB, used=16.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=1.00GiB, used=112.00KiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=16.00MiB, used=0.00B
>
> Converting to Raid10:
>
> root@thunder[ ~/btrfs-progs ]# ./btrfs balance start -dconvert=raid10
> -mconvert=raid10 /tmp/m/
> Done, had to relocate 9 out of 9 chunks
>
> Still Raid1 ...:
>
> root@thunder[ ~/btrfs-progs ]# ./btrfs fi df /tmp/m
> Data, RAID1: total=35.00GiB, used=31.49GiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=1.00GiB, used=33.86MiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
>
> I also tried conversion of raid6 - but it did not work either
> (according to btrfs fi df output).
>
> Did I miss something, or is it a bug?

Seems like the regression Holger found due to a patch added to 4.0:

http://www.spinics.net/lists/linux-btrfs/msg42084.html

(he mentions a 3.18.x kernel, but that's because he builds his own
kernels with patches backported)

>
> Bye,
>     Marcel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
