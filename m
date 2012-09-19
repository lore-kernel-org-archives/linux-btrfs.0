Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:41768 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab2ISRgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 13:36:32 -0400
Date: Wed, 19 Sep 2012 13:36:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "free space cache generation" ?
Message-ID: <20120919173628.GD2272@localhost.localdomain>
References: <50597CD5.5060001@petaramesh.org>
 <20120919160109.GC2272@localhost.localdomain>
 <505A013F.8000303@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <505A013F.8000303@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 11:30:39AM -0600, Swâmi Petaramesh wrote:
> Le 19/09/2012 18:01, Josef Bacik a écrit :
> > Yeah I need to just put those under a DEBUG ifdef, they aren't a big
> > deal, just letting you know that the on disk cache is invalid and it
> > will have to put it together ye olde fashioned way.
> 
> ...But is it supposed to, and how to fix it ?

It can happen for all sorts of different reasons.  Did you have a unclean
unmount at some point?  Do you have a particularly full file system?  I recently
increased the size of the free space cache, so if you are not on a kernel with
that patch you are more likely to run out of space while writing out free space
cache and run into this problem.  Thanks,

Josef
