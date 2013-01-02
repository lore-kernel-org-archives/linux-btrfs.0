Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49767 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3ABRcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jan 2013 12:32:32 -0500
Date: Wed, 2 Jan 2013 12:32:29 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Steffens <jan.steffens@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG during log recovery
Message-ID: <20130102173229.GA2389@localhost.localdomain>
References: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
 <20121218134007.GB2403@localhost.localdomain>
 <CAMQ-g0cywb_kDoV4Dj4fbSYj3JujvbouUvuXPWJyffskcKafBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMQ-g0cywb_kDoV4Dj4fbSYj3JujvbouUvuXPWJyffskcKafBA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 07:10:24AM -0700, Jan Steffens wrote:
> On Tue, Dec 18, 2012 at 2:40 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > On Fri, Dec 14, 2012 at 03:04:08PM -0700, Jan Steffens wrote:
> >> After a lockup requiring a hard reset, the btrfs could not be mounted,
> >> throwing the following error:
> >>
> >
> > Could you tell me what line this comes out to?  Give me a few lines of context
> > so I can figure out where it's happening.  Thanks,
> >
> > Josef
> 
> Sure, here:
> 

I posted a patch for this before I left for Christmas vacation, it is here

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=ee2399d8a7dd1d49b0996beaaaada5b728b35bf1

in btrfs-next.  Can you give it a whirl and let me know if it fixes your
problem?  Thanks,

Josef
