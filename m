Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36466 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753079AbdGFXoy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 19:44:54 -0400
Received: by mail-pf0-f179.google.com with SMTP id q86so8133797pfl.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 16:44:54 -0700 (PDT)
Date: Thu, 6 Jul 2017 16:44:51 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706234451.GB22242@vader.DHCP.thefacebook.com>
References: <20170706150046.GB12959@merlins.org>
 <20170706211320.GA12206@vader.DHCP.thefacebook.com>
 <20170706212422.GH30689@merlins.org>
 <20170706230141.GA22242@vader.DHCP.thefacebook.com>
 <20170706233152.GI30689@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170706233152.GI30689@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 04:31:52PM -0700, Marc MERLIN wrote:
> On Thu, Jul 06, 2017 at 04:01:41PM -0700, Omar Sandoval wrote:
> > What doesn't add up about your bug report is that your CURRENT points to
> > a MANIFEST-010814 way behind all of the other files in that directory,
> > which are numbered 022745+. If there were a bug here, I'd expect the
> > stale MANIFEST file would be one older than the new one. The filenames
> > seem to be allocated sequentially, so that old MANIFEST file CURRENT
> > refers to must be really old, which doesn't make sense. I don't see how
> > Btrfs would screw that up :) I'd be interested to see if you can make
> > the same condition trigger again.
> > 
> 
> First, thanks for looking at it.
> 
> Second, you are right on the numbers being so far apart that something was
> wrong. I checked my snapshots, and I've been carrying that MANIFEST-010814
> for a long time.
> In other words, it's a old stale manifest that never got deleted.
> 
> The new real old one apparently got deleted, the new one was created but
> didn't make it to disk, but the pointer in CURRENT did get repointed to the
> new one that never made it to actual disk.
> 
> So I think what happened is something like this:
> MANIFEST-new got created
> echo MANIFEST-new > CURRENT
> MANIFEST-old got deleted
> system crashed
> 
> MANIFEST-old was indeed deleted, and MANIFEST-new never made it to disk.
> 
> Does that sound more plausible?

In the bug report, you commented that CURRENT contained MANIFEST-010814,
is that indeed the case or was it actually something newer? If it was
the newer one, then it's still tricky how we'd end up that way but not
as outlandish.

> As for redoing this at will, apparently I may have been hit by the skylake
> hyperthreading CPU bug that I just installed a microcode update for, which
> was causing random crashes, which hopefully are now solved.
> I can't say if those in turn messed with btrfs writing data, but I'd rather
> not recreate this since it's my real filesystem I care about and don't want
> to corrupt on purpose :)

Understandable :)

> That said, the google-chrome on my previous haswell CPU also had routine
> problems when restarting chrome, although at this point I don't know if they
> were due to leveldb or sqlite or something else.
> I'm just mentioning this to say that I'm pretty sure that the haswell HT bug
> isn't the sole culprit of this problem, likely just the trigger of some of
> my crashes.
>
> Hope this helps
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  
