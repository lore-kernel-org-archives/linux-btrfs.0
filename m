Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:51651 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbcISP1p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 11:27:45 -0400
Received: from coach.home (pool-100-4-160-104.albyny.fios.verizon.net [100.4.160.104])
        by cartman.routify.me (Postfix) with ESMTPSA id 0AC52825EA
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Sep 2016 11:27:44 -0400 (EDT)
Date: Mon, 19 Sep 2016 11:27:42 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160919152742.GB1431@coach.home>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
 <20160919040855.GF21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160919040855.GF21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 19, 2016 at 12:08:55AM -0400, Zygo Blaxell wrote:
> <snip>
> At the end of the day I'm not sure fsck really matters.  If the filesystem
> is getting corrupted enough that both copies of metadata are broken,
> there's something fundamentally wrong with that setup (hardware bugs,
> software bugs, bad RAM, etc) and it's just going to keep slowly eating
> more data until the underlying problem is fixed, and there's no guarantee
> that a repair is going to restore data correctly.  If we exclude broken
> hardware, the only thing btrfs check is going to repair is btrfs kernel
> bugs...and in that case, why would we expect btrfs check to have fewer
> bugs than the filesystem itself?

I see btrfs check as having a very useful role: fixing known problems
introduced by previous versions of kernel / progs. In my ext conversion
thread, I seem to have discovered a problem introduced by convert,
balance, or defrag. The data and metadata seem to be OK, however the
filesystem cannot be written to without btrfs falling over. If this was
caused by some edge-case data in the btrfs partition, it makes a lot
more sense to have btrfs check repair it than it does to modify the
kernel code to work around this and possibly many other bugs. The upshot
to this is that since (potentially all of) the data is intact, a
functional btrfs check would save me the hassle of restoring from
backup.

--Sean

