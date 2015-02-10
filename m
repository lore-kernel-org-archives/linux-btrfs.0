Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbBJTOp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 14:14:45 -0500
Date: Tue, 10 Feb 2015 20:14:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 09/16] Btrfs-progs: Introduce metadump_v2
Message-ID: <20150210191443.GD28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
 <1423512199-16552-10-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423512199-16552-10-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 03:03:12PM -0500, Josef Bacik wrote:
> The METADUMP super flag makes us skip doing the chunk tree reading which isn't
> helpful for the new restore since we have a valid chunk tree.  But we still want
> to have a way for the kernel to know that this is a metadump restore so it
> doesn't do things like verify data checksums.

BTW, the METADUMP superblock flag is not used in kernel.
