Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbbFBPgZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 11:36:25 -0400
Date: Tue, 2 Jun 2015 17:36:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: specify mountpoint for recieve
Message-ID: <20150602153623.GJ6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432749089-14663-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432749089-14663-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 27, 2015 at 01:51:29PM -0400, Josef Bacik wrote:
> In a chroot environment we may not have /proc mounted, which makes btrfs receive
> freak out since it wants to know the base directory where are are mounted for
> things like clone and such.  Give an option to specify where the mountpoint is
> in these cases so you can still do a btrfs receive in a chroot.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Applied, thanks.
