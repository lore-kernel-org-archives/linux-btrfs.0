Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33723 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbcEERs4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2016 13:48:56 -0400
Received: by mail-pf0-f177.google.com with SMTP id 206so40263900pfu.0
        for <linux-btrfs@vger.kernel.org>; Thu, 05 May 2016 10:48:56 -0700 (PDT)
Date: Thu, 5 May 2016 10:48:54 -0700
From: Omar Sandoval <osandov@osandov.com>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
Message-ID: <20160505174854.GA1012@vader.dhcp.thefacebook.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 05, 2016 at 12:36:52PM +0200, Niccolò Belli wrote:
> On giovedì 5 maggio 2016 03:07:37 CEST, Chris Murphy wrote:
> > I suggest using defaults for starters. The only thing in that list
> > that needs be there is either subvolid or subvold, not both. Add in
> > the non-default options once you've proven the defaults are working,
> > and add them one at a time.
> 
> Yes I read your previous suggestion and I already dropped subvolid, but
> since the problem already happened I left it in the mail for completeness.
> Anyway the culprit here is genfstab and that's probably what a beginner is
> going to use when installing a distro:
> https://wiki.archlinux.org/index.php/beginners'_guide#fstab
> 

The redundant subvolid doesn't hurt, the kernel will just check that it
matches the passed subvol (see [1]). genfstab probably just pulls the
options out of /proc/mounts or /proc/self/mountinfo, and since we show
both, that's how it gets in fstab. If it was actually a problem, there
would be a clear message in dmesg.

1: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=bb289b7be62db84b9630ce00367444c810cada2c

-- 
Omar
