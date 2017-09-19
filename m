Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35396 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750921AbdISPP7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:15:59 -0400
Date: Tue, 19 Sep 2017 17:14:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: allow "none" to disable compression for
 convenience
Message-ID: <20170919151427.GH29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <87poaqyxdi.wl-satoru.takeuchi@gmail.com>
 <CAMU1PDiJofgOQZ3g5Fq35huWuPp7fKFdC+KR2KjCkqGrP9aUzw@mail.gmail.com>
 <8760cgalea.wl-satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8760cgalea.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 09:41:17AM +0900, Satoru Takeuchi wrote:
> At Sun, 17 Sep 2017 14:08:40 +0100,
> Mike Fleetwood wrote:
> > 
> > On 17 September 2017 at 01:36, Satoru Takeuchi
> > <satoru.takeuchi@gmail.com> wrote:
> > > It's messy to use "" to disable compression. Introduce the new value "no"
> > > which can also be used for this purpose.
> > 
> > From an English language point of view, "none" would be better.  None
> > says the absence of, where as no is more general negative.
> 
> Thank you for your comment. How about is it?
> 
> ---
> It's messy to use "" to disable compression. Introduce the new value "none"
> which can also be used for this purpose.

I'd allow both values, 'no' and 'none', similar to the mount options,
that also accept both (technically, the 'no' + anything is accepted for
disabling compression).
