Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sg2apc01on0057.outbound.protection.outlook.com ([104.47.125.57]:18272
	"EHLO APC01-SG2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750783AbcECEiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 00:38:24 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Omar Sandoval <osandov@osandov.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs goes readonly + No space left on 4.3
Date: Tue, 3 May 2016 04:06:05 +0000
Message-ID: <SYXPR01MB0367444E819E17AD264710969E7A0@SYXPR01MB0367.ausprd01.prod.outlook.com>
References: <561B5AA6.7040704@profihost.ag> <5723C88F.30903@profihost.ag>
 <20160502220549.GB24432@vader.DHCP.thefacebook.com>
In-Reply-To: <20160502220549.GB24432@vader.DHCP.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Omar Sandoval
> Sent: Tuesday, 3 May 2016 8:06 AM
> To: Stefan Priebe <s.priebe@profihost.ag>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: btrfs goes readonly + No space left on 4.3
> 
> On Fri, Apr 29, 2016 at 10:48:15PM +0200, Stefan Priebe wrote:
> > just want to drop a note that all those ENOSPC msg are gone with v4.5
> > and space_cache=v2. Any plans to make space_cache=v2 default?
> >
> > Greets,
> > Stefan
> 
> Yup, we want to make space_cache=v2 the default at some point. I'm
> running it on my own machines and testing it here at Facebook and haven't
> run into any issues yet. Besides stability, I also want to make sure there
> aren't any performance regressions versus the old free space cache that we
> haven't thought about yet.
> 
> Thanks for trying it out :)

I have also been testing it and have had no problems.

One question I have about it: I use Grub2 to boot my systems directly from a BTRFS root partition (i.e. no separate /boot), I assume Grub shouldn't need to care about free space tree/cache as it's only reading data? I don't know enough about either to know if it's an issue or not.

Thanks,
Paul.
