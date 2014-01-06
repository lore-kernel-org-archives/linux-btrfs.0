Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaAFOza (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 09:55:30 -0500
Date: Mon, 6 Jan 2014 15:55:17 +0100
From: Karel Zak <kzak@redhat.com>
To: Tom Gundersen <teg@jklm.no>
Cc: Dave Chinner <david@fromorbit.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: missing /sbin/fsck.btrfs
Message-ID: <20140106145517.GG31045@x2.net.home>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
 <20131127005126.GC10988@dastard>
 <CBAC6E46-0E69-477C-A177-E720C3184073@colorremedies.com>
 <20131201230130.GS8803@dastard>
 <CAG-2HqXvwHnEGp=O_pBj+Wv4Z3nBNqQCpidr7=--FPNjZAZ74g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG-2HqXvwHnEGp=O_pBj+Wv4Z3nBNqQCpidr7=--FPNjZAZ74g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 06:18:53PM +0100, Tom Gundersen wrote:
>  * fsck is skipped for filesystems where the relevant helper does not
> exist, so fs_passno=1 has the same effect for xfs and btrfs
> filesystems (either way, nothing happens).
> 
> That still leaves non-systemd systems and calling "fsck -A" manually.
> Maybe a good solution would be to patch fsck to adopt systemd's
> behavior, which would avoid every filesystem having to ship these
> "fake" fsck helpers? What do you think Karel?

 It's already implemented for years, "fsck -A" ignores filesystems 
 without fsck.<type> helpers. It only complains if you explicitly
 specify the device on command line (e.g. fsck /dev/sdb1).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
