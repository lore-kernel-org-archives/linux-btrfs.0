Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35428 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754418AbcHSN27 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 09:28:59 -0400
Date: Fri, 19 Aug 2016 15:27:51 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Mel Gorman <mgorman@suse.de>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM killer invoked during btrfs send/recieve on otherwise idle
 machine
Message-ID: <20160819132751.GI32619@dhcp22.suse.cz>
References: <20160731051121.GB307@x4>
 <20160731151047.GA4496@dhcp22.suse.cz>
 <20160731152522.GA311@x4>
 <20160802132855.GA24890@dhcp22.suse.cz>
 <CAJCQCtRDVr9MKC+GRWo1Ti4-7NLtY3Dj0gb0F=JJO1brX8bT6A@mail.gmail.com>
 <CAJCQCtQ57OgNgRzjcGr4OBh3y9NO1J0juZbz5p3cgt5OinRx6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQ57OgNgRzjcGr4OBh3y9NO1J0juZbz5p3cgt5OinRx6A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 02-08-16 09:48:01, Chris Murphy wrote:
> On Tue, Aug 2, 2016 at 9:38 AM, Chris Murphy <lists@colorremedies.com> wrote:
> > Yesterday I saw oom killer knocking off processes during a simple cp
> > -a from one Btrfs to another, in a VM, with kernel
> > 4.8.0-0.rc0.git3.1.fc25.x86_64. The call trace looks different than
> > Markus' so I'm not sure it's the same problem. It's not always
> > reproducible. It hasn't happened on 4.7.0 though. According ot koji
> > this is Linux v4.7-6438-gc624c86
> >
> > This is 'journalctl -o short-monotonic -b-4 -k'
> >
> > https://drive.google.com/open?id=0B_2Asp8DGjJ9ZC1JSDJnaWpnSEE
> 
> Btrfs volume 2 is created at [  625.769736]  and mounted at [
> 640.119150], with the copy starting shortly after that. OOM happens at
> [  856.212658] . There are a bunch of earlier bug messages, BUG:
> sleeping function called from invalid context at mm/slab.h:393.

It seems that the current linux-next +
http://lkml.kernel.org/r/f7a9ea9d-bb88-bfd6-e340-3a933559305a@suse.cz
seems like helped other users. Could you try this as well please?
-- 
Michal Hocko
SUSE Labs
