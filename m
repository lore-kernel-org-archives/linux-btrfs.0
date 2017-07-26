Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47877 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdGZRIY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 13:08:24 -0400
Date: Wed, 26 Jul 2017 10:07:17 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: write corruption due to bio cloning on raid5/6
Message-ID: <20170726160717.GA32451@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 10:22:53PM +0200, Janos Toth F. wrote:
> I accidentally ran into this problem (it's pretty silly because I
> almost never run RC kernels or do dio writes but somehow I just
> happened to do both at once, exactly before I read your patch notes).
> I didn't initially catch any issues (I see no related messages in the
> kernel log) but after seeing your patch, I started a scrub (*) and it
> hung.
> 
> Is there a way to fix a filesystem corrupted by this bug or does it
> need to be destroyed and recreated? (It's m=s=raid10, d=raid5 with
> 5x4Tb HDDs.) There is a partial backup (of everything really
> important, the rest is not important enough to be kept in multiple
> copies, hence the desire for raid5...) and everything seems to be
> readable anyway (so could be saved if needed) but nuking a big fs is
> never fun...

It should only affect the dio-written files, the mentioned bug makes
btrfs write garbage into those files, so checksum fails when reading
files, nothing else from this bug.

As you use m=s=raid10, filesystem metadata is OK, so I think hang of
scrub could be another problem.


> 
> Scrub just hangs and pretty much makes the whole system hanging (it
> needs a power cycling for a reboot). Although everything runs smooth
> besides this. Btrfs check (read-only normal-mem mode) finds no errors,
> the kernel log is clean, etc.
> 
> I think I deleted all the affected dio-written test-files even before
> I started scrubbing, so that doesn't seem to do the trick. Any other
> ideas?
>

A hang could normally be caught by sysrq-w, could you please try it
and see if there is a difference in kernel log?

Thanks,

-liubo
> 
> * By the way, I see raid56 scrub is still painfully slow (~30Mb/s /
> disk with raw disk speeds of >100 Mb/s). I forgot about this issue
> since I last used raid5 a few years ago.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
