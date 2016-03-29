Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38203 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbcC2CKI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 22:10:08 -0400
Received: by mail-ig0-f180.google.com with SMTP id m10so3212734igt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 19:10:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F9252F.90704@gmail.com>
References: <56F7B77F.9050306@gmail.com>
	<pan$8fc2c$862a26c8$c5af9279$b4bfa8ec@cox.net>
	<56F9252F.90704@gmail.com>
Date: Mon, 28 Mar 2016 20:10:07 -0600
Message-ID: <CAJCQCtR7PD9egfp=x_fY77FzW0a5zYgJ1u0CAu1pEpDV=gtDuw@mail.gmail.com>
Subject: Re: Raid 0 setup doubt.
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 28, 2016 at 6:35 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> The other caveat that nobody seems to mention outside of specific cases is
> that using suspend to disks exposes you to direct attack by anyone with the
> ability to either physically access the system, or boot an alternative OS on
> it.  This is however not a Linux specific issue (although Windows and OS X
> do a much better job of validating the hibernation image than Linux does
> before resuming from it, so it's not as easy to trick them into loading
> arbitrary data).

OS X uses dynamically created swapfiles, and the hibernation file is a
separate file that's pre-allocated. Both are on the root file system,
so if you encrypt, then those files are also encrypted. Hibernate
involves a hint in NVRAM that hibernate resume is necessary, and the
firmware uses a hibernate recovery mechanism in the bootloader which
also has a way to unlock encrypted volumes (which are kinda like an
encrypted logical volume, as Apple now defaults to using a logical
volume manager of their own creation).



-- 
Chris Murphy
