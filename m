Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53314 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3C1Dim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 23:38:42 -0400
Received: by mail-vc0-f173.google.com with SMTP id gd11so7280836vcb.32
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 20:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5152B451.8090100@petaramesh.org>
References: <5152B451.8090100@petaramesh.org>
Date: Wed, 27 Mar 2013 23:38:41 -0400
Message-ID: <CALJXSJr9_s_c2Ah_Dpa_ha7WdZ=y8xftnk5BoXzAj+TfXv7fQg@mail.gmail.com>
Subject: Re: BTRFS and the steadily lit LED
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 27, 2013 at 4:56 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> After having received strong advice from the people in this list to
> upgrade my kernel to the latest one, I have installed 3.8.0-14-generic
> #24-Ubuntu SMP x86_64 on several (4) machines.
>
> In the hope of improving systems speed I had also removed all snapshots
> then defragged the FSes - the snapshots have been recreated since, as I
> use the excellent SuSE "Snapper" tool.
>
> But well, all 4 machines are still slow like hell. All of them are used
> for quite basic daily tasks - web browsing, email, typical LibreOffice
> tasks, nothing very mysterious there, no specific heavy DB work.
>
> All machines have 64-bits Linuxes (either Ubuntu 12.10 or 13.04ß), with
> decent amounts of RAM - 2 GB to 4 GB - and disks filled less than 75%
>
> With such a setup, I would expect any decent filesystem to deliver
> excellent performance. Still, all of my machines are slow like hell and
> I'm most of the time in mode « Working my patience while waiting for the
> HD LED to go off ».
>
> I haven't noticed any real-life noticeable improvement upgrading the
> kernels from 3.5.x to 3.8.x
>
> So I'm wondering...

I must say after having used BTRFS for quite some time on many
different desktop systems that this pretty much summaries my though of
BTRFS used on a desktop system.

I have been using it on my root filesystem for 5 consecutive systems
and all of them were I/O bound most of the time after 2 months of
normal usage with or *without* snapshots. Defragging or rebalancing
doesn't help, growing leaf size helps push back the problem, but it
eventually come back.

The only way to get around the problem is to re-format the drive and
restore from backups. I'm pretty sure I toasted 2 SSDs because of
BTRFS, one in 4 months, the other in 6 months. 80 GB SSDs, I switched
this system to NILFS2 for now, which isn't I/O bound and doesn't kill
flash drives.

A bigger system that I administer has 14 TB worth of data and has
constant loads of 6 to 8 (4 CPUs), mostly because of I/O wait just
because it unzips a file. This system never had a snapshot.

On the system I'm writing, watching a YouTube video will hang one
second every 30 seconds because flash player writes the video to /tmp.

I submitted some backtrace but lost hope, I used kernel from 3.0 to
3.9-rc4 with the FS, features are great, it is great for a file
server, but for desktop, it is really hard to use as root or /home
because of this issue.

Is there any data I can submit to help enhance performance on a desktop system?
