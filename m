Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:54335 "EHLO
	walhalla.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbbFXU0K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 16:26:10 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by walhalla.sjomar.eu (Postfix) with ESMTPSA id 8BF3B100284
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 22:26:06 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs release 4.1
Date: Wed, 24 Jun 2015 22:26:05 +0200
Message-ID: <2238718.GK9ft1D4VD@hoefnix>
In-Reply-To: <20150623144501.GE6761@twin.jikos.cz>
References: <20150622150023.GX6761@twin.jikos.cz> <7324923.Sa0lmcTP0G@hoefnix> <20150623144501.GE6761@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 23 June 2015 16:45:01 David Sterba wrote:
> On Tue, Jun 23, 2015 at 11:03:47AM +0200, Sjoerd wrote:
> > On Monday 22 June 2015 17:00:23 David Sterba wrote:
> > > btrfs-progs 4.1 have been released (in time with kernel 4.1). Unusual
> > > load
> > > of changes.
> > 
> > Would it be beneficial to update when using older kernels (3.19.x in my
> > case)? I can't upgrade to kernel 4.1 since my nvidia (propriety) drivers
> > won't support it (yet) :(
> 
> The userspace tools do not depend on kernel and can be safely used with
> older kernels, so I'd recommend to update.
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#Do_I_have_to_keep_my_btrfs-progs
> _at_the_same_version_as_my_kernel.3F --

Thanks for the link...I updated it...The updated version breaks the 
btrfsQuota.sh and btrfsQuota.py script from the wiki though :(

https://btrfs.wiki.kernel.org/index.php/Quota_support

I can live with that though ;)

Cheers,
Sjoerd

