Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbaAHPO7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 10:14:59 -0500
Date: Wed, 8 Jan 2014 16:14:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Return EXDEV for cross file system snapshot
Message-ID: <20140108151457.GH6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52cd2c7c00011d8a00004f4e0000743e400004e23b8c@amlmta033.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52cd2c7c00011d8a00004f4e0000743e400004e23b8c@amlmta033.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 07:46:19PM +0900, Kusanagi Kouichi wrote:
> EXDEV seems an appropriate error if an operation fails bacause it
> crosses file system boundaries.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Reviewed-by: David Sterba <dsterba@suse.cz>
