Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935113AbdCXMPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 08:15:12 -0400
Date: Fri, 24 Mar 2017 13:14:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Sam Bull <sam.hacking@sent.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send non-root
Message-ID: <20170324121431.GO14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1489244085.6022.8.camel@sent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1489244085.6022.8.camel@sent.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 11, 2017 at 02:54:45PM +0000, Sam Bull wrote:
> I'm getting an error when trying to send a subvolume. I only seem to be
> able to do this as root. The subvolume was created by the user account,
> and not root. Could anybody shed some light on why this is failing? Is
> there a way to get it working?
> 
> $ btrfs send /var/spool/backups/hacking/2017-03-10 > something
> ERROR: cannot open '/': Operation not permitted

The send operation for non-root would need a full evaluation whether it
does not cross the permissions/security boundaries.

> Also appears I cannot even use btrfs subvolume show:
> 
> $ btrfs subvolume show /var/spool/backups/hacking/2017-03-10
> ERROR: can't perform the search - Operation not permitted
> ERROR: can't find 'var/spool/backups/hacking/2017-03-10'

The reason here is that the TREE_SEACH ioctl is used, that gives full
access to the internal structures and therefore is root-only. Many
'btrfs' subcommands utilize the flexibility of the ioctl as we don't
have tons of specialized ioctls, but this comes at some cost.
