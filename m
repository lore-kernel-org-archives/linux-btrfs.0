Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaJQQmG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 12:42:06 -0400
Date: Fri, 17 Oct 2014 18:42:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH] Btrfs-progs: check, ability to detect and fix outdated
 snapshot root items
Message-ID: <20141017164205.GN22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413566408-11979-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413566408-11979-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 06:20:08PM +0100, Filipe Manana wrote:
> This change adds code to detect and fix the issue introduced in the kernel
> release 3.17, where creation of read-only snapshots lead to a corrupted
> filesystem if they were created at a moment when the source subvolume/snapshot
> had orphan items. The issue was that the on-disk root items became incorrect,
> referring to the pre orphan cleanup root node instead of the post orphan
> cleanup root node.

Thanks, this is going to 3.17.
