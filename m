Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaJWNh5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 09:37:57 -0400
Date: Thu, 23 Oct 2014 15:37:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Poll: time to switch skinny-metadata on by default?
Message-ID: <20141023133755.GD22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141016113337.GC22943@twin.jikos.cz>
 <20141020163403.GW22943@twin.jikos.cz>
 <pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
 <CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
 <pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
 <CAAVQaYA9UWbF3ROXRRmcbKX9U7dwrT19Rc3NSX2vuzfVr3oXVA@mail.gmail.com>
 <pan$319b5$6b7e279$b22089f8$74c1c033@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$319b5$6b7e279$b22089f8$74c1c033@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 23, 2014 at 02:41:47AM +0000, Duncan wrote:
> Dave posted on Wed, 22 Oct 2014 08:49:46 -0400 as excerpted:
> 
> > On Tue, Oct 21, 2014 at 10:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> >> As for the mounted filesystem question, since all it does is flip a
> >> switch so that new metadata writes use the skinny-metadata code path,
> >> it shouldn't be a problem.
> > 
> > Nope.  Just tried it here:
> > 
> > # btrfs --version Btrfs v3.16.1-42-g140eccb
> > 
> > # btrfstune -x /dev/dm-0 /dev/dm-0 is mounted
> 
> Thanks.
> 
> So btrfstune refuses to set the skinny-metadata flag at all on mounted 
> devices.  Nicely reduces risk, /and/ answers the question. =:^)

btrfstune requires an unmounted device. The on-line change to features
is done via the sysfs interface, eg /sys/fs/btrfs/<UUID>/features, then
echo 1 > featurename. Right now only the extended refs (aka hardlink
limit) can be turned on.
