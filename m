Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60453 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbcCTMTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 08:19:40 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: lists@colorremedies.com, linux-btrfs@vger.kernel.org
Subject: Re: unable to mount btrfs partition, please help :(
Date: Sun, 20 Mar 2016 13:19:37 +0100
Message-ID: <2124409.2eB4lQbKqm@merkaba>
In-Reply-To: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
References: <trinity-864ec27a-d0e1-4c15-a29b-6eb23d63f8f5-1458465506167@3capp-gmx-bs14>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sonntag, 20. März 2016 10:18:26 CET Patrick Tschackert wrote:
> > I think in retrospect the safe way to do these kinds of Virtual Box
> > updates, which require kernel module updates, would have been to
> > shutdown the VM and stop the array. *shrug*
> 
>  
> After this, I think I'll just do away with the virtual machine on this host,
> as the app contained in that vm can also run on the host. I tried to be
> fancy, and it seems to needlessly complicate things.

I am not completely sure and I have no exact reference anymore, but I think I 
read more than once about fs benchmarks running faster in Virtualbox than on 
the physical system, which may point at an at least incomplete fsync() 
implementation for writing into Virtualbox image files.

I never found any proof of this nor did I specificially seeked to research it. 
So it may be true or not.

Thanks,
-- 
Martin
