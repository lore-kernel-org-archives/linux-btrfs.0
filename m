Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbbEZQem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 12:34:42 -0400
Date: Tue, 26 May 2015 18:34:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] Btrfs: add missing free_extent_buffer
Message-ID: <20150526163440.GO23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432546215-10954-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432546215-10954-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 25, 2015 at 05:30:14PM +0800, Liu Bo wrote:
> read_tree_block may take a reference on the 'eb', a following
> free_extent_buffer is necessary.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
