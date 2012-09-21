Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54137 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab2IUPOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 11:14:40 -0400
Date: Fri, 21 Sep 2012 17:14:32 +0200
From: David Sterba <dave@jikos.cz>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs-progs: fix the btrfs-debug-tree usage
Message-ID: <20120921151432.GT17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348210784-29681-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348210784-29681-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 02:59:44PM +0800, Anand jain wrote:
> @@ -51,6 +51,8 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
>  					     btrfs_node_blockptr(eb, i),
>  					     size,
>  					     btrfs_node_ptr_generation(eb, i));
> +		if(!next)
> +			BUG();

Is there a better way how to get out of this? btrfs-debug-tree is aimed
to help debugging, I don't want to see it crashed if there's some
inconsistency found, rather report it, that's a valuable information.

david
