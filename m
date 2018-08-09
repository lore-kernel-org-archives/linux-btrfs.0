Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730090AbeHIOPZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Aug 2018 10:15:25 -0400
Date: Thu, 9 Aug 2018 13:50:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: jkexcel <jkexcel@comcast.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
Message-ID: <20180809115046.GX3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1438689914.6655.1532811050018@connect.xfinity.com>
 <20180728213448.GA16016@DigitalMercury.dynalias.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180728213448.GA16016@DigitalMercury.dynalias.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 28, 2018 at 05:34:49PM -0400, Nicholas D Steeves wrote:
> On 28 July 2018 at 16:50, jkexcel <jkexcel@comcast.net> wrote:
> > I'm an end user trying to use btrfs-convert but when I installed
> > btrfs-tools and its dependency btrfs-progs on kubuntu 18.04, the
> > installation was successful, and it shows that v4.15.1-1build1 was
> > installed.
> >
> > However, when using the command  # brtfs-convert  /dev/sda4 (with the
> > drive unmounted) the resulting error appears "command not found"
> > I also tried command "btrfs convert" in case this was folded into the
> > main tool, but this also failed.
> >
> > 1. Is btrfs-convert still available?
> >
> > 2. Where can I find it?
> >
> > 3. Has btrfs-convert been replaced? what is it's new name?
> >
> > 4. Is it safe to use a downgraded version of btrfs-tools ie: 4.14 or
> > older?
> 
> You can blame me for that.  In Debian several users had reported
> release-critical issues in btrfs-convert, so I submitted a patch to
> disable it for the forseable future, eg:
> 
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=864798
>   https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854489

The reports are against version 4.7.3 released one year before the time
of the bug reports. The fix for the reported bug happened in 4.10, that
was half a year before the bug.

> Also, please consider the official status "As of 4.0 kernels this feature
> is not often used or well tested anymore, and there have been some reports
> that the conversion doesn't work reliably. Feel free to try it out, but
> make sure you have backups" (
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3 ).

Sorry that this you take it as official status. The wiki is open to
edits and such claims appear there from time to time. I've removed it,
it's been there since 2015 when it possibly was accurate but it's not
anymore.

> I'm happy to hear it is still disabled in Ubuntu, where many more
> users would be affected.  IIRC OpenSUSE LEAP and SLED 15 reenabled it
> (it was previously disabled there), so maybe it needs specific kernel
> versions or patches to not trigger RC bugs, and/or very specific
> btrfs-progs versions, and/or very specific e2fslibs, and/or specific
> combinations?  While I very much look forward to the day when
> btrfs-convert can be relied on in Debian, I don't think we're there
> yet.

So if there's no way to update package to newer version or nobody who
backports fixes, then it's better not to ship the tool. There's nothing
close to the 'specific version of X', besides using more up to date
versions. Alternatively, there could have been a separate package with
the convert tool, with a warning about the known issues.

It's in my interest to ship all tools in distros, but there's also only
that much what the upstream community can do. If you're going to
reconsider the status of btrfs-convert in Debian, please let me know.
