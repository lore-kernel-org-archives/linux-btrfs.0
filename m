Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:42611 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3FEPIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 11:08:47 -0400
Date: Wed, 5 Jun 2013 08:08:46 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: Josef Bacik <jbacik@fusionio.com>
cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: v3.9 bug at /fs/btrfs/free-space-cache.c:1567 after powercycle
In-Reply-To: <20130605125440.GA29248@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1306050808270.18155@cobra.newdream.net>
References: <alpine.DEB.2.00.1306042056350.19491@cobra.newdream.net> <20130605125440.GA29248@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 5 Jun 2013, Josef Bacik wrote:
> On Tue, Jun 04, 2013 at 09:59:05PM -0600, Sage Weil wrote:
> > Hi-
> > 
> > I'm pretty reliably triggering the following bug after powercycling an 
> > active btrfs + ceph workload and then trying to remount.  Is this a known 
> > issue?
> > 
> 
> Yeah sorry it's fixed in 3.10, I really need to send the patch back to stable.
> Thanks,
> 
> Josef

Cool.  Thanks!
sage
