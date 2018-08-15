Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33470 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728576AbeHOO0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Aug 2018 10:26:41 -0400
Date: Wed, 15 Aug 2018 13:34:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@kernel.org>
Cc: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: sync log after logging new name
Message-ID: <20180815113443.GH24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180611182428.18102-1-fdmanana@kernel.org>
 <20180615155428.GG24375@twin.jikos.cz>
 <CAL3q7H641LmbUYgg_0n+1rS6KRScgZh9UjMSauCVCMNLJPnVdw@mail.gmail.com>
 <20180618110616.GI24375@twin.jikos.cz>
 <20180814190405.GA10954@vader>
 <20180814225337.GG24025@twin.jikos.cz>
 <CAL3q7H5kUs_SzL0iGoBpihWe5-x4cwzCk0MwtNknJ9vr4dn_og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5kUs_SzL0iGoBpihWe5-x4cwzCk0MwtNknJ9vr4dn_og@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 09:46:13AM +0100, Filipe Manana wrote:
> >> > I had in mind was some leftover from locking, error handling or state
> >> > that blocked umount of 011.
> >>
> >> Dave, are you sending this in for 4.19? I don't see it in your first
> >> pull request.
> 
> In another thread, related to the first patch in the series iirc, I
> specifically asked to not merge it.

Ah right, I remember now. Yesterday I only checked mails in the thread
of the patch and the mail was marked as 'applied to some branch'.

> That's because I run twice (in the long period of nearly 2 months now)
> into a hang which could be caused
> by this patch. The traces were weird and only contained inexact lines
> that showed only the transaction kthread
> waiting forever on transaction commit.
> 
> I recently found that I have hardware problems that were causing
> issues with qemu (stalls, ocassional crashes)
> so I'm hoping that's the cause but I still need to test it with long
> stress tests on good hardware.
> 
> I don't mind getting it to linux-next in the meanwhile, but for 4.19 I
> would prefer to not include yet.

Ok, understood.
