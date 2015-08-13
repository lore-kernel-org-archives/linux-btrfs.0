Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33514 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbbHMXOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 19:14:37 -0400
Received: by vkbg64 with SMTP id g64so10856627vkb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:14:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150813112331.297d15f6@thetick>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<5581ABA2.30906@gmail.com>
	<21893.29830.540787.159202@localhost.localdomain>
	<B7F2379062E32745A8651FBDB20F64595D45D284@Server.waterlogic.com.au>
	<20150813112331.297d15f6@thetick>
Date: Thu, 13 Aug 2015 17:14:36 -0600
Message-ID: <CAJCQCtR_9L4oBOcLAfL1gC4UVt1APOU6iSkJ3TBrEcUb0hT3qg@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 13, 2015 at 3:23 AM, Marc Joliet <marcec@gmx.de> wrote:

> Speaking as a user, since "fstrim -av" still always outputs 0 bytes trimmed
> on my system: what's the status of this?  Did anybody ever file a bug report?

Since I'm not having this problem with my SSD, I'm not in a position
to provide any meaningful information for such a report.

The bug should whether this problem is reproducible with ext4 and XFS
on the same device, and the complete details of the stacking (if this
is not the full device or partition of it; e.g. if LVM, md, or
encryption is between fs and physical device). And also the bug should
include full dmesg as attachment, and strace of the fstrim command
that results in 0 bytes trimmed. And probably separate bugs for each
make/model of SSD, with the bug including make/model and firmware
version.

Right now I think there's no status because a.) no bug report and b.)
not enough information.

-- 
Chris Murphy
