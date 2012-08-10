Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23508 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223Ab2HJJuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 05:50:08 -0400
Date: Fri, 10 Aug 2012 11:49:59 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
Message-ID: <20120810094959.GT25996@vicerveza.homeunix.net>
References: <20120808161819.GO25996@vicerveza.homeunix.net>
 <20120808173645.GA17430@twin.jikos.cz>
 <20120808174011.GD2141@localhost.localdomain>
 <20120808175606.GQ25996@vicerveza.homeunix.net>
 <20120808175833.GC4185@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20120808175833.GC4185@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 01:58:33PM -0400, Chris Mason wrote:
> On Wed, Aug 08, 2012 at 11:56:06AM -0600, Lluís Batlle i Rossell wrote:
> > On Wed, Aug 08, 2012 at 01:40:11PM -0400, Josef Bacik wrote:
> > > On Wed, Aug 08, 2012 at 11:36:45AM -0600, David Sterba wrote:
> > > > according to assembly, owner is in R15, BTRFS_FIRST_FREE_OBJECTID is
> > > > 256, so owner == 1
> > > 
> > > This is fixed already in btrfs-next.  Thanks,
> > 
> > Ok, thank you.
> > 
> > Does it mean it will get into the next stable? Or it's for 3.6?
> > 
> > Is it only 'balance' that triggers it?
> 
> I'm bringing the fix in for my next pull request, so it will be
> available against both 3.5 and 3.6

Am I right that it is not in 3.5.1?

Regards,
Lluís.
