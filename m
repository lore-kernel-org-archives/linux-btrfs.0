Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35133 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbcECSDP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 14:03:15 -0400
Received: by mail-pf0-f179.google.com with SMTP id 77so13532632pfv.2
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 11:03:15 -0700 (PDT)
Date: Tue, 3 May 2016 11:03:11 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Paul Jones <paul@pauljones.id.au>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs goes readonly + No space left on 4.3
Message-ID: <20160503180311.GA7090@vader.DHCP.thefacebook.com>
References: <561B5AA6.7040704@profihost.ag>
 <5723C88F.30903@profihost.ag>
 <20160502220549.GB24432@vader.DHCP.thefacebook.com>
 <SYXPR01MB0367444E819E17AD264710969E7A0@SYXPR01MB0367.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <SYXPR01MB0367444E819E17AD264710969E7A0@SYXPR01MB0367.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 03, 2016 at 04:06:05AM +0000, Paul Jones wrote:
> > -----Original Message-----
> > From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> > owner@vger.kernel.org] On Behalf Of Omar Sandoval
> > Sent: Tuesday, 3 May 2016 8:06 AM
> > To: Stefan Priebe <s.priebe@profihost.ag>
> > Cc: linux-btrfs@vger.kernel.org
> > Subject: Re: btrfs goes readonly + No space left on 4.3
> > 
> > On Fri, Apr 29, 2016 at 10:48:15PM +0200, Stefan Priebe wrote:
> > > just want to drop a note that all those ENOSPC msg are gone with v4.5
> > > and space_cache=v2. Any plans to make space_cache=v2 default?
> > >
> > > Greets,
> > > Stefan
> > 
> > Yup, we want to make space_cache=v2 the default at some point. I'm
> > running it on my own machines and testing it here at Facebook and haven't
> > run into any issues yet. Besides stability, I also want to make sure there
> > aren't any performance regressions versus the old free space cache that we
> > haven't thought about yet.
> > 
> > Thanks for trying it out :)
> 
> I have also been testing it and have had no problems.
> 
> One question I have about it: I use Grub2 to boot my systems directly from a BTRFS root partition (i.e. no separate /boot), I assume Grub shouldn't need to care about free space tree/cache as it's only reading data? I don't know enough about either to know if it's an issue or not.
> 
> Thanks,
> Paul.

Yeah, the free space tree doesn't make a difference when the filesystem
is used read-only. In fact, you can mount a filesystem with
space_cache=v2 enabled read-only on older kernel versions.

-- 
Omar
