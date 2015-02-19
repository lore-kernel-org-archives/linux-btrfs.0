Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:46265 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbBSRv6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 12:51:58 -0500
Received: by yhzz6 with SMTP id z6so852627yhz.13
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 09:51:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54E5F38D.4070104@gmail.com>
References: <54E5F38D.4070104@gmail.com>
Date: Thu, 19 Feb 2015 10:51:57 -0700
Message-ID: <CAJCQCtTch3NfG8=97QXj-FFj2p4zbyUzsf=EY==Xc=YRHjwA+g@mail.gmail.com>
Subject: Re: Systemd 219 journald now sets the FS_NOCOW file flag for its
 journal files, possibly breaking RAID repairs.
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 19, 2015 at 7:30 AM, Konstantinos Skarlatos
<k.skarlatos@gmail.com> wrote:
> Systemd 219 now sets the special FS_NOCOW file flag for its journal
> files[1]. This unfortunately breaks the ability to repair the journal on
> RAID 1/5/6 btrfs volumes, should a bad sector happen to appear there. Is
> this something that can be configured for systemd? Is btrfs going to someday
> fix the fragmentation problem, making this option reduntant?

Chris is looking at a per file autodefrag setting, last I read. I
think that's a better way forward. I'm finding that +C on journals is
an OK short term workaround; the problem is that if the containing
subvolume is subject to snapshots, in effect the +C benefit is
thwarted. I have a ~2 week old journal subject to merely 6 snapshots
in that time, and it has over 9000 extents despite +C.

I think autodefragging journals on HDD is OK, but I'm uncertain if
this is really necessary on SSD.

I'm not sure how to make this better without adding complexity. I just
had an idea of a journal specific partition which kinda decouples the
dependency on filesystems being mounted so the journal can
persistently write to stable media earlier in boot and later in
shutdown, and some other things are easier for journald also. But it
might make some people scream.


-- 
Chris Murphy
