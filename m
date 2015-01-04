Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:59722 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbADUqb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 15:46:31 -0500
Received: by mail-yh0-f49.google.com with SMTP id f10so10029549yha.22
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 12:46:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150104151843.GX17254@merlins.org>
References: <fab96edbc48bf3f26781ab76dda6f182@pl1.haspere.com>
	<CAJCQCtRYW_S8CDZQH_95RGtsTBHN3gftd9WgsScA7_oCpFYgOg@mail.gmail.com>
	<20150104151843.GX17254@merlins.org>
Date: Sun, 4 Jan 2015 13:46:30 -0700
Message-ID: <CAJCQCtS14LePOXYdqLysGyYTJhVW1oofqym-32fYKFKdM6Yytg@mail.gmail.com>
Subject: Re: ignoring bad blocks
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 4, 2015 at 8:18 AM, Marc MERLIN <marc@merlins.org> wrote:

> badblocks are a thing of the past, as you hinted drives automatically
> remap badblocks so that the filesystem doesn't have to deal with them.
>
> If you have a questionable drive, you can indeed simply dd 0's over it
> before you use it with btrfs.

I suggest badblocks because the default works on both 512 or 4096 byte
physical sector drives.

On AF 512e drives, dd default block size of 512 bytes will fail if a
bad sector is encountered. What happens (to at least one model of
drive since I've had this happen to me) is the 512 byte write to a bad
4096 byte sector gets interpreted by the drive as a Read Write Modify.
So do use dd you need to also use bs= setting it to a multiple of
4096. Of course most people using dd for zeroing set bs= to a decently
high value because it makes the process go much faster than the
default block size of 512 bytes.

I just used strace on badblocks and by default issues 64KiB writes
(the block size is 1024 bytes with a count of 64, which looks like it
gets aggregated).

-- 
Chris Murphy
