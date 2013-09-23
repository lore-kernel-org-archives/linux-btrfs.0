Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3IWOiH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 10:38:07 -0400
Date: Mon, 23 Sep 2013 22:37:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstest/btrfs/001: fix the misuse of subvolume
 set-default
Message-ID: <20130923143755.GC18072@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1379926049-22135-1-git-send-email-bo.li.liu@oracle.com>
 <20130923131746.GA18681@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130923131746.GA18681@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 09:17:46AM -0400, Josef Bacik wrote:
> On Mon, Sep 23, 2013 at 04:47:29PM +0800, Liu Bo wrote:
> > The command is
> > btrfs subvolume set-default <subvolid> <path>.
> > 
> > It uses @subvolid to control the default subvolume and
> > @subvolid=0 has always been parsed into FS_TREE no matter
> > what subvolume @path points to.
> > 
> > So in order to set a subvolume to the default one, we need
> > to get the id of this subvolume first.
> > 
> > Also fix a typo:
> > s/sbuvolid/subvolid/g
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Sent a patch for this already.  Thanks,

oops, sorry I should have noticed that, any chance to fold the typo fix
into your patch?

-liubo
