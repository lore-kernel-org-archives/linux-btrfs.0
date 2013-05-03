Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55535 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762019Ab3ECUdt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 16:33:49 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9157A7C042F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 14:33:49 -0600 (MDT)
Date: Fri, 3 May 2013 16:33:44 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: use only memmove_extent_buffer and simplify the
 helpers
Message-ID: <20130503203344.GE12414@localhost.localdomain>
References: <1367242681-8835-1-git-send-email-dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1367242681-8835-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 29, 2013 at 07:38:01AM -0600, David Sterba wrote:
> After commit a65917156e34594 ("Btrfs: stop using highmem for
> extent_buffers") we don't need to call kmap_atomic anymore and can
> reduce the move_pages helper to a simple memmove.
> 
> There's only one caller of memcpy_extent_buffer, we can use the
> memmove_ variant here.
> 

This makes -l 64k blow the hell up, just try generic/001.  I'm kicking this
patch out.  Thanks,

Josef
