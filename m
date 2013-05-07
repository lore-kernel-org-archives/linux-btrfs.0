Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34257 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab3EGKxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 06:53:06 -0400
Date: Tue, 7 May 2013 18:52:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix off-by-one in fiemap
Message-ID: <20130507105248.GA27500@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1367425421-10598-1-git-send-email-bo.li.liu@oracle.com>
 <20130506194516.GL12414@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130506194516.GL12414@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 06, 2013 at 03:45:16PM -0400, Josef Bacik wrote:
> On Wed, May 01, 2013 at 10:23:41AM -0600, Liu Bo wrote:
> > lock_extent/unlock_extent expect an exclusive end.
> > 
> 
> Can you make an xfstest for this so we can make sure we don't screw this up in
> the future?  Thanks,

Hi Josef,

I wish I could, but I don't know how to test this in a xfstest case...
David has made a debug checker in kernel to cover this.

thanks,
liubo
