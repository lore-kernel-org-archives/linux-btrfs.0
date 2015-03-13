Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbbCMNek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Mar 2015 09:34:40 -0400
Date: Fri, 13 Mar 2015 14:34:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] btrfs: handle ENOMEM in btrfs_alloc_tree_block
Message-ID: <20150313133439.GK20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1424773781.git.osandov@osandov.com>
 <b0a70e4ad3c51e6da22cc01fed1ced4f383c5f4c.1424773781.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b0a70e4ad3c51e6da22cc01fed1ced4f383c5f4c.1424773781.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2015 at 02:47:04AM -0800, Omar Sandoval wrote:
> This is one of the first places to give out when memory is tight. Handle
> it properly rather than with a BUG_ON.
> 
> Also fix the comment about the return value, which is an ERR_PTR, not
> NULL, on error.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
