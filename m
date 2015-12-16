Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33861 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbbLPGtr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 01:49:47 -0500
Received: by mail-ig0-f176.google.com with SMTP id sf7so10581471igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 22:49:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSqxANo4LHFkXdQ-Ltvkci_5EU5k39oQbhKHZGWXBPBPw@mail.gmail.com>
References: <CAJCQCtSqxANo4LHFkXdQ-Ltvkci_5EU5k39oQbhKHZGWXBPBPw@mail.gmail.com>
Date: Tue, 15 Dec 2015 23:49:46 -0700
Message-ID: <CAJCQCtR2XOwhAkMUYwsVeoLvR+H2sH-FrKmok2MDWk1ot=h1Dw@mail.gmail.com>
Subject: Re: ERROR: did not find source subvol
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 5:35 PM, Chris Murphy <lists@colorremedies.com> wrote:
> kernel 4.2.6-301.fc23.x86_64
> btrfs-progs-4.2.2-1.fc23.x86_64
>
> This is a new one for me. Two new Btrfs volumes (one single profile,
> one 2x raid1) both created with this btrfs-progs. And then
>
> [root@f23a chrisbackup]# btrfs send everything-20150922/ | btrfs
> receive /mnt/br1-500g/
> At subvol everything-20150922/
> At subvol everything-20150922
> ERROR: did not find source subvol.
>
> There are no kernel messages.
>
> [root@f23a chrisbackup]# du -sh everything-20150922/
> 324G    everything-20150922/
> [root@f23a chrisbackup]# du -sh /mnt /b
>
> [root@f23a chrisbackup]# du -sh /mnt/br1-500g/everything-20150922/
> 322G    /mnt/br1-500g/everything-20150922/
>
> HUH, looks like 2G is missing on the receive side. So it got
> interrupted for some reason?

Files are definitely missing. -v reveals no new information. So I'm confused.

Next, I switched to kernel 4.4rc5 and btrfs-progs 4.3.1 and I'm not
seeing this problem. Same file systems, same subvolume.


-- 
Chris Murphy
