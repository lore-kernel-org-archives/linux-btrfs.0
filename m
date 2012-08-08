Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60609 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964821Ab2HHR4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2012 13:56:14 -0400
Date: Wed, 8 Aug 2012 19:56:06 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG on 3.5.0
Message-ID: <20120808175606.GQ25996@vicerveza.homeunix.net>
References: <20120808161819.GO25996@vicerveza.homeunix.net>
 <20120808173645.GA17430@twin.jikos.cz>
 <20120808174011.GD2141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20120808174011.GD2141@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 08, 2012 at 01:40:11PM -0400, Josef Bacik wrote:
> On Wed, Aug 08, 2012 at 11:36:45AM -0600, David Sterba wrote:
> > according to assembly, owner is in R15, BTRFS_FIRST_FREE_OBJECTID is
> > 256, so owner == 1
> 
> This is fixed already in btrfs-next.  Thanks,

Ok, thank you.

Does it mean it will get into the next stable? Or it's for 3.6?

Is it only 'balance' that triggers it?

Regards,
Lluís.
