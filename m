Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:44776 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab2ISSC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 14:02:27 -0400
Date: Wed, 19 Sep 2012 14:02:24 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "free space cache generation" ?
Message-ID: <20120919180224.GE2272@localhost.localdomain>
References: <50597CD5.5060001@petaramesh.org>
 <20120919160109.GC2272@localhost.localdomain>
 <505A013F.8000303@petaramesh.org>
 <20120919173628.GD2272@localhost.localdomain>
 <505A06DE.1050503@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <505A06DE.1050503@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 11:54:38AM -0600, Swâmi Petaramesh wrote:
> Le 19/09/2012 19:36, Josef Bacik a écrit :
> > It can happen for all sorts of different reasons. Did you have a
> > unclean unmount at some point?
> 
> Not that I'm aware of...
> 
> > Do you have a particularly full file system?
> 
> ~1 TB FS, 23% full...
> 
> Only, I have several Linux distros installed on the same BTRFS  - in
> different subvols - so I sometimes mount it with a 3.5.x kernel, and
> more rarely - but sometimes - with a 3.2.x...
> 

Well I think I changed the space cache format between those releases which would
cause them all to be discarded and remade.

> => Also I have to mention that I have lost a complete BTRFS FS, that was
> a /boot with snapshots. At some point it started to fail mounting, the
> kernel complaining that some trees (corresponding to removed snapshots
> as far as I could tell) were b0rked, and btrfsck couldn't help...
> 
> So I lost the FS - and lost quite a bit of confidence into BTRFS the
> same day... :-\
> 

Yes well, welcome to using an experimental file system.

Josef
