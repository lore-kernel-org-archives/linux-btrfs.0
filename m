Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaBZSXW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 13:23:22 -0500
Date: Wed, 26 Feb 2014 19:23:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unneeded field / smaller extent_map
 structure
Message-ID: <20140226182321.GH16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1393337713-5991-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393337713-5991-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 25, 2014 at 02:15:12PM +0000, Filipe David Borba Manana wrote:
> We don't need to have an unsigned int field in the extent_map struct
> to tell us whether the extent map is in the inode's extent_map tree or
> not. We can use the rb_node struct field and the RB_CLEAR_NODE and
> RB_EMPTY_NODE macros to achieve the same task.
> 
> This reduces sizeof(struct extent_map) from 152 bytes to 144 bytes (on a
> 64 bits system).
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.cz>
