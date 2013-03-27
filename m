Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39782 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3C0Sd3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 14:33:29 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DE6EC7C0682
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 12:33:28 -0600 (MDT)
Date: Wed, 27 Mar 2013 14:33:25 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Message-ID: <20130327183325.GK28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 08:33:27AM -0600, Szőts Ákos wrote:
> Dear list members,
> 
> In my previous thread at
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23333.html
> there was a space_cache kernel bug/panic on kernel 3.8. I could
> successfully "fix" that with rebuilding the cache. But some files were
> missing/corrupted. So I booted a rescue CD with kernel 3.7 and ran
> btrfsck --repair, which repaired quite a few things.
> 
> After a reboot I got the following message:
> [  469.457386] btrfs: disk space caching is enabled
> [  469.503612] btrfs: mismatching generation and generation_v2 found
> in root item. This root was probably mounted with an older kernel.
> Resetting all new fields.
> 
> As soon as anything had wanted to read a bit from the file system, the
> hard drive went crazy and was working for 5-10 minutes. After I got a
> kernel panic which said there's an error in fs/btrfs/inode.c:835.
> 
> In the moment I don't just mount, but want to read something from the
> mounted file system under the rescue system, the same procedure
> happens.
> 
> I made some pictures of it (since I cannot read anything from the
> logs, if there are any).
> You can find them here: www.morrohun.hu/temp/btrfs/v2/[123].jpg
> 
> I wanted to create an image with the aforementined btrfs-image tool,
> but yet to have any success .
> 
> Could you please give me an advice what can I do now? Living on a
> live-CD is not a life insurance :)
> 

Can you run btrfsck without --repair and capture the output and upload it
somewhere so I can make sure I've restored properly.  I can reproduce the
problem but I'm worried that I'm reproducing it because I've restored badly and
there's something else wrong, I want to make sure I'm seeing exactly what you
are seeing.  Thanks,

Josef
