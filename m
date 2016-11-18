Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55233 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752430AbcKRO7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 09:59:17 -0500
Date: Fri, 18 Nov 2016 15:59:11 +0100
From: David Sterba <dsterba@suse.cz>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: remove rb_node field from the delayed ref node
 structure
Message-ID: <20161118145911.GZ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1479461924-25986-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479461924-25986-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 09:38:44AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> After the last big change in the delayed references code that was needed
> for the last qgroups rework, the red black tree node field of struct
> btrfs_delayed_ref_node is no longer used, so just remove it, this helps
> us save some memory (since struct rb_node is 24 bytes on x86_64) for
> these structures.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
