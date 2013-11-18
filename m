Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab3KRK5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 05:57:19 -0500
Date: Mon, 18 Nov 2013 11:57:17 +0100
From: David Sterba <dsterba@suse.cz>
To: jbacik@fusionio.com, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Btrfs: fix access_ok() check in btrfs_ioctl_send()
Message-ID: <20131118105717.GB5007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131021123004.GI1032@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131021123004.GI1032@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 21, 2013 at 02:30:05PM +0200, David Sterba wrote:
> On Thu, Jan 10, 2013 at 11:57:25AM +0300, Dan Carpenter wrote:
> > The closing parenthesis is in the wrong place.  We want to check
> > "sizeof(*arg->clone_sources) * arg->clone_sources_count" instead of
> > "sizeof(*arg->clone_sources * arg->clone_sources_count)".
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Original message id: <20130110085725.GA23063@elgon.mountain>
> 
> This patch hasn't been applied.

Please add this patch to btrfs-next.

david
