Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab3HHO2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 10:28:07 -0400
Date: Thu, 8 Aug 2013 16:28:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with enomem in the rewind path V3
Message-ID: <20130808142805.GX5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375909381-24516-1-git-send-email-jbacik@fusionio.com>
 <52034A94.9040003@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52034A94.9040003@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 09:36:52AM +0200, Jan Schmidt wrote:
> Weird patch formatting concerning extent_io.c, I assume there are no changes in
> extent_buffer_under_io and btrfs_release_extent_buffer_page, you just moved
> btrfs_clone_extent_buffer, right? Perhaps --patience or --minimal could do
> better? Otherwise,

git diff --patience produces identical result for me (1.8.3.1).

> Reviewed-by: Jan Schmidt <list.xfs@jan-o-sch.net>
                                 ^^^
xfs? :)
