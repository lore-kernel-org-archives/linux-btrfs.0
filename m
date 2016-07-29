Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36009 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcG2TPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 15:15:03 -0400
Received: by mail-pa0-f50.google.com with SMTP id pp5so33634860pac.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 12:15:02 -0700 (PDT)
Date: Fri, 29 Jul 2016 12:14:59 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: memory overflow or undeflow in free space tree / space_info?
Message-ID: <20160729191459.GB28505@vader>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
 <20160729191153.GA28505@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160729191153.GA28505@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost AG wrote:
> > Dear list,
> > 
> > i'm seeing btrfs no space messages frequently on big filesystems (> 30TB).
> > 
> > In all cases i'm getting a trace like this one a space_info warning.
> > (since commit [1]). Could someone please be so kind and help me
> > debugging / fixing this bug? I'm using space_cache=v2 on all those systems.
> 
> Hm, so I think this indicates a bug in space accounting somewhere else
> rather than the free space tree itself. I haven't debugged one of these
> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.

I should've asked, what sort of filesystem activity triggers this?

-- 
Omar
