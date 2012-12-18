Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:34105 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab2LRNkJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 08:40:09 -0500
Date: Tue, 18 Dec 2012 08:40:07 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Steffens <jan.steffens@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG during log recovery
Message-ID: <20121218134007.GB2403@localhost.localdomain>
References: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 14, 2012 at 03:04:08PM -0700, Jan Steffens wrote:
> After a lockup requiring a hard reset, the btrfs could not be mounted,
> throwing the following error:
> 

Could you tell me what line this comes out to?  Give me a few lines of context
so I can figure out where it's happening.  Thanks,

Josef
