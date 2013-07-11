Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42514 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3GKV2A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 17:28:00 -0400
Received: by mail-lb0-f179.google.com with SMTP id w20so6994496lbh.24
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 14:27:58 -0700 (PDT)
Date: Fri, 12 Jul 2013 01:25:31 +0400
From: Andrew Vagin <avagin@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: dsterba@suse.cz, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130711212531.GA11963@gmail.com>
References: <20130704095138.GB12359@gmail.com>
 <20130708215446.GH18204@twin.jikos.cz>
 <20130710163105.GR32502@wotan.suse.de>
 <20130710174545.GS32502@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
In-Reply-To: <20130710174545.GS32502@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 10:45:45AM -0700, Mark Fasheh wrote:
> On Wed, Jul 10, 2013 at 09:31:05AM -0700, Mark Fasheh wrote:
> > As far as I can tell we'll be carrying this patch until a better
> > solution is possible.
> > 
> > When that will happen, I don't know.
> > 	--Mark
> 
> Well, what do I get when I pretend I don't care any more? The little voice
> in my head says "keep plugging away". Here's another attempt at fixing this
> problem in a sane manner. Basically, this time we're adding a flag to
> s_flags which btrfs sets. Proc will see the flag and call ->getattr().
> 
> This compiles, but it needs testing (which I will get to soon). It still has
> a bunch of problems in my honest opinion but maybe if we get something
> acceptable upstream we can work from there.
> 
> Also, as Andrew pointed out there's more than one place which is return
> different device than from stat(2) so I probably need to update more sites
> to deal with this.

Yes, we need to fix unix_diag, fanotify fdinfo, ...

> 
> Does anyone see a problem with this approach?

Looks good for me. Thanks.

> 	--Mark
> 
> --
> Mark Fasheh
> 
