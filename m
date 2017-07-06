Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44365 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbdGFX7k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 19:59:40 -0400
Date: Thu, 6 Jul 2017 16:59:39 -0700
From: Marc MERLIN <marc@merlins.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, pwnall@chromium.org
Subject: Re: Leveldb in google-chrome incompatible with btrfs?
Message-ID: <20170706235939.GJ30689@merlins.org>
References: <20170706150046.GB12959@merlins.org> <20170706211320.GA12206@vader.DHCP.thefacebook.com> <20170706212422.GH30689@merlins.org> <20170706230141.GA22242@vader.DHCP.thefacebook.com> <20170706233152.GI30689@merlins.org> <20170706234451.GB22242@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170706234451.GB22242@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 04:44:51PM -0700, Omar Sandoval wrote:
> In the bug report, you commented that CURRENT contained MANIFEST-010814,
> is that indeed the case or was it actually something newer? If it was
> the newer one, then it's still tricky how we'd end up that way but not
> as outlandish.

You are correct, my bad.
At this point, I'm going to have to assume that something bad happened with
rsync when I rsync'ed an old profile over the one that caused chrome to fail
to restart.
Especially because CURRENT was dated Oct 4th, which does not make sense.

Now that I know what to look for, I'll have a much closer look next time
this happens, with the understanding that it would be a while if I've
successfully fixed the reason why my laptop was crashing too often.

But you said you've also seen issues with google-chrome profile and btrfs.
What did you experience?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
