Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39414 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbcEDPbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 11:31:21 -0400
Date: Wed, 4 May 2016 17:31:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <noah.massey@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add safety delay before starting full
 balance
Message-ID: <20160504153103.GY29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462177984-23980-1-git-send-email-dsterba@suse.com>
 <CADfjVrjY246makTpiW398C5fM1D7uwrJAmMNt+aZCyEnY_u7jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrjY246makTpiW398C5fM1D7uwrJAmMNt+aZCyEnY_u7jA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 02, 2016 at 10:09:48AM -0400, Noah Massey wrote:
> > +       if (!(flags & BALANCE_START_FILTERS) && !(flags & BALANCE_START_NOWARN)) {
> > +               int delay = 10;
> > +
> > +               printf("WARNING:\n\n");
> > +               printf("\tFull balance without filters requested. This operation is very\n");
> > +               printf("\tintense and takes potentially very long. It is recommended to\n");
> > +               printf("\tuse the balance filters to narrow down the balanced data.\n");
> > +               printf("\tUse 'btrfs balance start --full-balance' option to skip this\n");
> > +               printf("\twarning. The operation will start in %d seconds.\n", delay);
> > +               printf("\tUse Ctrl-C to stop it.\n");
> > +               while (delay) {
> > +                       sleep(1);
> > +                       printf("%2d", delay--);
> > +                       fflush(stdout);
> > +               }
> 
> Shouldn't the sleep be after the fflush?

Yes it looks better when there's a delay after '1' appears. Care to send
a patch?
