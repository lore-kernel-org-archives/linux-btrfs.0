Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab3GRRQc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 13:16:32 -0400
Date: Thu, 18 Jul 2013 19:16:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add missing error checks to add_data_references
Message-ID: <20130718171629.GM24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1373714715-10250-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373714715-10250-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 13, 2013 at 12:25:15PM +0100, Filipe David Borba Manana wrote:
> The function relocation.c:add_data_references() was not checking
> if all calls to __add_tree_block() and find_data_references() were
> succeeding or not.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
