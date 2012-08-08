Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:50679 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505Ab2HHR6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 13:58:36 -0400
Date: Wed, 8 Aug 2012 13:58:33 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
CC: Josef Bacik <JBacik@fusionio.com>, David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
Message-ID: <20120808175833.GC4185@shiny>
References: <20120808161819.GO25996@vicerveza.homeunix.net>
 <20120808173645.GA17430@twin.jikos.cz>
 <20120808174011.GD2141@localhost.localdomain>
 <20120808175606.GQ25996@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20120808175606.GQ25996@vicerveza.homeunix.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 11:56:06AM -0600, Lluís Batlle i Rossell wrote:
> On Wed, Aug 08, 2012 at 01:40:11PM -0400, Josef Bacik wrote:
> > On Wed, Aug 08, 2012 at 11:36:45AM -0600, David Sterba wrote:
> > > according to assembly, owner is in R15, BTRFS_FIRST_FREE_OBJECTID is
> > > 256, so owner == 1
> > 
> > This is fixed already in btrfs-next.  Thanks,
> 
> Ok, thank you.
> 
> Does it mean it will get into the next stable? Or it's for 3.6?
> 
> Is it only 'balance' that triggers it?

I'm bringing the fix in for my next pull request, so it will be
available against both 3.5 and 3.6

-chris
