Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38325 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752746AbdDJLuO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 07:50:14 -0400
Date: Mon, 10 Apr 2017 13:50:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 7 (btrfs)
Message-ID: <20170410115011.GY4781@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170407182732.455c5c90@canb.auug.org.au>
 <3f143e53-652b-8690-d71c-dae42ab14a09@infradead.org>
 <b8b42950-e775-398d-1364-8bb7c117aa12@infradead.org>
 <20170407160502.GV4781@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170407160502.GV4781@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 07, 2017 at 06:05:02PM +0200, David Sterba wrote:
> On Fri, Apr 07, 2017 at 08:10:48AM -0700, Randy Dunlap wrote:
> > On 04/07/17 08:08, Randy Dunlap wrote:
> > > On 04/07/17 01:27, Stephen Rothwell wrote:
> > >> Hi all,
> > >>
> > >> Changes since 20170406:
> > >>
> > > 
> > > on i386:
> > > 
> > > ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> > > 
> > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > 
> > 
> > or when built-in:
> > 
> > fs/built-in.o: In function `scrub_bio_end_io_worker':
> > scrub.c:(.text+0x3d1908): undefined reference to `__udivdi3'
> > fs/built-in.o: In function `scrub_raid56_parity':
> > scrub.c:(.text+0x3d23cc): undefined reference to `__udivdi3'
> > scrub.c:(.text+0x3d3342): undefined reference to `__udivdi3'
> > scrub.c:(.text+0x3d3755): undefined reference to `__udivdi3'
> 
> Sorry, I can't reproduce it here, I've also tried my other for-next
> snapshot branches, same. We have some recent patches that could trigger
> the __udivdi3 build check,
> 
> "Btrfs: update scrub_parity to use u64 stripe_len" (7d0ef8b4dbbd22)
> 
> manual check or with help of coccinell didn't show me any instances of
> 64bit division with / .

Fixed and updated for-next pushed to my k.org repository.
