Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:35124 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbbC0VGw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 17:06:52 -0400
Received: by pdbop1 with SMTP id op1so107531898pdb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 14:06:52 -0700 (PDT)
Date: Fri, 27 Mar 2015 14:06:49 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] btrfs: ENOMEM bugfixes
Message-ID: <20150327210649.GA22047@mew>
References: <cover.1424773781.git.osandov@osandov.com>
 <20150312044017.GA7693@mew>
 <20150313110430.GG20767@twin.jikos.cz>
 <20150313194342.GA10097@mew.dhcp4.washington.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150313194342.GA10097@mew.dhcp4.washington.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 12:43:42PM -0700, Omar Sandoval wrote:
> On Fri, Mar 13, 2015 at 12:04:30PM +0100, David Sterba wrote:
> > On Wed, Mar 11, 2015 at 09:40:17PM -0700, Omar Sandoval wrote:
> > > Ping. For anyone following along, it looks like commit cc87317726f8
> > > ("mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change")
> > > reverted the commit that exposed these bugs. Josef said he was okay with
> > > taking these, will they make it to an upcoming -rc soon?
> > 
> > Upcoming yes, but based on my experience with pushing patches that are
> > not really regressions in late rc's it's unlikely for 4.1.
> 
> Ok, seeing as these bugs are going to be really hard to trigger now that
> the old GFP_FS behavior has been restored, I'm fine with waiting for the
> next merge window.
> 
> Thank you!

Chris, would you mind taking these for a spin in your integration branch
for the next merge window?

Thanks,
-- 
Omar
