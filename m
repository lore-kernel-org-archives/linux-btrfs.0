Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33844 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbDMVcT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 17:32:19 -0400
Received: by pacyx8 with SMTP id yx8so114952161pac.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 14:32:18 -0700 (PDT)
Date: Mon, 13 Apr 2015 14:32:17 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: ENOMEM bugfixes
Message-ID: <20150413213217.GA4857@mew.cs.washington.edu>
References: <cover.1424773781.git.osandov@osandov.com>
 <20150312044017.GA7693@mew>
 <20150313110430.GG20767@twin.jikos.cz>
 <20150313194342.GA10097@mew.dhcp4.washington.edu>
 <20150327210649.GA22047@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150327210649.GA22047@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 27, 2015 at 02:06:49PM -0700, Omar Sandoval wrote:
> On Fri, Mar 13, 2015 at 12:43:42PM -0700, Omar Sandoval wrote:
> > On Fri, Mar 13, 2015 at 12:04:30PM +0100, David Sterba wrote:
> > > On Wed, Mar 11, 2015 at 09:40:17PM -0700, Omar Sandoval wrote:
> > > > Ping. For anyone following along, it looks like commit cc87317726f8
> > > > ("mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change")
> > > > reverted the commit that exposed these bugs. Josef said he was okay with
> > > > taking these, will they make it to an upcoming -rc soon?
> > > 
> > > Upcoming yes, but based on my experience with pushing patches that are
> > > not really regressions in late rc's it's unlikely for 4.1.
> > 
> > Ok, seeing as these bugs are going to be really hard to trigger now that
> > the old GFP_FS behavior has been restored, I'm fine with waiting for the
> > next merge window.
> > 
> > Thank you!
> 
> Chris, would you mind taking these for a spin in your integration branch
> for the next merge window?
> 
> Thanks,
> -- 
> Omar

Ping.

-- 
Omar
