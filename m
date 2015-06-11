Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbFKRCS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:02:18 -0400
Date: Thu, 11 Jun 2015 19:02:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make receive work inside of subvolumes
Message-ID: <20150611170216.GF6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433963151-18488-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433963151-18488-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 03:05:51PM -0400, Josef Bacik wrote:
> Kind of a big feature of btrfs is being able to have a default subvol.  However
> the receive code generates the paths to the subvols from the root of the fs,
> even in the case of a default subvol.  So instead figure out if we're inside of
> a subvol, either because we have a different default or we've chroot'ed and are
> using -m.  Then strip this extra path off of the subvol we find so we can look
> up our parent properly.  Thanks
> 
> Reported-by: Neil Horman <nhorman@redhat.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Applied, thanks.
