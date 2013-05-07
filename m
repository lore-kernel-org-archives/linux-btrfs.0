Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab3EGMZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 May 2013 08:25:33 -0400
Date: Tue, 7 May 2013 14:25:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix off-by-one in fiemap
Message-ID: <20130507122531.GG16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367425421-10598-1-git-send-email-bo.li.liu@oracle.com>
 <20130506194516.GL12414@localhost.localdomain>
 <20130507105248.GA27500@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130507105248.GA27500@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 07, 2013 at 06:52:49PM +0800, Liu Bo wrote:
> On Mon, May 06, 2013 at 03:45:16PM -0400, Josef Bacik wrote:
> > Can you make an xfstest for this so we can make sure we don't screw this up in
> > the future?  Thanks,
> 
> I wish I could, but I don't know how to test this in a xfstest case...
> David has made a debug checker in kernel to cover this.

If CONFIG_BTRFS_DEBUG is on, a test similar to what I used back then
would cover the boundary conditions.

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg21021.html

Looking at existing tests, 285 is a 'seek sanity test' that has several
subtests inside. This looks like the right place to put it in.

david
